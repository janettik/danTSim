


%include 'dt_simGlimmixMacro_server.sas';

* Read in data;
PROC Import datafile = 'tableTest_70.csv'
out= dat REPLACE;
RUN;

%splitData(dat);
%runSimGlim(dat_05, 'sasOut_K10S100R0_570.csv');
%runSimGlim(dat_1, 'sasOut_K10S100R170.csv');
%runSimGlim(dat_2, 'sasOut_K10S100R270.csv');
%runSimGlim(dat_4, 'sasOut_K10S100R470.csv');

