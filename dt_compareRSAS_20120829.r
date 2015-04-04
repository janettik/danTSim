
##################
#   R Code
##################
library(lme4)
data = read.csv('C:/Users/janettik/Documents/tancredi/testInSASk10s130_4_2.csv',
				header = TRUE)

data$timeID = factor(data$timeID, levels = c(2,1))
glm_out = glm(rBern ~ timeID, data = data, family = 'binomial')

glmm = glmmPQL(rBern ~ timeID, random = ~ 1 | subjectID,
                family = 'binomial', data = data)

glme_rs = lmer(formula = rBern ~ timeID +(1 |subjectID) , 
          REML = TRUE,
          family  ='binomial',
                    data = data)

 glme_r = lmer(formula = rBern ~ timeID +(1 | clusterID) +(1 |subjectID) , 
 					REML = TRUE,
 					family 	='binomial',
                    data = data)

 glme_m = lmer(formula = rBern ~ timeID +(1 | clusterID) +(1 |subjectID) , 
 					REML = FALSE,
 					family 	='binomial',
                    data = data)

#################
# R results
#################
> summary(glme_r)
Generalized linear mixed model fit by the Laplace approximation 
Formula: rBern ~ timeID + (1 | clusterID) + (1 | subjectID) 
   Data: data 
   AIC   BIC logLik deviance
 360.4 374.7 -176.2    352.4
Random effects:
 Groups    Name        Variance Std.Dev.
 subjectID (Intercept) 0.80734  0.89852 
 clusterID (Intercept) 0.18089  0.42531 
Number of obs: 260, groups: subjectID, 160; clusterID, 10

Fixed effects:
            Estimate Std. Error z value Pr(>|z|)
(Intercept)   0.3581     0.4209   0.851    0.395
timeID       -0.3164     0.2713  -1.166    0.244

Correlation of Fixed Effects:
       (Intr)
timeID -0.878


> summary(glme_m)
Generalized linear mixed model fit by the Laplace approximation 
Formula: rBern ~ timeID + (1 | clusterID) + (1 | subjectID) 
   Data: data 
   AIC   BIC logLik deviance
 360.4 374.7 -176.2    352.4
Random effects:
 Groups    Name        Variance Std.Dev.
 subjectID (Intercept) 0.80734  0.89852 
 clusterID (Intercept) 0.18089  0.42531 
Number of obs: 260, groups: subjectID, 160; clusterID, 10

Fixed effects:
            Estimate Std. Error z value Pr(>|z|)
(Intercept)   0.3581     0.4209   0.851    0.395
timeID       -0.3164     0.2713  -1.166    0.244

Correlation of Fixed Effects:
       (Intr)
timeID -0.878

###################
#   SAS code
###################
PROC Import datafile = 'C:\Users\janettik\Documents\tancredi\testInSASk10s130_4_2.csv'
out= dat REPLACE;
RUN;

*SAS was thinking rBern was a character;
data dat;
set dat;
rBern2 = 3;
rBern2 = rBern;
run;

*I established that it is not necessary to physically 'nest'
  subjectID in cluster since subjectID is unique across clusters;

proc glimmix data = dat method = rspl;
class timeID subjectID clusterID;
model rBern2 = timeID /dist = binomial solution;
random subjectID clusterID;
run;

proc glimmix data = dat method = mspl;
class timeID subjectID clusterID;
model rBern2 = timeID /dist = binomial solution;
random subjectID clusterID;
run;

####################
#  SAS Results:
#####################
Model Information 
Data Set WORK.DAT 
Response Variable rBern2 
Response Distribution Binomial 
Link Function Logit 
Variance Function Default 
Variance Matrix Not blocked 
Estimation Technique Residual PL 
Degrees of Freedom Method Containment 


Class Level Information 
Class Levels Values 
timeID 2 1 2 
subjectID 160 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 
clusterID 10 1 2 3 4 5 6 7 8 9 10 

Number of Observations Read 260 
Number of Observations Used 260 

Dimensions 
G-side Cov. Parameters 2 
Columns in X 3 
Columns in Z 170 
Subjects (Blocks in V) 1 
Max Obs per Subject 260 


Optimization Information 
Optimization Technique Dual Quasi-Newton 
Parameters in Optimization 2 
Lower Boundaries 2 
Upper Boundaries 0 
Fixed Effects Profiled 
Starting From Data 


