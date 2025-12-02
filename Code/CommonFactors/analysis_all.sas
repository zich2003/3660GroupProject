LIBNAME lib "/home/u64324048/Group_Project/git/Code/CommonFactors/lib";
ODS POWERPOINT FILE = '/home/u64324048/Group_Project/git/Code/CommonFactors/analysis.pptx';

** Analysis All;
DATA analysis_data;
	SET lib.all;
RUN;


PROC TTEST DATA=analysis_data ALPHA=0.05;
	CLASS HavingCVD;
	VAR BMI;
	TITLE "The mean difference analysis between Diseased and non-disease samples";
RUN;


PROC TTEST DATA=analysis_data ALPHA=0.05;
	CLASS Gender;
	VAR BMI;
	TITLE "The BMI difference between Male and Female samples";
RUN;

PROC FREQ DATA = analysis_data;
	TABLE HavingCVD*Gender/ OUTPCT CHISQ OUT=Gender_analysis;
	TABLE HavingCVD*Age_Range/OUTPCT CHISQ OUT=Age_Range_analysis;
	TABLE HavingCVD*BMI_Class / OUTPCT CHISQ OUT=BMI_Class_analysis;
	TABLE Gender*BMI_Class / OUTPCT OUT=BMI_Class_Gender_analysis;
	TITLE "The association analysis between Discrete Data and CVD status";
RUN;

PROC SGPLOT DATA=Gender_analysis;
	VBAR Gender / Response=PCT_COL;
	WHERE HavingCVD = 1;
	YAXIS MIN = 0 MAX=100;
	TITLE "The Prevalence analysis between Gender and CVD status";
RUN;

PROC SGPLOT DATA=Age_Range_analysis;
	VBAR Age_Range / Response=PCT_COL;
	WHERE HavingCVD = 1;
	YAXIS MIN = 0 MAX=100;
	TITLE "The Age_Range analysis between Gender and CVD status";
RUN;

PROC SGPLOT DATA=BMI_Class_analysis;
	VBAR BMI_Class / Response=PCT_COL;
	WHERE HavingCVD = 1;
	YAXIS MIN = 0 MAX=100;
	TITLE "The BMI_Class analysis between Gender and CVD status";
RUN;

PROC SGPLOT DATA=BMI_Class_Gender_analysis;;
	VBAR Gender / Response=PCT_COL Group= BMI_Class GROUPDISPLAY=cluster;
	YAXIS MIN = 0 MAX=100;
	TITLE "The BMI_Class analysis between Gender and CVD status";
RUN;

PROC LOGISTIC DATA=lib.all;
	CLASS 
		BMI_Class (param = ref ref = 'NORMAL')
		Age_Range (param = ref ref = '<= 40')
		Gender (param = ref ref = 'Female')
	;
	
	MODEL HavingCVD (event = 'Yes') = BMI_Class Age_Range Gender / OUTROC=roc_data;
	OUTPUT OUT=predicted_data PREDICTED = pred_prob;
RUN;

PROC PRINT DATA=roc_data;
RUN;

PROC ANOVA DATA=analysis_data;
	CLASS Age_Range;
	MODEL BMI = Age_Range;
	MEANS Age_Range / tukey;
RUN;

PROC EXPORT DATA=predicted_data
	OUTFILE="/home/u64324048/Group_Project/git/Code/Dataset/predict_common_all.csv"
	DBMS =csv
	REPLACE
;
RUN;

