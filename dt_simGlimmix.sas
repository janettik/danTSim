*****************************************************************************
* Try some problem instances in SAS from cluster simulation
*****************************************************************************;

* Read in data;
PROC Import datafile = 'C:\Users\janettik\Documents\tancredi\tableK10S100.csv'
out= dat REPLACE;
RUN;

data dat_05;
set dat;
if ratio ^= 0.5 then delete;
run;

data dat_1;
set dat;
if ratio ^= 1 then delete;
run;

data dat_2;
set dat;
if ratio ^= 2 then delete;
run;

data dat_4;
set dat;
if ratio^=4 then delete;
run;


data dat_use;
set dat_05;
if id > 40 then delete;
run;


%macro runSimGlim(dat_use, filename);
proc sort data = dat_use;by id;run;

/*-----------Run all the data------------*/
proc glimmix data = dat_use method = mspl;
class timeID id subjectID clusterID;
by id;
model rBern = timeID /dist = binomial ;
ods output ConvergenceStatus = cvg CovParms = cvp Tests3 = t3 ;
random subjectID clusterID;
run;

*split covariance parameter info up so there is one observation per id instead of 2;
data cvp_sub;
set cvp;
if CovParm = 'clusterID' then delete;
rename CovParm = Cov_sub;
rename Estimate = Est_sub;
run;

data cvp_clus;
set cvp;
if CovParm = 'subjectID' then delete;
rename CovParm = Cov_clus;
rename Estimate = Est_clus;
run;

*put together results;
data res;
merge cvg cvp_sub cvp_clus t3;
by id;
rename Status = Status_orig
	   Est_sub = Est_sub_orig
	   Est_clus = Est_clus_orig;
run;

/*-----------Split out the problem data sets---------------*/
*select records where subject (only) couldn't be estimated;
data redosub_id;
set res;
if Est_clus_orig = 0 then delete;
if Est_clus_orig >0 and Est_sub_orig > 0 then delete;
indic =1;
*keep id indic;
run;

*select records where cluster (only) couldn't be estimated;
data redoclust_id;
set res;
if Est_sub_orig = 0 then delete;
if Est_sub_orig >0 and Est_clus_orig > 0 then delete;
indic =1;
*keep id indic;
run;


/*--------------re-run without random subject-----------------*/
data dat_redosub;
merge dat_use redosub_id;
by id;
if indic ^= 1 then delete;
run;

proc glimmix data = dat_redosub method = mspl;
class timeID id subjectID clusterID;
by id;
model rBern = timeID /dist = binomial ;
ods output ConvergenceStatus = cvg CovParms = cvp Tests3 = t3 ;
random clusterID;
run;

data res_sub;
merge cvg cvp t3;
by id;
if parameter = subjectID then delete; *just in case there aren't any and the previous cvp get's recycled;
run;

/*---------------re-run without random cluster----------------*/
data dat_redoclust;
merge dat_use redoclust_id;
by id;
if indic ^= 1 then delete;
run;

proc glimmix data = dat_redoclust method = mspl;
class timeID id subjectID clusterID;
by id;
model rBern = timeID /dist = binomial ;
ods output ConvergenceStatus = cvg CovParms = cvp Tests3 = t3;
random subjectID;
run;

data res_clust;
merge cvg cvp t3;
by id;
if parameter = clusterID then delete; *just in case there aren't any and the previous cvp get's recycled;
run;

/*----------update main results with results from models with only one random effect*/
data res_final;
update res( in=a)
       res_sub( in=b);
by id ;
run;

data res_final;
update res_final (in=c)
		res_clust (in=d);
by id;
if est_sub_orig ^= 0 and est_clus_orig ^= 0 and status_orig = 0 then
	do;
		est_clus = est_clus_orig;
		est_sub = est_sub_orig;
		if Status_orig = 0 then Status = status_orig;
	end;
run;

/*#################################################################################################*/
/*# Tricky part: take original problem cases or new problem cases from the one random effect models*/
/*#################################################################################################*/
data redoboth_id;
set res_final;
do;
	if status = 0 then
		if est_sub > 0 or  est_clus > 0 then delete;
end;

indic =1;
keep id indic;
run; 

*re-run without any random effects;
data dat_both;
merge &dat_use redoboth_id;
by id;
if indic ^= 1 then delete;
run;

proc glimmix data = dat_both method = mspl;
class timeID id subjectID clusterID;
by id;
model rBern = timeID /dist = binomial ;
ods output ConvergenceStatus = cvg  Tests3 = t3;
run;

data res_both;
merge cvg  t3;
by id;
run;

data res_final;
update res_final (in= e)
		res_both (in = f);
by id;
run;

proc export data = res_final
outfile = &filename
dbms = csv
replace;
run;


%mend;


*-----------try to run it-----------;

%runSimGlim(dat_use, 'sasOut_K10S100R0_5.csv');


*scratch;

data dat_test70;
set dat;
if id > 70 then delete;
run;

proc export data = dat_test70
outfile = 'tableTest_70.csv'
dbms = csv
replace;
run;
