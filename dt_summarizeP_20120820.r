#----------------------------------------------------------------
# Purpose: Evaluate coverage and differences of p-values
# BY: Jasmine Nettiksimmons
# Date: 07/16/2012
#------------------------------------------------------------------

setwd( 'C:/Users/janettik/Documents/tancredi')
source('C:/Users/janettik/Documents/tancredi/dt_simFunctions_20120820.r')

#-------------------------------------------------------------------------


load('resultK10N13kS100.rdata')
pProf_K10N13kS100 = sumzP(resultK10N13kS100)
save(pProf_K10N13kS100, file = 'pProf_K10N13kS100.rdata')

load('resultK10N13kS130.rdata')
pProf_K10N13kS130 = sumzP(resultK10N13kS130)
save(pProf_K10N13kS130, file = 'pProf_K10N13kS130.rdata')

load('resultK10N13kS1003030.rdata')
pProf_K10N13kS1003030 = sumzP(resultK10N13kS1003030)
save(pProf_K10N13kS1003030, file = 'pProf_K10N13kS1003030.rdata')

load('resultK3N13kS100.rdata')
pProf_K3N13kS100 = sumzP(resultK3N13kS100)
save(pProf_K3N13kS100, file = 'pProf_K3N13kS100.rdata')

load('resultK3N13kS130.rdata')
pProf_K3N13kS130 = sumzP(resultK3N13kS130)
save(pProf_K3N13kS130, file = 'pProf_K3N13kS130.rdata')

load('resultK3N13kS1003030.rdata')
pProf_K3N13kS1003030 = sumzP(resultK3N13kS1003030)
save(pProf_K3N13kS1003030, file = 'pProf_K3N13kS1003030.rdata')


load('resultK20N13kS100.rdata')
pProf_K20N13kS100 = sumzP(resultK20N13kS100)
save(pProf_K20N13kS100, file = 'pProf_K20N13kS100.rdata')

load('resultK20N13kS130.rdata')
pProf_K20N13kS130 = sumzP(resultK20N13kS130)
save(pProf_K20N13kS130, file = 'pProf_K20N13kS130.rdata')

load('resultK20N13kS1003030.rdata')
pProf_K20N13kS1003030 = sumzP(resultK20N13kS1003030)
save(pProf_K20N13kS1003030, file = 'pProf_K20N13kS1003030.rdata')


#----------get nominal error rate
 
dat =pProf_K20N13kS130
rates = do.call('cbind',lapply(1:4, function(i){dat[[i]][[1]]}))
t(rates)