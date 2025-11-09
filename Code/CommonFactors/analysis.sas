LIBNAME lib "/home/u64324048/Group_Project/Code/CommonFactors/lib";

/*
DATA analysis_all;
	SET lib.all;
RUN;
*/

/*
DATA analysis_CardioHealth;
	SET lib.cardiohealth;
RUN;
*/

DATA analysis_CardioBehavior;
	SET lib.cardiobehavior;
RUN;

PROC LOGISTIC DATA=analysis_CardioBehavior;
	CLASS 
		Age_Range (param = reference ref = '<= 40') 
		GENDER (param = reference ref = '1')
		BMI_Class (param = reference ref = 'NORMAL')
		Smoking (param = reference ref = '0')
	;
	
	MODEL HasCardioDisease (event = '1') =  Age_Range GENDER BMI_Class Smoking;
	
RUN;


PROC LOGISTIC DATA=analysis_CardioBehavior;
	CLASS 
		BMI_Class (param = reference ref = 'NORMAL')
		Smoking (param = reference ref = '1')
	;
	
	MODEL Gender (event = '0') =  Smoking BMI_Class;
	
RUN;

PROC GLM DATA=analysis_cardiobehavior;
	CLASS Age_Range;
	MODEL BMI = Age_Range;
RUN;

PROC UNIVARIATE DATA=analysis_CardioHealth;
	VAR BMI;
RUN;

