#####################################################################
#
#   Purpose: Function to simulate data for D. Tancredi's
#             cluster adjusted test of association in nx2 tables
#   By: Jasmine
#   Date: 06/21/2012
#   Updated: 07/23/2012
####################################################################

library(survey)
library(lme4)

#nclust = Number of clusters
#
#You must supply either ratio, var1 and ratio, or var1 and var2.
#var1 = variance for clinic component
#var2 = variance for person component
#ratio = ratio of var2 to var1
#ns = Vector containing number of subjects with both pre/post,
#      number with just pre, and number with just post. Default is
#      100 subjects with both observations.

simCorData = function(nclust,
                      var1=NULL,
                      var2= NULL,
                      ratio=NULL,
                      ns = c(both = 100, preOnly = 0, postOnly = 0)
                      ){

  # Error checking function arguments
  if(is.null(var1) == TRUE){
    var1 = pi^2/54
  }
  if(is.null(var2) == TRUE){
    if(is.null(ratio) == TRUE){
      print('Error: You must supply either (var1, var2), (var1, ratio), or ratio')
    }else{
      var2 = var1*ratio
    }
  }
  

  #get max N
  maxN = sum(ns)+ ns[1]
  uniqueN = sum(ns)
  
  #create subject IDs
  subjectIDlist = 1:uniqueN
  subjectID = unlist(lapply(1:uniqueN,
              function(x){
                if(x <= ns[1]){
                  rep(x,2)
                }else{
                  x
                }
              }))
              
  #assign clusters
  clustAssign = sample(1:nclust, uniqueN, replace =T)
  clusterID = clustAssign[subjectID]
  
  #Assign timepoint IDs
  timeID = c( rep( c(1,2), ns[1]), rep(1, ns[2]), rep(2, ns[3]))
  
  #Create dataframe
  dataF = data.frame(subjectID= subjectID, clusterID= clusterID,
                      timeID = timeID)

  #get random component of cluster and add to dataframe
  gamma_c = rnorm(nclust, 0, sd = sqrt(var1))
  dataF$gamma = gamma_c[ dataF$clusterID ]
  
  #get random component representing a person within a clinic  and add to dataframe
  delta_ci= rnorm(uniqueN, 0, sd = sqrt(var2))
  dataF$delta = delta_ci[ dataF$subjectID ]
  
  #Set up eta and pi
  dataF$eta = with(dataF, delta + gamma)
  dataF$pi = with(dataF, (1+ exp(-eta))^-1)
  
  #get random bernoullis
  rBern = sapply(dataF$pi, rbinom, size = 1, n = 1)

  dataF$rBern = rBern
  dataF

}

#write function to run simCor function and save data

getReplicates= function(numRep,
                        nclust = 10,
                        ratioList = list(.5, 1, 2, 4),
                        ntype = c(130,0,0)){

  #for each combo, run the function at those settings numRep times
  out1 = lapply(1:length(ratioList), function(i){
  
    out2 = lapply(1:numRep, function(j){
  
      x = simCorData(nclust = nclust,
                      ratio = ratioList[[ i ]],
                      ns = ntype)

      x$ratio = rep(ratioList[[ i ]], nrow(x))
      x$sampleN = rep( paste( ntype, collapse = ','),nrow(x))
      x$repID = rep(j,nrow(x))
      x$setID = paste( x$repID, x$ratio, x$sampleN, sep = ' ')
      x$typeID = paste('ratio=',x$ratio,
                                  'sampleN=', x$sampleN, sep = ' ')
      x$weight = 1
      x$fpc1 = 0.95
      x$fpc2 = 0.95
      x$rBern = factor(x$rBern)
      x
    })

    out2
  })
  
  out1
  
}

  tryCatch.W.E <- function(expr)
 {
     W <- NULL
     w.handler <- function(w){ # warning handler
       W <<- w
       invokeRestart("muffleWarning")
     }
     list(value = withCallingHandlers(tryCatch(expr, error = function(e) e),
                                    warning = w.handler),
        warning = W)
 }
 

