#-----------------------------------------------------------------------------
#  Purpose: Create simuation data for Dan T
#  Date: 06/28/2012
#  By: Jasmine Nettiksimmons
#-----------------------------------------------------------------------------

source('C:/Users/janettik/Documents/tancredi/dt_simFunctions_20120820.r')

#--- do each sample make-up separately, ratios done together

#k = 10, N = 100, 60, 0)
dataList1= getReplicates(numRep = 13000, 
                        nclust = 10,
                        ratioList = list(.5, 1, 2, 4),
                        ntype = c(100,60,0))
                        

listK10N13kS100 = dataList1
save(listK10N13kS100, file = 'listK10N13kS100.rdata')

#k = 10, N = 130,0 , 0)
dataList1= getReplicates(numRep = 13000, 
                        nclust = 10,
                        ratioList = list(.5, 1, 2, 4),
                        ntype = c(130,0,0))
                        

listK10N13kS130 = dataList1
save(listK10N13kS130, file = 'listK10N13kS130.rdata')

#k = 10, n = 100, 30, 30
dataList1 = getReplicates(numRep = 13000,
                         nclust = 10,
                         ratioList = list(.5, 1, 2, 4), 
                         ntype = c(100, 30, 30))
listK10N13kS1003030 = dataList1
save(listK10N13kS1003030, file = 'listK10N13kS1003030.rdata')

#k = 3, N = 100, 60, 0)
dataList1= getReplicates(numRep = 13000, 
                        nclust = 3,
                        ratioList = list(.5, 1, 2, 4),
                        ntype = c(100,60,0))
                        

listK3N13kS100 = dataList1
save(listK3N13kS100, file = 'listK3N13kS100.rdata')

#k = 3, N = 130,0 , 0)
dataList1= getReplicates(numRep = 13000, 
                        nclust = 3,
                        ratioList = list(.5, 1, 2, 4),
                        ntype = c(130,0,0))
                        

listK3N13kS130 = dataList1
save(listK3N13kS130, file = 'listK3N13kS130.rdata')

#k = 20, N = 100,30,30

dataList1 = getReplicates(numRep = 13000,
                         nclust = 3,
                         ratioList = list(.5, 1, 2, 4), 
                         ntype = c(100, 30, 30))
listK3N13kS1003030 = dataList1
save(listK3N13kS1003030, file = 'listK3N13kS1003030.rdata')


#k = 20, N = 100, 60, 0)
dataList1= getReplicates(numRep = 13000, 
                        nclust = 20,
                        ratioList = list(.5, 1, 2, 4),
                        ntype = c(100,60,0))
                        

listK20N13kS100 = dataList1
save(listK20N13kS100, file = 'listK20N13kS100.rdata')

#k = 20, N = 130,0 , 0)
dataList1= getReplicates(numRep = 13000, 
                        nclust = 20,
                        ratioList = list(.5, 1, 2, 4),
                        ntype = c(130,0,0))
                        

listK20N13kS130 = dataList1
save(listK20N13kS130, file = 'listK20N13kS130.rdata')

#k = 20, N = 100,30,30

dataList1 = getReplicates(numRep = 13000,
                         nclust = 20,
                         ratioList = list(.5, 1, 2, 4), 
                         ntype = c(100, 30, 30))
listK20N13kS1003030 = dataList1
save(listK20N13kS1003030, file = 'listK20N13kS1003030.rdata')



#paula deihr article: 3280, 2195, 3524
# (36%, 24%, 39%)


