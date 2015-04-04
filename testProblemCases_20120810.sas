*****************************************************************************
* Try some problem instances in SAS from cluster simulation
*****************************************************************************;

* Read in data;
PROC Import datafile = 'C:\Users\janettik\Documents\tancredi\forSASK10S130.csv'
out= datk10s130 REPLACE;
RUN;

%macro getGlim(data, title);
proc sort data= &data;
by runID;
run;

proc glimmix data = &data;
title &title;
class timeID runID;
by runID;
model rBern = timeID /dist = binomial ;
ods output ConvergenceStatus = cvg CovParms = cvp Tests3 = t3 ;
random subjectID;
run;

data res;
merge cvg cvp t3;
by runID;
covest = 0;
if estimate > 0 then covest = 1;
run;

proc print data = res;run;
%mend;



%getGlim(datk10s130, 'k = 10, s = 130,0,0')

proc freq data = res;
tables status*covest;
run;

proc sort data= datk10s130;
by runID;
run;

proc glimmix data = datk10s130;
title 'k = 10, S = 130,0,0';
class timeID runID;
by runID;
model rBern = timeID /dist = binomial ;
ods output ConvergenceStatus = cvg CovParms = cvp Tests3 = t3 ;
random subjectID;
run;


proc print data = cvg;run;

*next;
PROC Import datafile = 'C:\Users\janettik\Documents\tancredi\forSASK10S100.csv'
out= datk10s100 REPLACE;
RUN;

proc print data = datk10s100 (obs = 20);run;

proc sort data= datk10s100;
by runID;
run;

proc glimmix data = datk10s100;
title 'k = 10, S = 100,0,0';
class timeID runID;
by runID;
model rBern = timeID /dist = binomial ;
ods output ConvergenceStatus = cvg;
random subjectID;
run;

proc print data = cvg;run;



*reml vs ml;
PROC Import datafile = 'C:\Users\janettik\Documents\tancredi\testInSASk10s130_4_2.csv'
out= dat REPLACE;
RUN;

data dat;
set dat;
rBern2 = 3;
rBern2 = rBern;
run;



title '';

proc logistic data = dat;
class timeID (param = ref) ;
model rBern2 = timeID ;
run;

proc freq data = dat;
tables timeID*rBern2;
run;

proc glimmix data = dat method = laplace;
class timeID subjectID clusterID;
model rBern2 = timeID /dist = binomial solution;
random subjectID;
run;

proc glimmix data = dat method = laplace;
class timeID subjectID clusterID;
model rBern2 = timeID /dist = binomial solution;
random subjectID  clusterID;
run;

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

*scratch;
data subdat;
set datk10s130;
if runID ^= '4 8806' then delete;
run;

ods trace on;
proc glimmix data = subdat;
title 'k = 10, S = 130,0,0';
class timeID runID;
by runID;
model rBern = timeID /dist = binomial ;
ods output ConvergenceStatus = cvg;
random subjectID;
run;
ods trace off;
