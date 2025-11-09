LIBNAME lib "/home/u64324048/Group_Project/Code/heart_disease_behaviour/lib";

DATA analysis_data;
	SET lib.labelling_data;
	IF SleepTime >= 4;
RUN;

PROC TTEST DATA=analysis_data;
	CLASS cardio;
	VAR SleepTime;
RUN;

PROC TTEST DATA=analysis_data;
	CLASS cardio;
	VAR MentalHealth;
RUN;


PROC FREQ DATA=analysis_data ORDER=DATA;
	TABLES PhysicalActivity*cardio / NOPERCENT NOCOL NOROW NOCUM;
RUN;

PROC LOGISTIC DATA=analysis_data;
	CLASS 
		PhysicalActivity(param = ref ref='0') 
		SleepTime(param = ref ref='4')

		;
		
	MODEL cardio (event='1') = 
		PhysicalActivity 
		SleepTime
		;
RUN;