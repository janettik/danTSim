#####################################################################
#  Purpose: Determine what is causing convergence errors in glmer
#  Date: 08/06/2012
#
######################################################################
library(lme4)
setwd( 'C:/Users/janettik/Documents/tancredi')
load('listK10N13kS130.rdata')
load('resultK10N13kS130.rdata')


list1 = listK10N13kS130
result1 = resultK10N13kS130

res = result1[[4]][[3]]
w = sapply(res, function(x){ is.na(as.character(x$glmer)) == FALSE})

index = seq_along(w)[w]

list_prob = lapply(index, function(j){ list1[[4]][[j]] })

list_err = lapply(index, function(j){  res[[j]] })


#-------try-------------------
data = list_prob[[1]]
#glimmix-like approach
  #glimmix-like approach 
  #get starting values
  glm0= glm(rBern ~ timeID, data = data, family = binomial)
  
  glmer =  glmer(formula = rBern ~ factor(timeID) +(1 | subjectID), family ='binomial',
                    data = data,
                    start = list(fixef = coef(glm0)),
                    scale = .5,
                    verbose = TRUE) 
                     
   glmer =  glmer(formula = rBern ~ factor(timeID) +(1 | subjectID), family ='binomial',
                    data = data,
                    start = list(fixef = c(0,1)),
                    verbose = TRUE,
                    control = list(maxIter = 1000)) 
                    
    data$time2 = data$timeID-1
    data$time3 = data$time2/1000                
     glmer =  glmer(formula = rBern ~ time3 +(1 | subjectID), family ='binomial',
                    data = data,
                    start = list(fixef = c(0,0)),
                    verbose = TRUE) 
                    
                                       
  glmer0 =  glmer(formula = rBern ~ (1 | subjectID), family ='binomial',
                    data = data,
                    start = list(fixef = coef(glm0)[1]),
                    verbose = TRUE) 
                  
