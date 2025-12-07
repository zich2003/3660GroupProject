LIBNAME lib "/home/u64324048/Group_Project/git/Code/Dataset-B/lib";

DATA analysis_data;
	SET lib.labelling_data;
	AGE = AGE/5; **1 unit = 5 years;
	SBP = SBP/10 /*1 unit = 10 mmHg*/;
	DBP = DBP/10;
	BMI = BMI/5; **1 unit = 5kg/m^2;
RUN;

PROC ANOVA DATA=lib.labelling_data;
	CLASS cholesterol;
	MODEL Age = cholesterol;
	MEANS cholesterol / TUKEY;
RUN;

PROC ANOVA DATA=lib.labelling_data;
	CLASS gluc;
	MODEL Age = gluc;
	MEANS gluc / TUKEY;
RUN;

PROC ANOVA DATA=lib.labelling_data;
	CLASS cholesterol;
	MODEL SBP = cholesterol;
	MEANS cholesterol / TUKEY;
RUN;

PROC ANOVA DATA=lib.labelling_data;
	CLASS gluc;
	MODEL SBP = gluc;
	MEANS gluc / TUKEY;
RUN;


PROC FREQ DATA=lib.labelling_data;
	TABLES HavingCVD*(cholesterol gluc active) /CHISQ;
RUN;

PROC TTEST DATA=lib.labelling_data;
	CLASS SmokingStatus;
	VAR SBP;
RUN;


PROC CORR DATA=analysis_data;
	VAR Age SBP DBP BMI;
RUN;

PROC LOGISTIC DATA=analysis_data;
	CLASS  
		cholesterol (param  = ref ref = 'Normal') 
		gluc (param  = ref ref = 'Normal') 
		SmokingStatus (param = ref ref = 'No')
		Gender (param = ref ref = 'Female')
		AlcoholDrinking (param = ref ref = 'No')
		Active (param = ref ref = 'No')
	;
	
	MODEL HavingCVD (event = 'Yes') = 
		cholesterol 
		gluc 
		SBP
		SmokingStatus
		Gender
		AlcoholDrinking 
		Age_Range
		BMI
		Active
		/ 
		OUTROC=roc_DatasetB_data
		
	;
	
	OUTPUT OUT = predicted_data PREDICTED=pred_prob;
RUN;

PROC PRINT DATA=roc_DatasetB_data;
RUN;


PROC LOGISTIC DATA=analysis_data;
	CLASS  
		cholesterol (param  = ref ref = 'Normal') 
		gluc (param  = ref ref = 'Normal') 
		HBPStatus (param  = ref ref = 'No') 
		SmokingStatus (param  = ref ref = 'No') 
		Gender (param  = ref ref = 'Female') 
		
	;
	
	MODEL cholesterol = Age SBP DBP SmokingStatus /LINK=glogit ;
	
	TITLE "cholesterol & Age SBP DBP Smoking Status";
RUN;


PROC LOGISTIC DATA=analysis_data;
	CLASS  
		cholesterol (param  = ref ref = 'Normal') 
		gluc (param  = ref ref = 'Normal') 
		Gender (param = ref ref = 'Female')
		SmokingStatus (param = ref ref = 'No')
		AlcoholDrinking (param = ref ref = 'No')
		Active (param = ref ref = 'No')
	;

	
	MODEL HBPStatus (event = 'Yes') = 
		Age 
		cholesterol 
		Gender 
		SmokingStatus 
		Gluc
		BMI 
		AlcoholDrinking 
		Active
	;
	
	TITLE "Relation analysis between Cholesterol & Age, cholesterol, Gender, SmokingStatus";
RUN;


PROC ANOVA DATA=lib.labelling_data;
	CLASS Age_Range;
	
	MODEL SBP = Age_Range;
	MEANS Age_Range / TUKEY;
RUN;

PROC ANOVA DATA=lib.labelling_data;
	CLASS cholesterol;
	
	MODEL SBP = cholesterol;
	MEANS cholesterol / TUKEY;
	
	TITLE "Relation analysis between Cholesterol level & SBP";
RUN;

PROC SGPLOT DATA=lib.labelling_data;
	SCATTER 
		X = Age
		Y = SBP
	/ 
	 GROUP=HavingCVD
	 MARKERATTRS=(SIZE=8)
	;
	
	
	
	REFLINE 
		140 / 
			axis=Y
			lineattrs=(COLOR=BLUE PATTERN=DASH THICKNESS=2) 
			LABEL = "SBP = 140 (HBP)"
	;
	
	REFLINE 
		50 / 
			axis=x
			lineattrs=(COLOR=BLUE PATTERN=DASH THICKNESS=2) 
			LABEL = "AGE = 50 (Middle-Advanced Age)"
	;
	
	TITLE "Scatter Plot of Age and SBP";
RUN;

PROC SGPLOT DATA=lib.labelling_data;
	SCATTER 
		Y = SBP
		X = BMI
	/ 
	 GROUP=HavingCVD
	 MARKERATTRS=(SIZE=8)
	;
	
	REFLINE 
		28 / 
			axis=X
			lineattrs=(COLOR=BLUE PATTERN=DASH THICKNESS=2) 
			LABEL ="BMI = 28 (OBESITY)"  
	;
	
	REFLINE 
		140 / 
			axis=Y
			lineattrs=(COLOR=BLUE PATTERN=DASH THICKNESS=2) 
			LABEL = "SBP = 140 (HBP)"
	;
	
	KEYLEGEND / POSITION = TOPRIGHT;
	
	TITLE "Scatter Plot of BMI and SBP";
RUN;

PROC SGPLOT DATA=lib.labelling_data;
	SCATTER 
		Y = BMI
		X = AGE
	/ 
	 GROUP=HavingCVD
	 MARKERATTRS=(SIZE=8)
	;
	
	
	REFLINE 
		28 / axis=Y lineattrs=(COLOR=BLACK PATTERN=DASH THICKNESS=2) LABEL = "BMI = 28 (OBESITY)"
	;
	
	REFLINE 
		50 / axis=X lineattrs=(COLOR=BLACK PATTERN=DASH THICKNESS=2) LABEL = "Age = 60 (Advanced Age)"
	;
	
	
	KEYLEGEND / POSITION = TOPRIGHT;
	
	TITLE "Scatter Plot of Age and BMI";
RUN;

PROC CORR DATA=analysis_data;
	VAR Age BMI SBP DBP;
RUN;

PROC EXPORT DATA=predicted_data
	OUTFILE="/home/u64324048/Group_Project/git/Code/Dataset/predict_B.csv"
	DBMS =csv
	REPLACE
;
RUN;

