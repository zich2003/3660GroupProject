LIBNAME lib "/home/u64324048/Group_Project/git/Code/CommonFactors/lib";
ODS POWERPOINT FILE = '/home/u64324048/Group_Project/git/Code/CommonFactors/analysis_ab.pptx';

PROC FREQ DATA=lib.datasetab;
	TABLE HavingCVD*AlcoholDrinking / CHISQ;
RUN;

PROC LOGISTIC DATA=lib.datasetab;
	CLASS 
		AlcoholDrinking(param = ref ref = 'No')
		BMI_Class (param = ref ref = 'NORMAL')
		Age_Range (param = ref ref = '<= 40')
		Gender (param = ref ref = 'Female')
	;
	
	MODEL HavingCVD (event = 'Yes') =  
		AlcoholDrinking
		BMI
		Age_Range
		Gender 
	/ OUTROC=roc_AB;
	;
	
	OUTPUT OUT=predicted_data PREDICTED = pred_prob;
RUN;