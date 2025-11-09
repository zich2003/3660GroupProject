LIBNAME lib "/home/u64324048/Group_Project/Code/cardio_disease_analysis/lib";

PROC SORT DATA=lib.labelling_data OUT = analysis_data;
	BY Cardio;
RUN;

PROC LOGISTIC DATA=analysis_data;
	CLASS  
		cholesterol(param = reference ref = "1")
		high_blood_pressure(param = reference ref = "0")
		;
	
	MODEL cardio (event = '1') = 
		cholesterol 
		high_blood_pressure
		BMI_Class
		;
RUN;

PROC LOGISTIC DATA=analysis_data;
	CLASS  
		Age_Range(param = reference ref = "<= 40")
		;
	
	MODEL high_blood_pressure (event = '1') = 
		Age_Range
		;
RUN;

PROC FREQ data=analysis_data;
	TABLES 
		Cardio*high_blood_pressure 
		BMI_Class*high_blood_pressure
		BMI_Class*cholesterol
		/ CHISQ;
	
RUN;

PROC LOGISTIC DATA=analysis_data;
	CLASS BMI_class(param = reference ref = 'NORMAL');
	MODEL high_blood_pressure (event = '1') = BMI_Class;
RUN;

PROC LOGISTIC DATA=analysis_data;
	CLASS BMI_class (param = reference ref = 'NORMAL');
	
	MODEL cholesterol (event = '3') = BMI_Class;
RUN;


PROC CORR DATA=analysis_data OUT=corr_data;
	VAR Age ap_lo;
RUN;

PROC UNIVARIATE DATA = analysis_data;
	VAR BMI ap_hi ap_lo;
	BY Cardio;
RUN;




