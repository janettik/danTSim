/*******************************************************************************/
/** Purpose: Macros to split the data into the four different ratios*/
/**          and then run each chunk separately through glimmix*/
/** Date: 09/07/2012*/
/*******************************************************************************/


%macro splitData(dat);
proc sort data = &dat;
by id;
run;

data dat_05 dat_1 dat_2 dat_4;
set &dat;
if ratio = 0.5 then output dat_05;
if ratio = 1 then output dat_1;
if ratio = 2 then output dat_2;
if ratio = 4 then output dat_4;
run;

%mend;


%macro runSimGlim(dat_use, filename);

/*-----------Run all the data------------*/
proc glimmix data = &dat_use;
class timeID id subjectID clusterID;
by id;
model rBern = timeID /dist = binomial ;
ods output ConvergenceStatus = cvg CovParms = cvp Tests3 = t3 ;
random subjectID clusterID/type = VC;
run;

*split covariance parameter info up so there is one observation per id instead of 2;
data cvp_sub;
set cvp;
if CovParm = 'clusterID' then delete;
rename CovParm = Cov_sub;
rename Estimate = Est_sub;
SE_sub = StdErr;
drop StdErr;
run;

data cvp_clus;
set cvp;
if CovParm = 'subjectID' then delete;
rename CovParm = Cov_clus;
rename Estimate = Est_clus;
SE_clus = StdErr;
drop StdErr;
run;

*put together results;
data res;
merge cvg cvp_sub cvp_clus t3;
by id;
rename Est_sub = Est_sub_orig
	   Est_clus = Est_clus_orig;

run;

/*-----------Split out the problem data sets---------------*/
/**select records where different variance components could not be estimated;*/
data nosub_id noclus_id res2;
set res;

*if can't fit subject (regardless of cluster);
if (SE_sub = . or .< Est_sub_orig < 1E-16)   then runClass = 1;
*if can't fit cluster but can fit subject;
else if SE_sub ^= . and 
	(SE_clus = . or .< Est_clus_orig < 1E-16) then runClass = 2;
*if both fit fine;
else runClass = 3;


*output data;
if runClass = 1 then output nosub_id;

else if runClass = 2 then output noclus_id;

else 
		do;
		numEff = 2;
		if runClass = 3 then output res2;
		end;

run;


/*--------------re-run without random subject-----------------*/
data dat_nosub;
merge &dat_use nosub_id(in=_innosub keep = id);
by id;
if _innosub ;
run;

proc glimmix data = dat_nosub;
class timeID id subjectID clusterID;
by id;
model rBern = timeID /dist = binomial ;
ods output ConvergenceStatus = cvg_nosub CovParms = cvp_nosub Tests3 = t3_nosub ;
random clusterID /type = VC;
run;

data res_nosub;
merge cvg_nosub cvp_nosub t3_nosub;
by id;
run;

/*---------------re-run without random cluster----------------*/
data dat_noclust;
merge &dat_use noclus_id(in = _innoclus keep = id);
by id;
if _innoclus;
run;

proc glimmix data = dat_noclust;
class timeID id subjectID clusterID;
by id;
model rBern = timeID /dist = binomial ;
ods output ConvergenceStatus = cvg_noclus CovParms = cvp_noclus Tests3 = t3_noclus;
random subjectID/ type = VC;
run;

data res_noclust;
merge cvg_noclus cvp_noclus t3_noclus;
by id;
run;


/*---------put together results so far----------------------*/
*stack the noclust and no sub output;


data res_subclus;
set res_noclust res_nosub;
*if there is a problem, mark with trynone;
if StdErr = . or .< Estimate< 1E-16 or status = 1 then trynone = 1;
run;

proc sort data = res_subclus;
by id;
run;

*re-run without any random effects;
data dat_none;
merge &dat_use res_subclus(keep = id trynone); 
by id;
if trynone = 1;
run;


proc glimmix data = dat_none;
class timeID id subjectID clusterID;
by id;
model rBern = timeID /dist = binomial ;
ods output ConvergenceStatus = cvg_none  Tests3 = t3_none;
run;

data res_none;
merge cvg_none  t3_none;
by id;
numEff =0;
run;

data res_subclus;
set res_subclus;
if trynone = 1 then delete;
numEff = 1;
run;

data res_final;
set res2 res_subclus res_none;
by id;
drop trynone runClass;
run;

proc export data = res_final
outfile = &filename
dbms = csv
replace;
run;


%mend;
