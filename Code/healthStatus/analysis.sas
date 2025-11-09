LIBNAME lib "/home/u64324048/Group_Project/Code/healthStatus/lib";

DATA analysis_data;
	SET lib.health_statistic;
	
	IF Family_Disease NOT = . AND 
		Diabetes NOT =. AND
		Sugar_Consumption NOT =. AND
		Stress_Level NOT = .
	;
RUN;

PROC FREQ DATA = analysis_data;
	TABLES Cardio*HBP;
	
	TABLES Cardio*Age_Range;
RUN;

PROC LOGISTIC DATA=analysis_data;
	CLASS 
		Family_Disease(param = reference ref = '0') 
		Age_Range(param = reference ref = '<= 40')
		BMI_class(param = reference ref = 'NORMAL')
		HBP(param = reference ref = '0')
	;
	
	MODEL Cardio (event = "1") = 
		HBP
		;
RUN;

PROC LOGISTIC DATA=analysis_data;
	CLASS 
		Stress_Level (param = reference ref = '3')
	;
	
	MODEL Cardio (event = "0") = 
		Stress_Level
		;
RUN;


PROC TTEST DATA= analysis_data;
	CLASS HBP;
	VAR Blood_Pressure;
RUN;

PROC UNIVARIATE DATA=analysis_data;
	VAR Age;
RUN;