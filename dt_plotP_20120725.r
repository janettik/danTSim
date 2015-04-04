# Purpose: Plot p-value results
# BY: Jasmine Nettiksimmons
# Date: 07/25/2012
#------------------------------------------------------------------

library(lattice)


load('resultK10N13kS100.rdata')
load('resultK10N13kS130.rdata')
load('resultK3N13kS100.rdata')

#-------------------------------------------------------------------
#   functions
#-------------------------------------------------------------------
plotRegChi = function(resultList, main= NULL){

latdat = do.call('rbind', lapply(seq_along(resultList),
          function(i){
          x = as.data.frame(resultList[[i]][[2]])
          x$ratio= paste('Ratio = ', i, sep = '')
          x
          }))

densityplot(~regChi | factor(ratio), data = latdat,
        main = main)

}

plotLev12 = function(res, title = NULL){

res = as.data.frame(res)
res = res[order(res$regChi),]

par(mar = c(4,4,3,1), mfrow = c(1,3))

plot( res$wald,res$wald2, pch =19, cex = .1, col = 'lightblue',
    xlab = '1 level',
    ylab = '2 level',
    main = paste(title, '- Wald'))
lines(abline(0,1,lty = 2))
lines(c(.05, .05), c(0, .05), lty = 3)
lines(c(0, .05), c(.05, .05), lty = 3)

plot(res$rao, res$rao2, pch = 19, cex = .1, col = 'red',
    xlab = '1 level',
    ylab = '2 level',
    main = paste(title, '- Rao'))
lines(abline(0,1,lty = 2))
lines(c(.05, .05), c(0, .05), lty = 3)
lines(c(0, .05), c(.05, .05), lty = 3)

plot(res$svreg, res$svreg2, pch = 19, cex = .1, col = 'seagreen',
    xlab = '1 level',
    ylab = '2 level',
    main = paste(title, '- SvyReg'))
lines(abline(0,1,lty = 2))
lines(c(.05, .05), c(0, .05), lty = 3)
lines(c(0, .05), c(.05, .05), lty = 3)

}


plotRanges= function(resultList){
mycol = c('cyan1','cyan4',
        'darkorchid2','darkorchid4',
         'firebrick1' ,  'firebrick3',
         'olivedrab2','olivedrab4'
          )

for(i in seq_along(resultList)){

 dev.new()
  plot(c(0,1), c(0,1), type = 'n',
        xlab = 'Regular chi-square interval',
        ylab = 'P-value',
        main = paste('Ratio =', c(0.5, 1, 2, 4)[i]))

  res= as.data.frame(resultList[[i]][[2]])
  nameorder = c('regChi', 'wald', 'wald2', 'rao', 'rao2','svreg',
              'svreg2', 'glmerLRT', 'glmerZ')
  res= res[, match( nameorder,names(res))]

  cutChi= cut(res$regChi,30)

  ranges =
  lapply(seq_along(unique(cutChi)), function(j){

    temp = res[cutChi== unique(cutChi)[j],-1]
    cmn = colMeans(temp, na.rm=T)
    mn = apply(temp, 2, min, na.rm=T)
    mx = apply(temp, 2, max, na.rm=T)

    x = as.character(unique(cutChi)[j] )
    x1 = as.numeric(strsplit(x, '\\(|\\]|,')[[1]][2:3])

    for(k in 1:(ncol(res)-1)){
      xp = x1[1] + k*(x1[2]-x1[1])/(ncol(res)-1)
      points(xp, cmn[k], col= mycol[k], pch = 19, cex =.5)
      lines(rep(xp,2), c(mn[k], mx[k]), col = mycol[k])
    }
    legend(.22,.98, col = mycol, legend = nameorder[-1], pch= 19, lty = 1)
    abline(0,1,lty = 2)
  })
  

}
}

#----------------------------------------------------------
#   running functions
#----------------------------------------------------------

#compare level 1 plots with level 2 plots
plotLev12(res, title = 'K=10; S = 130,0,0; Ratio = 0.5')

plotLev12(res2, title = 'K=10; S = 130,0,0; Ratio = 1.0')

plotLev12(res3, title = 'K=10; S = 130,0,0; Ratio = 2.0')

plotLev12(res4, title = 'K=10; S = 130,0,0; Ratio = 4.0')