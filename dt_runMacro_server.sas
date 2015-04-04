*****************************************************************************
* Try some problem instances in SAS from cluster simulation
*****************************************************************************;

%include 'dt_simGlimmixMacro_server.sas';

* Read in data;
PROC Import datafile = 'tableK10S100.csv'
out= dat REPLACE;
RUN;

%splitData(dat);
%runSimGlim(dat_05, 'sasOut_K10S100R0_5.csv');
%runSimGlim(dat_1, 'sasOut_K10S100R1.csv');
%runSimGlim(dat_2, 'sasOut_K10S100R2.csv');
%runSimGlim(dat_4, 'sasOut_K10S100R4.csv');


* Read in data;
PROC Import datafile = 'tableK10S130.csv'
out= dat REPLACE;
RUN;

%splitData(dat);
%runSimGlim(dat_05, 'sasOut_K10S130R0_5.csv');
%runSimGlim(dat_1, 'sasOut_K10S130R1.csv');
%runSimGlim(dat_2, 'sasOut_K10S130R2.csv');
%runSimGlim(dat_4, 'sasOut_K10S130R4.csv');

* Read in data;
PROC Import datafile = 'tableK10S1003030.csv'
out= dat REPLACE;
RUN;

%splitData(dat);
%runSimGlim(dat_05, 'sasOut_K10S1003030R0_5.csv');
%runSimGlim(dat_1, 'sasOut_K10S1003030R1.csv');
%runSimGlim(dat_2, 'sasOut_K10S1003030R2.csv');
%runSimGlim(dat_4, 'sasOut_K10S1003030R4.csv');



* Read in data;
PROC Import datafile = 'tableK20S100.csv'
out= dat REPLACE;
RUN;

%splitData(dat);
%runSimGlim(dat_05, 'sasOut_K20S100R0_5.csv');
%runSimGlim(dat_1, 'sasOut_K20S100R1.csv');
%runSimGlim(dat_2, 'sasOut_K20S100R2.csv');
%runSimGlim(dat_4, 'sasOut_K20S100R4.csv');


* Read in data;
PROC Import datafile = 'tableK20S130.csv'
out= dat REPLACE;
RUN;

%splitData(dat);
%runSimGlim(dat_05, 'sasOut_K20S130R0_5.csv');
%runSimGlim(dat_1, 'sasOut_K20S130R1.csv');
%runSimGlim(dat_2, 'sasOut_K20S130R2.csv');
%runSimGlim(dat_4, 'sasOut_K20S130R4.csv');

* Read in data;
PROC Import datafile = 'tableK20S1003030.csv'
out= dat REPLACE;
RUN;

%splitData(dat);
%runSimGlim(dat_05, 'sasOut_K20S1003030R0_5.csv');
%runSimGlim(dat_1, 'sasOut_K20S1003030R1.csv');
%runSimGlim(dat_2, 'sasOut_K20S1003030R2.csv');
%runSimGlim(dat_4, 'sasOut_K20S1003030R4.csv');



* Read in data;
PROC Import datafile = 'tableK3S100.csv'
out= dat REPLACE;
RUN;

%splitData(dat);
%runSimGlim(dat_05, 'sasOut_K3S100R0_5.csv');
%runSimGlim(dat_1, 'sasOut_K3S100R1.csv');
%runSimGlim(dat_2, 'sasOut_K3S100R2.csv');
%runSimGlim(dat_4, 'sasOut_K3S100R4.csv');


* Read in data;
PROC Import datafile = 'tableK3S130.csv'
out= dat REPLACE;
RUN;

%splitData(dat);
%runSimGlim(dat_05, 'sasOut_K3S130R0_5.csv');
%runSimGlim(dat_1, 'sasOut_K3S130R1.csv');
%runSimGlim(dat_2, 'sasOut_K3S130R2.csv');
%runSimGlim(dat_4, 'sasOut_K3S130R4.csv');

* Read in data;
PROC Import datafile = 'tableK3S1003030.csv'
out= dat REPLACE;
RUN;

%splitData(dat);
%runSimGlim(dat_05, 'sasOut_K3S1003030R0_5.csv');
%runSimGlim(dat_1, 'sasOut_K3S1003030R1.csv');
%runSimGlim(dat_2, 'sasOut_K3S1003030R2.csv');
%runSimGlim(dat_4, 'sasOut_K3S1003030R4.csv');
