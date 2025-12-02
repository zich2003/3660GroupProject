LIBNAME lib "/home/u64324048/Group_Project/git/Code/CommonFactors/lib";

** Analysis ad;
DATA analysis_data;
	SET lib.Datasetad;
RUN;

PROC FREQ DATA = analysis_data;
	TABLE HavingCVD*SmokingStatus/ OUTPCT CHISQ OUT=Smoking_analysis;
	TABLE HavingCVD*Diabetes/OUTPCT CHISQ OUT=Diabete_analysis;
	TABLE HavingCVD*Exercise/OUTPCT CHISQ OUT=Exercise_analysis;
	TABLE Gender*SmokingStatus / OUTPCT CHISQ OUT=Gender_Smoking_analysis;
	TABLE Gender*Diabetes / OUTPCT CHISQ OUT=Gender_Diabetes_analysis;
	
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
	
	MODEL HavingCVD (event = 'Yes') = Age_Range BMI_Class SmokingStatus Diabetes Gender Exercise //* OUTROC=roc_DatasetAD_data;*/;
RUN;

PROC LOGISTIC DATA=analysis_data;
	CLASS 
		Gender (param = ref reference = 'Female')
		Age_Range (param = ref reference = '<= 40')
		Diabetes (param = ref ref = 'No')
		Exercise (param = ref ref = 'No')
	;
	
	MODEL SmokingStatus (event = 'Yes') = Gender Age_Range BMI Diabetes Exercise / OUTROC=roc_smokingstatus_data;
RUN;

PROC LOGISTIC DATA=analysis_data;
	CLASS 
		Gender (param = ref reference = 'Female')
		Age_Range (param = ref reference = '<= 40')
		SmokingStatus (param = ref ref = 'No')
		Exercise (param = ref ref = 'No')
	;
	
	MODEL Diabetes (event = 'Yes') = Gender Age_Range BMI SmokingStatus Exercise/ OUTROC=roc_diabetes_data;
RUN;

