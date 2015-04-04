##############################################################################
#  Purpose: Export simulation data to evaluate in glimmix
#  Date: 09/04/2012
#
##############################################################################

#-----------------------------------------------------------------------------


pullList = function(dlist, name){

  temp= do.call('rbind', lapply(1:4, function(i){

    index = seq_along(dlist[[i]])
    
    list_prob = do.call('rbind', lapply(index, function(j){
                  L = dlist[[i]][[j]]
                  L$id = j
                  L$rBern = as.numeric(as.character(L$rBern))
                  L
                  }))
  }))


write.table(temp, file = name, 
              row.names = FALSE, sep = ',')

}


#k = 10
load('listK10N13kS130.rdata')
pullList(listK10N13kS130, 'tableK10S130.csv')

load('listK10N13kS100.rdata')
pullList(listK10N13kS100, 'tableK10S100.csv')

load('listK10N13kS1003030.rdata')
pullList(listK10N13kS1003030, 'tableK10S1003030.csv')

#k = 3
load('listK3N13kS130.rdata')
pullList(listK3N13kS130, 'tableK3S130.csv')

load('listK3N13kS100.rdata')
pullList(listK3N13kS100, 'tableK3S100.csv')

load('listK3N13kS1003030.rdata')
pullList(listK3N13kS1003030, 'tableK3S1003030.csv')

#k = 20
load('listK20N13kS130.rdata')
pullList(listK20N13kS130, 'tableK20S130.csv')

load('listK20N13kS100.rdata')
pullList(listK20N13kS100, 'tableK20S100.csv')

load('listK20N13kS1003030.rdata')
pullList(listK20N13kS1003030, 'tableK20S1003030.csv')





