LIBNAME lib "/home/u64324048/Group_Project/git/Code/Dataset-A/lib";
ODS POWERPOINT FILE = '/home/u64324048/Group_Project/git/Code/Dataset-A/outputfile/analysis_dataset_A.pptx';

DATA analysis_data;
	SET lib.labelling_data;
RUN;

PROC FREQ DATA=analysis_data;
	TABLE HavingCVD*(Stroke Asthma) / CHISQ;
RUN;

PROC FREQ DATA=analysis_data;
	TABLE HavingCVD*Exercise/ CHISQ;
RUN;

PROC FREQ DATA=analysis_data;
	TABLE HavingCVD*SleepTime/ CHISQ;
RUN;



PROC LOGISTIC DATA=analysis_data;
	CLASS 
		Stroke (param = ref ref = 'No')
		Asthma (param = ref ref = 'No')
		Exercise (param = ref ref = 'No')
		Gender (param = ref ref = 'Female')
		Age_Range (param = ref ref = '<= 40')
		BMI_Class (param = ref ref = 'NORMAL')
		MentalHealth (param = ref ref = '0 days')
		SleepTime(param = ref ref = '4')
	;
	
	MODEL HavingCVD (EVENT = 'Yes') = 
		Stroke 
		Asthma 
		Exercise
		SleepTime
		Gender 
		Age_Range 
		BMI_Class 
		MentalHealth
		/ 
		OUTROC=roc_DatasetA_data;
		
	OUTPUT OUT=predicted_data PREDICTED=pred_prob;
	
RUN;

PROC EXPORT DATA=predicted_data
	OUTFILE="/home/u64324048/Group_Project/git/Code/Dataset/predict_A.csv"
	DBMS =csv
	REPLACE
;
RUN;

