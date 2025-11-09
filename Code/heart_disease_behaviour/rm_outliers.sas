LIBNAME lib "/home/u64324048/Group_Project/Code/heart_disease_behaviour/lib";
LIBNAME common "/home/u64324048/Group_Project/Code/CommonFactors/lib";

DATA outliers_data;
	SET lib.convert_data;
RUN;

PROC MEANS DATA=outliers_data NWAY;
 
	CLASS cardio;
	VAR SleepTime;
	VAR BMI;
	
	OUTPUT 
		Q3(SleepTime) = uq_SleepTime
		Q1(SleepTime) = lq_SleepTime
	OUT = Analysis_Result
	;
	
RUN;


DATA _NULL_;
	SET Analysis_Result;
	
	IF cardio = 1 THEN DO;
		CALL SYMPUTX("uq_sleep_1",uq_SleepTime);
		CALL SYMPUTX("lq_sleep_1",lq_SleepTime);
		
		CALL SYMPUTX("uq_BMI_1",uq_BMI);
		CALL SYMPUTX("lq_BMI_1",lq_BMI);
	END;
	
	IF cardio = 0 THEN DO;
		CALL SYMPUTX("uq_sleep_0", uq_SleepTime);
		CALL SYMPUTX("lq_sleep_0", lq_SleepTime);
		
		CALL SYMPUTX("uq_BMI_0",uq_BMI);
		CALL SYMPUTX("lq_BMI_0",lq_BMI);
	END;
RUN;

DATA rm_outliers;
	SET outliers_data;

	IF cardio = 1 THEN DO;
		IQR_Sleep = &uq_sleep_1 - &lq_sleep_1;
		IF SleepTime > &uq_sleep_1 + 1.5*(IQR_Sleep) OR SleepTime < &lq_sleep_1 - 1.5*(IQR_Sleep) 
		THEN SleepTime = . ;

	END;
	;
	
	IF cardio = 0 THEN DO;
		IQR_Sleep = &uq_sleep_0 - &lq_sleep_0;
		IF SleepTime > &uq_sleep_0 + 1.5*(IQR_Sleep) OR SleepTime < &lq_sleep_0 - 1.5*(IQR_Sleep) 
		THEN SleepTime = . ;
		
	END;

RUN;

DATA lib.rm_outlier_data;;
	SET rm_outliers;
	KEEP AgeCategory GENDER BMI SleepTime Smoking AlcoholDrinking MentalHealth PhysicalActivity cardio;
RUN;

PROC PRINT DATA=lib.rm_outlier_data;
RUN;