getPs = function(data){

  data$timeID = factor(data$timeID)
  
  ts_design= svydesign(id = ~ clusterID, 
            fpc =~fpc1, data = data)

  #non-survey adjusted chi-square          
  regChi = chisq.test(with(data, table(timeID, rBern))) 
  
  #survey adjusted Wald
  svyWald0 = tryCatch.W.E(svychisq(~rBern+timeID, design = ts_design,
                      statistic = 'adjWald') )
                  
  #survey adjusted Rao-Scott                    
  svyRao0 = tryCatch.W.E( svychisq(~rBern+timeID, design = ts_design,
                      statistic = "F") )
  
  #survey adjusted glm                    
  svyGLM0 = tryCatch.W.E(svyglm(rBern ~ timeID, design =ts_design, family = 'binomial'))
  
  #glimmix-like approach - REML version
  #get starting values
  glm0= glm(rBern ~ timeID, data = data, family = binomial)
  
  glmer1r = tryCatch.W.E(
            glmer(formula = rBern ~ timeID +(1 | clusterID) +(1 |subjectID) , family ='binomial',
                    data = data,
                    start = list(fixef = coef(glm0)))  )
                    
  glmer0r =  tryCatch.W.E(
                glmer(formula = rBern ~ (1 | clusterID) +(1 |subjectID), family ='binomial',
                    data = data,
                    start = list(fixef = coef(glm0)[1])) )
    
  #likelihood ratio test for glmer p-value
  x = glmer1r$value
  y= glmer0r$value
  glmer.pr = anova(x,y)[2,7]
  #Z-based p-value for glmer
  z = abs(fixef(x)[2]/sqrt(vcov(x)[2,2]))
  glmer.zpr = pnorm(-z)*2

  #glimmix-like approach - ML version
  #get starting values
  glmer1m = tryCatch.W.E(
            glmer(formula = rBern ~ timeID +(1 | clusterID) +(1 |subjectID) , family ='binomial',
                    data = data, REML = FALSE,
                    start = list(fixef = coef(glm0)))  )
                    
  glmer0m =  tryCatch.W.E(
                glmer(formula = rBern ~ (1 | clusterID) +(1 |subjectID), family ='binomial',
                    data = data, REML = FALSE,
                    start = list(fixef = coef(glm0)[1])) )
    
  #likelihood ratio test for glmer p-value
  x = glmer1m$value
  y= glmer0m$value
  glmer.pm = anova(x,y)[2,7]

  #Z-based p-value for glmer
  z = abs(fixef(x)[2]/sqrt(vcov(x)[2,2]))
  glmer.zpm = pnorm(-z)*2

  
  #proper survey adjusted method
  ts_design2= svydesign(id = ~ clusterID + subjectID, 
                               fpc = ~ fpc1+ fpc2, data = data)
                                                           
  #2 level survey adjusted Wald
  svyWald02 = tryCatch.W.E(svychisq(~rBern+timeID, design = ts_design2,
                      statistic = 'adjWald') )
                      
  #2 level survey adjusted Rao-Scott                    
  svyRao02 = tryCatch.W.E( svychisq(~rBern+timeID, design = ts_design2,
                      statistic = "F") )
  
  #2 level survey adjusted glm                    
  svyGLM02 = tryCatch.W.E(svyglm(rBern ~ timeID, design =ts_design2, 
                              family = 'binomial'))
  #initialize errorList
  errorList = list(NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)
  
  #deal with errors
  if(any(class(svyWald0$value) == 'error')){
    svyWaldp = NA
    errorList[[1]] = svyWald0$value
  }else{
    svyWaldp = svyWald0$value$p.value
  }
  
  if(any(class(svyRao0$value) == 'error')){
    svyRaop = NA
    errorList[[2]] = svyRao0$value
  }else{
    svyRaop = svyRao0$value$p.value
  }
  
  if(any(class(svyGLM0$value) == 'error')){
    svyRegp = NA
    errorList[[3]] = svyGLM0$value
  }else{
    svyRegp = summary(svyGLM0$value)$coefficients[2,4]
  }
  
  
    if(any(class(svyWald02$value) == 'error')){
    svyWaldp2 = NA
    errorList[[4]] = svyWald02$value
  }else{
    svyWaldp2 = svyWald02$value$p.value
  }
  
  if(any(class(svyRao02$value) == 'error')){
    svyRaop2 = NA
    errorList[[5]] = svyRao02$value
  }else{
    svyRaop2 = svyRao02$value$p.value
  }
  
  if(any(class(svyGLM02$value) == 'error')){
    svyRegp2 = NA
    errorList[[6]] = svyGLM02$value
  }else{
    svyRegp2 = summary(svyGLM02$value)$coefficients[2,4]
  }
  
  errorList[[7]] = if(is.null(glmer1r$warning) == TRUE){
                      NA
                    }else{
                      glmer1r$warning
                    }
  errorList[[8]] = if(is.null(glmer0r$warning) == TRUE){
                      NA
                    }else{
                      glmer0r$warning
                    }
    errorList[[9]] = if(is.null(glmer1m$warning) == TRUE){
                      NA
                    }else{
                      glmer1m$warning
                    }
  errorList[[10]] = if(is.null(glmer0m$warning) == TRUE){
                      NA
                    }else{
                      glmer0m$warning
                    }
  
  exact = fisher.test(table(data$timeID, data$rBern))$p.value
  names(errorList) = c('Wald', 'Rao', 'svyGLM', 'Wald2', 'Rao2', 'svyGLM2',
                          'glmer1r', 'glmer0r', 'glymer1m', 'glmer0m')
  
  pVs = list( regChi$p.value, svyWaldp, svyRaop, svyRegp, 
                 svyWaldp2, svyRaop2, svyRegp2, 
                  glmer.pr, glmer.zpr,  glmer.pm, glmer.zpm, exact,
                 summary(glm0)$coefficients[2,4],  errorList)
  
  names(pVs) = c('regChi', 'wald', 'rao', 'svreg', 
                  'wald2', 'rao2', 'svreg2', 
                  'glmerLRTr', 'glmerZr', 'glmerLRTm', 'glmerZm','exactp',
                  'plainglm', 'errors')
  
  pVs        
}

