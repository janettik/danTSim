#-----------------------------------------------------------------------------
#  Purpose: Evaluate p-values from simulation data
#  Date: 07/03/2012
#  By: Jasmine Nettiksimmons
#-----------------------------------------------------------------------------

source('dt_simFunctions_20120813.r')

#k = 10, sampleN = 100,60,0
load('listK10N13kS100.rdata')
temp_resultK10N13kS100 = getResults(listK10N13kS100)
save(temp_resultK10N13kS100, file = 'temp_resultK10N13kS100.rdata')
resultK10N13kS100 = processResults(temp_resultK10N13kS100)
save(resultK10N13kS100, file= 'resultK10N13kS100.rdata')

#k = 10, sampleN = 130,0,0
load('listK10N13kS130.rdata')
temp_resultK10N13kS130 = getResults(listK10N13kS130)
save(temp_resultK10N13kS130, file = 'temp_resultK10N13kS130.rdata')
resultK10N13kS130 = processResults(temp_resultK10N13kS130)
save(resultK10N13kS130, file = 'resultK10N13kS130.rdata')

#k = 10, sampleN = 10,30,30
load('listK10N13kS1003030.rdata')
temp_resultK10N13kS1003030 = getResults(listK10N13kS1003030)
save(temp_resultK10N13kS1003030, file = 'temp_resultK10N13kS1003030.rdata')
resultK10N13kS1003030 = processResults(temp_resultK10N13kS1003030)
save(resultK10N13kS1003030, file = 'resultK10N13kS1003030.rdata')


#k = 3, sampleN = 100,60,0
load('listK3N13kS100.rdata')
temp_resultK3N13kS100 = getResults(listK3N13kS100)
save(temp_resultK3N13kS100, file = 'temp_resultK3N13kS100.rdata')
resultK3N13kS100 = processResults(temp_resultK3N13kS100)
save(resultK3N13kS100, file= 'resultK3N13kS100.rdata')

#k = 3, sampleN = 130,0,0
load('listK3N13kS130.rdata')
temp_resultK3N13kS130 = getResults(listK3N13kS130)
save(temp_resultK3N13kS130, file = 'temp_resultK3N13kS130.rdata')
resultK3N13kS130 = processResults(temp_resultK3N13kS130)
save(resultK3N13kS130, file = 'resultK3N13kS130.rdata')

#k = 3, sampleN = 100,30,30
load('listK3N13kS1003030.rdata')
temp_resultK3N13kS1003030 = getResults(listK3N13kS1003030)
save(temp_resultK3N13kS1003030, file = 'temp_resultK3N13kS1003030.rdata')
resultK3N13kS1003030 = processResults(temp_resultK3N13kS1003030)
save(resultK3N13kS1003030, file = 'resultK3N13kS1003030.rdata')

#k = 20, sampleN = 130,0,0
load('listK20N13kS130.rdata')
temp_resultK20N13kS130 = getResults(listK20N13kS130)
save(temp_resultK20N13kS130, file = 'temp_resultK20N13kS130.rdata')
resultK20N13kS130 = processResults(temp_resultK20N13kS130)
save(resultK20N13kS130, file= 'resultK20N13kS130.rdata')

#k = 20, sampleN = 100,60,0
load('listK20N13kS100.rdata')
temp_resultK20N13kS100 = getResults(listK20N13kS100)
save(temp_resultK20N13kS100, file = 'temp_resultK20N13kS100.rdata')
resultK20N13kS100 = processResults(temp_resultK20N13kS100)
save(resultK20N13kS100, file= 'resultK20N13kS100.rdata')

#k = 20, sampleN = 130,0,0
load('listK20N13kS1003030.rdata')
temp_resultK20N13kS1003030 = getResults(listK20N13kS1003030)
save(temp_resultK20N13kS1003030, file = 'temp_resultK20N13kS1003030.rdata')
resultK20N13kS1003030 = processResults(temp_resultK20N13kS1003030)
save(resultK20N13kS1003030, file= 'resultK20N13kS1003030.rdata')







