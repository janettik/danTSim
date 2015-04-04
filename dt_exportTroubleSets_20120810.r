##############################################################################
#  Purpose: Export problemmatic data scenarios to try in SAS glimmix
#  Date: 08/10/2012
#
##############################################################################

setwd( 'C:/Users/janettik/Documents/tancredi')
#-----------------------------------------------------------------------------


pullOutBad = function(dlist, result){

list1 = dlist
result1 = result

  do.call('rbind', lapply(1:4, function(i){

  res = result1[[i]][[3]]
  w = sapply(res, function(x){ is.na(as.character(x$glmer)) == FALSE})

  index = seq_along(w)[w]

  list_prob = do.call('rbind', lapply(index, function(j){
                L = list1[[i]][[j]]
                L$id = j
                L$rBern = as.numeric(as.character(L$rBern))
                L
                }))
  }))
}
#-------------------------------------------------------------------------

load('listK10N13kS130.rdata')
load('resultK10N13kS130.rdata')

forSASK10S130 = pullOutBad(listK10N13kS130, resultK10N13kS130)
forSASK10S130$runID = with(forSASK10S130, paste(ratio, id))

write.table(forSASK10S130, file = 'forSASK10S130.csv', sep = ',',
                row.names = FALSE)


load('listK10N13kS100.rdata')
load('resultK10N13kS100.rdata')

forSASK10S100 = pullOutBad(listK10N13kS100, resultK10N13kS100)
forSASK10S100$runID = with(forSASK10S100, paste(ratio, id))

write.table(forSASK10S100, file = 'forSASK10S100.csv', sep = ',',
                row.names = FALSE)