#function to go through each sample type and run the getPs function
getResults = function(data){

  results =
    lapply(seq_along(data),
      function(i){

        result0 = 
          lapply(seq_along(data[[i]]),
          function(j){
          
            if(j %% 50 == 0){
              gc()
              print(paste(i,j , Sys.time(), sep = ' '))
              flush.console()
            }
            getPs( data[[i]][[j]])

          })
          
          
        result0[[length(result0)+1]] = data[[i]][[1]]$typeID[1]
        
        result0
    })
}

# results processing splits up the results and the errors into different
#  parts of the data structure
processResults = function(resultList){
                      
  out1 = 
  lapply(resultList, function(x){
  
    #keep name but pull it off of list
    type = x[[length(x)]]
    x[[ length(x) ]] = NULL
    
    #initialize storage for error messages and p-values
    errorList = vector("list",length(x)) 
    pMat = matrix(NA, nrow = length(x), ncol = length(x[[1]])-1)
    
    #separate errors and p-values 
    for(i in seq_along(x)){
      errorList[[i]] = x[[i]]$errors
      x[[i]]$errors = NULL
      pMat[i,] = unlist(x[[i]])
    }
    
    dimnames(pMat)[[2]] = names(x[[1]])
    list(type, pMat, errorList)
    
  })
  
}

