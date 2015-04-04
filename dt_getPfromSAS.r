##############################################################################
# Purpose: Get nominal error rates from SAS output
# Date: 09/17/2012
#
##############################################################################

setwd('C:/Users/janettik/Documents/tancredi/sasResults')



#function to calculate
getRate = function(dat){

    dat$ProbF = as.character(dat$ProbF)
	dat$ProbF[dat$ProbF == '<.0001'] = 0.0001
	temp =seq_along(dat$ProbF)[as.numeric(dat$ProbF) < 0.05]
	n = dim(dat)[1]
	tot = length(temp)/n

	sub_0 = subset(dat, numEff == 0)
	sub_1 = subset(dat, numEff == 1)
	sub_2 = subset(dat, numEff == 2)

	frac0 = length(seq_along(sub_0$ProbF)[sub_0$ProbF < 0.05])/nrow(sub_0)
	frac1 = length(seq_along(sub_1$ProbF)[sub_1$ProbF < 0.05])/nrow(sub_1)
	frac2 = length(seq_along(sub_2$ProbF)[sub_1$ProbF < 0.05])/nrow(sub_2)

	data.frame(tot, frac2, nrow(sub_2), frac1, nrow(sub_1), frac0, nrow(sub_0))

}

#K10
k10s100r05 = read.csv('sasOut_K10S100R0_5.csv')
k10s100r1 = read.csv('sasOut_K10S100R1.csv')
k10s100r2 = read.csv('sasOut_K10S100R2.csv')
k10s100r4 = read.csv('sasOut_K10S100R4.csv')

k10s130r05 = read.csv('sasOut_K10S130R0_5.csv')
k10s130r1 = read.csv('sasOut_K10S130R1.csv')
k10s130r2 = read.csv('sasOut_K10S130R2.csv')
k10s130r4 = read.csv('sasOut_K10S130R4.csv')

k10s1003030r05 = read.csv('sasOut_K10S1003030R0_5.csv')
k10s1003030r1 = read.csv('sasOut_K10S1003030R1.csv')
k10s1003030r2 = read.csv('sasOut_K10S1003030R2.csv')
k10s1003030r4 = read.csv('sasOut_K10S1003030R4.csv')

#K20
k20s100r05 = read.csv('sasOut_K20S100R0_5.csv')
k20s100r1 = read.csv('sasOut_K20S100R1.csv')
k20s100r2 = read.csv('sasOut_K20S100R2.csv')
k20s100r4 = read.csv('sasOut_K20S100R4.csv')

k20s130r05 = read.csv('sasOut_K20S130R0_5.csv')
k20s130r1 = read.csv('sasOut_K20S130R1.csv')
k20s130r2 = read.csv('sasOut_K20S130R2.csv')
k20s130r4 = read.csv('sasOut_K20S130R4.csv')

k20s1003030r05 = read.csv('sasOut_K20S1003030R0_5.csv')
k20s1003030r1 = read.csv('sasOut_K20S1003030R1.csv')
k20s1003030r2 = read.csv('sasOut_K20S1003030R2.csv')
k20s1003030r4 = read.csv('sasOut_K20S1003030R4.csv')

#K3
k3s100r05 = read.csv('sasOut_K3S100R0_5.csv')
k3s100r1 = read.csv('sasOut_K3S100R1.csv')
k3s100r2 = read.csv('sasOut_K3S100R2.csv')
k3s100r4 = read.csv('sasOut_K3S100R4.csv')

k3s130r05 = read.csv('sasOut_K3S130R0_5.csv')
k3s130r1 = read.csv('sasOut_K3S130R1.csv')
k3s130r2 = read.csv('sasOut_K3S130R2.csv')
k3s130r4 = read.csv('sasOut_K3S130R4.csv')

k3s1003030r05 = read.csv('sasOut_K3S1003030R0_5.csv')
k3s1003030r1 = read.csv('sasOut_K3S1003030R1.csv')
k3s1003030r2 = read.csv('sasOut_K3S1003030R2.csv')
k3s1003030r4 = read.csv('sasOut_K3S1003030R4.csv')


list10 = list(k10s130r05, k10s130r1, k10s130r2, k10s130r4,
				k10s100r05, k10s100r1, k10s100r2, k10s100r4,
				k10s1003030r05, k10s1003030r1, k10s1003030r2, k10s1003030r4)

list20 = list(k20s130r05, k20s130r1, k20s130r2, k20s130r4,
				k20s100r05, k20s100r1, k20s100r2, k20s100r4,
				k20s1003030r05, k20s1003030r1, k20s1003030r2, k20s1003030r4)

list3 = list(k3s130r05, k3s130r1, k3s130r2, k3s130r4,
				k3s100r05, k3s100r1, k3s100r2, k3s100r4,
				k3s1003030r05, k3s1003030r1, k3s1003030r2, k3s1003030r4)


#apply function

k10 = do.call('rbind', lapply(list10, getRate))
k20 =do.call('rbind', lapply(list20, getRate))
k3 = do.call('rbind', lapply(list3, getRate))