LIBNAME lib "/home/u64324048/Group_Project/git/Code/CommonFactors/lib";
ODS POWERPOINT FILE = '/home/u64324048/Group_Project/git/Code/CommonFactors/outputfile/analysis_ad.pptx';
ODS GRAPHICS ON / width= 16cm height=12cm;

** Analysis ad;
DATA analysis_data;
	SET lib.Datasetad;
	BMI = BMI/5;
RUN;

PROC FREQ DATA = analysis_data;
	TABLE HavingCVD*SmokingStatus/ OUTPCT CHISQ OUT=Smoking_analysis;
	TABLE HavingCVD*Diabetes/OUTPCT CHISQ OUT=Diabete_analysis;
	TABLE HavingCVD*Exercise/OUTPCT CHISQ OUT=Exercise_analysis;
	
	TABLE Gender*SmokingStatus / OUTPCT CHISQ OUT=Gender_Smoking_analysis;
	TABLE Gender*Diabetes / OUTPCT CHISQ OUT=Gender_Diabetes_analysis;
	
	TABLE Age_Range*SmokingStatus / OUTPCT CHISQ OUT=Age_SmokingStatus_analysis;
	TABLE Age_Range*Diabetes / OUTPCT CHISQ OUT=Age_Diabetes_analysis;
	TITLE "Association Analysis";
RUN;


PROC LOGISTIC DATA=analysis_data;
	CLASS 
		SmokingStatus (param = ref ref = 'No')
		Diabetes (param = ref ref = 'No')
		BMI_Class (param = ref ref = 'NORMAL')
		Age_Range (param = ref ref = '<= 40')
		Gender (param = ref ref = 'Female')
		Exercise (param = ref ref = 'No')
	;
	
	MODEL HavingCVD (event = 'Yes') = Age_Range BMI SmokingStatus Diabetes Gender Exercise //* OUTROC=roc_DatasetAD_data;*/;
RUN;

PROC SGPLOT DATA=Gender_Smoking_analysis;
	WHERE SmokingStatus = 1;
	VBAR
		Gender
	/	RESPONSE=PCT_COL
		BARWIDTH=1

	;
	
	YAXIS 
		MIN = 0 
		MAX=100
		LABEL="Prevalence"
	;
	
	XAXIS 
	  	TYPE=discrete
		MIN = 0
		LABEL="Gender Range"
	;
	
	TITLE "The Smoking rate between male and female";
RUN;

PROC SGPLOT DATA=Age_SmokingStatus_analysis;
	WHERE SmokingStatus = 1;
	VBAR
		Age_Range
	/	
		RESPONSE=PCT_COL
		BARWIDTH=1
	;
	
	YAXIS 
		MIN = 0 
		MAX=30
		LABEL="Prevalence"
	;
	
	XAXIS 
	  	TYPE=discrete
		MIN = 0
		LABEL="Age Range"
	;
	
	TITLE "The Smoking rate among different age groups";
RUN;

PROC LOGISTIC DATA=analysis_data;
	CLASS 
		SmokingStatus (param = ref ref = 'No')
		Diabetes (param = ref ref = 'No')
		BMI_Class (param = ref ref = 'NORMAL')
		Age_Range (param = ref ref = '<= 40')
		Gender (param = ref ref = 'Female')
		Exercise (param = ref ref = 'No')
	;
	
	MODEL HavingCVD (event = 'Yes') = Age_Range BMI SmokingStatus Diabetes Gender Exercise //* OUTROC=roc_DatasetAD_data;*/;
RUN;



PROC SGPLOT DATA=Gender_Smoking_analysis;
	WHERE SmokingStatus = 1;
	VBAR
		Gender
	/	RESPONSE=PCT_COL
		BARWIDTH=1

	;
	
	YAXIS 
		MIN = 0 
		MAX=100
		LABEL="Prevalence"
	;
	
	XAXIS 
	  	TYPE=discrete
		MIN = 0
		LABEL="Gender"
	;
	
	TITLE "The Smoking rate between male and female";
RUN;

PROC SGPLOT DATA=Gender_Diabetes_analysis;
	WHERE Diabetes = 1;
	VBAR
		Gender
	/	
		RESPONSE=PCT_COL
		BARWIDTH=1
	;
	
	YAXIS 
		MIN = 0 
		MAX=100
		LABEL="Prevalence"
	;
	
	XAXIS 
	  	TYPE=discrete
		MIN = 0
		LABEL="Gender"
	;
	
	TITLE "The Diabete rate between male and female";
RUN;

PROC PRINT DATA=Gender_Diabetes_analysis;
RUN;

PROC PRINT DATA=Gender_Smoking_analysis;
RUN;


PROC SGPLOT DATA=Age_Diabetes_analysis;
	WHERE Diabetes = 1;
	VBAR
		Age_Range
	/	
		RESPONSE=PCT_COL
		BARWIDTH=1
	;
	
	YAXIS 
		MIN = 0 
		MAX=30
		LABEL="Prevalence"
	;
	
	XAXIS 
	  	TYPE=discrete
		MIN = 0
		LABEL="Age Range"
	;
	
	TITLE "The Diabete rate among different age groups";
RUN;