#look at p-value nominal error rate and error rates
sumzP= function(results){
  lapply(seq_along(results), function(j){
  
    #get glmer warning indeces
    warnGlmer= checkWarningsInternal(results[[j]])
    emp = apply( results[[j]][[2]], 2, function(x){
                    errors = length(seq_along(x)[is.na(x) == TRUE])
                    nom1 = length(seq_along(x)[x < 0.05])/(length(x)-errors)
                    rbind(nom1, errors)
                    })
    
    #nominal error rate for LRTm
    d1m = match('glmerLRTm', dimnames(results[[j]][[2]])[[2]] ) 
    x = results[[j]][[2]][ , d1m]
    lrtm_ok = x[-unique( unlist( c(warnGlmer$gl1m, warnGlmer$gl0m)) )] 
    lrtm_err = length(unique(unlist(c(warnGlmer$gl1m, warnGlmer$gl0m))))              
    emp_glmLRTm =length(seq_along(lrtm_ok)[lrtm_ok < 0.05])/length(lrtm_ok)

    #nominal error rate for LRTr
    d1r = match('glmerLRTr', dimnames(results[[j]][[2]])[[2]] ) 
    x = results[[j]][[2]][ , d1r]
    lrtr_ok = x[-unique(unlist(c(warnGlmer$gl1r, warnGlmer$gl0r) ))] 
    lrtr_err = length( unique(unlist( c(warnGlmer$gl1r, warnGlmer$gl0r) ) ) )              
    emp_glmLRTr =length(seq_along(lrtr_ok)[lrtr_ok < 0.05])/length(lrtr_ok)
    
    #coverge for glmzm
    dzm = match('glmerZm', dimnames(results[[j]][[2]])[[2]] ) 
    x = results[[j]][[2]][, dzm]
    zm_ok = x[-warnGlmer$gl1m]
    zm_err = length(warnGlmer$gl1m)
    empm_glmz =length(seq_along(zm_ok)[zm_ok < 0.05])/length(zm_ok)
    
    #coverge for glmzr
    dzr = match('glmerZr', dimnames(results[[j]][[2]])[[2]] ) 
    x = results[[j]][[2]][, dzr]
    zr_ok = x[-warnGlmer$gl1r]
    zr_err = length(warnGlmer$gl1r)
    empr_glmz =length(seq_along(zr_ok)[zr_ok < 0.05])/length(zr_ok)
    
    

    emp[,d1m] = c(emp_glmLRTm, lrtm_err)
    emp[,d1r] = c(emp_glmLRTr, lrtr_err)
    emp[,dzm] = c(empm_glmz, zm_err)
    emp[,dzr] = c(empr_glmz, zr_err)
     
    #get differences between 1 and 2 level p-values                 
    res = as.data.frame(results[[j]][[2]] )
    raodiff = res$rao - res$rao2
    walddiff = res$wald - res$wald2
    svydiff = res$svreg -res$svreg2
    
    list(emp, raodiff, walddiff, svydiff)
  })
}


#function to figure out which glmer instances have convergence warnings
checkWarningsInternal= function(results0){

    res = results0[[3]]
    
    glmW = do.call('rbind', 
    lapply(seq_along(res), function(j){
    
     x = res[[j]] 
     if(is.na(x$glmer1r[1]) == FALSE){
      numr = j
     }else{ 
      numr = NA
     }

     if(is.na(x$glymer1m[1]) == FALSE){
      numm= j
     }else{ 
      numm = NA
     }
     
     if(is.na(x$glmer0r[1]) == FALSE){
      num0r= j
     }else{ 
      num0r = NA
     }

     if(is.na(x$glmer0m[1]) == FALSE){
      num0m= j
     }else{ 
      num0m = NA
     }
     
     c(numr, numm, num0r,num0m)
    }))
    
    #pull out non.na values for each column of the matrix
    list(gl1r = glmW[is.na(glmW[,1]) ==FALSE,1], 
         gl1m = glmW[is.na(glmW[,2]) ==FALSE,2],
         gl0r = glmW[is.na(glmW[,3]) ==FALSE,3], 
         gl0m= glmW[is.na(glmW[,4]) ==FALSE,4])
       
}

