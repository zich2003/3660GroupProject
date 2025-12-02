LIBNAME lib "/home/u64324048/Group_Project/git/Code/Dataset-D/lib";

DATA analysis_data;
	SET lib.labelling_data;
RUN;

PROC TTEST DATA=lib.labelling_data;
	CLASS GENDER;
	VAR Alcohol_Consumption;
	TITLE "Mean difference of Alcohol_Consumption between Male and Female";
RUN;

PROC TTEST DATA=lib.labelling_data;
	CLASS HavingCVD;
	VAR Alcohol_Consumption;
	TITLE "Mean difference of Alcohol_Consumption between Having CVD and Not having CVD";
RUN;


PROC FREQ DATA=analysis_data;
	TABLE HavingCVD*(
		Depression 
		Skin_Cancer 
		Other_Cancer 
		Exercise 
		Diabetes 
		SmokingStatus 
		GENDER
		BMI_Class
		) / CHISQ;
RUN;


PROC FREQ DATA=analysis_data;
	TABLE Depression*Age_Range;
RUN;

PROC FREQ DATA=analysis_data;
	TABLE Depression*Age_Range;
RUN;

PROC LOGISTIC DATA=analysis_data;
    CLASS 
        HavingCVD (param=ref ref='No')
        Diabetes (param=ref ref='No')
        Skin_Cancer (param=ref ref='No')
        Other_Cancer (param=ref ref='No')
        GENDER (param=ref ref='Female')
        Alcohol_Consumption (param=ref ref='0 days') 
        Exercise (param=ref ref='No')
    ;
    
    MODEL Alcohol_Consumption = 
        HavingCVD 
        Diabetes 
        Skin_Cancer 
        Other_Cancer 
        Exercise
        GENDER / LINK=GLOGIT;
    
    TITLE "Disease Status and Alcohol Consumption Frequency";
RUN;

PROC LOGISTIC DATA=analysis_data;
	CLASS 
		Depression (param = reference ref = 'No')
		Skin_Cancer (param = reference ref = 'No')
		Other_Cancer (param = reference ref = 'No')
		Exercise (param = reference ref = 'No')
		Diabetes (param = reference ref = 'No')
		SmokingStatus (param = reference ref = 'No')
		GENDER (param = reference ref = 'Female')
		Age_Range (param = reference ref = '<= 40')

	;
	
	MODEL HavingCVD (event = 'Yes') = 
		Alcohol_Consumption 
		Depression 
		Skin_Cancer
		Other_Cancer 
		Exercise 
		Diabetes 
		SmokingStatus 
		GENDER 
		BMI
		Age_Range
	/	
	
		OUTROC=roc_CVD_data 
	;
	
	 OUTPUT OUT=predicted_data;
RUN;

PROC EXPORT DATA=predicted_data
	OUTFILE="/home/u64324048/Group_Project/git/Code/Dataset/predict_D.csv"
	DBMS =csv
	REPLACE
;
RUN;