Iteration History 
Iteration Restarts Subiterations Objective
Function Change Max
Gradient 
0 0 5 1129.7427523 0.39114957 0.00007 
1 0 4 1118.1217744 0.11290248 0.000139 
2 0 4 1116.4822175 0.01869577 7.364E-6 
3 0 3 1116.2024191 0.00328584 1.189E-7 
4 0 2 1116.1535365 0.00057686 2.426E-6 
5 0 2 1116.1449604 0.00010125 7.939E-8 
6 0 1 1116.1434535 0.00001336 0.00012 
7 0 1 1116.1431769 0.00001153 0.00005 
8 0 1 1116.1432334 0.00000451 0.000035 
9 0 1 1116.1431632 0.00000413 0.00002 
10 0 1 1116.1431781 0.00000216 0.000012 
11 0 1 1116.1431504 0.00000179 9.501E-6 
12 0 0 1116.1431542 0.00000000 9.44E-6 

Convergence criterion (PCONV=1.11022E-8) satisfied. 

Fit Statistics 
-2 Res Log Pseudo-Likelihood 1116.14 
Generalized Chi-Square 226.52 
Gener. Chi-Square / DF 0.88 


Covariance Parameter Estimates 
Cov Parm Estimate Standard Error 
subjectID 0.5204 0.3499 
clusterID 0.1673 0.1652 

Solutions for Fixed Effects 
Effect timeID  Estimate Standard Error DF t Value Pr > |t| 
Intercept      -0.2286 0.2554 0 -0.90 . 
timeID 1       0.2639 0.2662 99 0.99 0.3240 
timeID 2       0 . . . . 


Type III Tests of Fixed Effects 
Effect Num DF Den DF F Value Pr > F 
timeID 1 99 0.98 0.3240 


--------------------------------------------------------------------------------
The GLIMMIX Procedure

Model Information 
Data Set WORK.DAT 
Response Variable rBern2 
Response Distribution Binomial 
Link Function Logit 
Variance Function Default 
Variance Matrix Not blocked 
Estimation Technique PL 
Degrees of Freedom Method Containment 



Class Level Information 
Class Levels Values 
timeID 2 1 2 
subjectID 160 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 
clusterID 10 1 2 3 4 5 6 7 8 9 10 

Number of Observations Read 260 
Number of Observations Used 260 

Dimensions 
G-side Cov. Parameters 2 
Columns in X 3 
Columns in Z 170 
Subjects (Blocks in V) 1 
Max Obs per Subject 260 

Optimization Information 
Optimization Technique Dual Quasi-Newton 
Parameters in Optimization 2 
Lower Boundaries 2 
Upper Boundaries 0 
Fixed Effects Profiled 
Starting From Data 



Iteration History 
Iteration Restarts Subiterations Objective
Function Change Max
Gradient 
0 0 5 1125.5609075 0.41761374 0.000714 
1 0 4 1113.7132694 0.11617466 0.000108 
2 0 4 1112.0513932 0.01918488 1.689E-6 
3 0 3 1111.7704786 0.00334267 1.513E-7 
4 0 2 1111.7218852 0.00058105 3.343E-6 
5 0 2 1111.7134464 0.00010100 1.102E-7 
6 0 1 1111.711978 0.00001349 0.000156 
7 0 1 1111.7117436 0.00001390 0.000071 
8 0 1 1111.7118095 0.00000655 0.000061 
9 0 1 1111.7117209 0.00000643 0.000036 
10 0 1 1111.7117462 0.00000367 0.000027 
11 0 1 1111.7117035 0.00000343 0.00002 
12 0 1 1111.7117139 0.00000220 0.000012 
13 0 1 1111.7116908 0.00000190 0.000013 
14 0 1 1111.7116945 0.00000128 7.04E-6 
15 0 0 1111.711682 0.00000000 8.292E-6 

Convergence criterion (PCONV=1.11022E-8) satisfied. 

Fit Statistics 
-2 Log Pseudo-Likelihood 1111.71 
Generalized Chi-Square 227.51 
Gener. Chi-Square / DF 0.88 


Covariance Parameter Estimates 
Cov Parm Estimate Standard Error 
subjectID 0.5018 0.3460 
clusterID 0.1339 0.1406 

Solutions for Fixed Effects 
Effect timeID Estimate Standard Error DF t Value Pr > |t| 
Intercept   -0.2264 0.2477 0 -0.91 . 
timeID 1 0.2608 0.2653 99 0.98 0.3281 
timeID 2 0 . . . . 



Type III Tests of Fixed Effects 
Effect Num DF Den DF F Value Pr > F 
timeID 1 99 0.97 0.3281 




