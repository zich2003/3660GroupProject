LIBNAME lib "/home/u64324048/Group_Project/Code/healthStatus/lib";

DATA outlier_data;
	SET lib.health_statistic;
RUN;

PROC MEANS DATA=outlier_data
	Q1 Q3 NOPRINT
;
	CLASS cardio;
	OUTPUT
		Q1(BMI) = Lq_bmi
		Q3(BMI) = Uq_bmi
		
		Q1(SleepTime) = Lq_sleepHours
		Q3(SleepTime) = Uq_sleepHours
		
	 OUT = quartile
	;
RUN;


DATA _NULL_;
	SET quartile;
	IF cardio = 1 THEN DO;
		CALL SYMPUTX("uq_bmi_1",Uq_bmi);
		CALL SYMPUTX("lq_bmi_1",Lq_bmi);
		
		CALL SYMPUTX("lq_sleepHours_1", Lq_sleepHours);
		CALL SYMPUTX("uq_sleepHours_1", Uq_sleepHours);
		
	END;
	
	IF cardio = 0 THEN DO;
		CALL SYMPUTX("uq_bmi_0",uq_bmi);
		CALL SYMPUTX("lq_bmi_0",lq_bmi);
		
		CALL SYMPUTX("lq_sleepHours_0", Lq_sleepHours);
		CALL SYMPUTX("uq_sleepHours_0", Uq_sleepHours);
	END;
RUN;

DATA rm_outliers;
	SET outlier_data;
	
	IF cardio = 1 THEN DO;
		IQR_BMI = &uq_bmi_1 - &lq_bmi_1;
		IQR_Sleep = &uq_sleepHours_1 - &lq_sleepHours_1;
		
		IF (Sleep_Hours > &uq_sleepHours_1 + 1.5*IQR_Sleep) OR 
		(Sleep_Hours < &lq_sleepHours_1 - 1.5*IQR_Sleep)
		THEN Outlier_TYPE = "SleepHours"
		;
		ELSE IF(BMI > &uq_bmi_1 + 1.5*IQR_BMI) OR (BMI < &lq_bmi_1 - 1.5*IQR_BMI) THEN Outlier_TYPE = "BMI";
		
	END;
	
	IF cardio = 0 THEN DO;
		IQR_Sleep = &uq_sleepHours_0 - &lq_sleepHours_0;
		IQR_BMI = &uq_bmi_0 - &lq_bmi_0;
		
		IF (Sleep_Hours > &uq_sleepHours_0 + 1.5*IQR_Sleep) OR 
		(Sleep_Hours < &lq_sleepHours_0 - 1.5*IQR_Sleep)
		THEN Outlier_TYPE = "SleepHours"
		;
		ELSE IF(BMI > &uq_bmi_0 + 1.5*IQR_BMI) OR (BMI < &lq_bmi_0 - 1.5*IQR_BMI) THEN Outlier_TYPE = "BMI";
	END;
RUN;

/*human justify*/

DATA lib.health_statistic;
	SET outlier_data;
RUN;

