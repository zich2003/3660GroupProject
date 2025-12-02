LIBNAME lib "/home/u64324048/Group_Project/git/Code/Dataset-A/lib";

DATA outliers_data;
	SET lib.convert_data;
RUN;

/*Qualtile of Age*/
PROC MEANS DATA=outliers_data
	Q1 Q3 NOPRINT
;
	CLASS HavingCVD;
	
	OUTPUT
		Q1(BMI) = LQ_bmi
		Q3(BMI) = UQ_bmi
		
		Q1(SleepTime) = LQ_SleepTime
		Q3(SleepTime) = UQ_SleepTime
	OUT = quartile
	;
RUN;


DATA _NULL_;
	SET quartile;
	IF  HavingCVD = 1 THEN DO;
		CALL SYMPUTX("lq_bmi_1", LQ_bmi);
		CALL SYMPUTX("uq_bmi_1", UQ_bmi);
		
		CALL SYMPUTX("lq_sleepTime_1", LQ_SleepTime);
		CALL SYMPUTX("uq_sleepTime_1", UQ_SleepTime);
	END;
	
	IF HavingCVD = 0 THEN DO;
		CALL SYMPUTX("lq_bmi_0", LQ_bmi);
		CALL SYMPUTX("uq_bmi_0", UQ_bmi);
		
		CALL SYMPUTX("lq_sleepTime_0", LQ_SleepTime);
		CALL SYMPUTX("uq_sleepTime_0", UQ_SleepTime);
	END;
RUN;

DATA outliers;
	SET outliers_data;
	LENGTH PotentialOutlierClass $26.;
	
	IF HavingCVD = 1 THEN DO;
	
		IQR_BMI = &uq_bmi_1 - &lq_bmi_1;
		IQR_SleepTime = &uq_sleepTime_1 - &lq_sleepTime_1;
		
		IF
			(BMI > &uq_bmi_1 + 1.5*IQR_BMI) OR 
			(BMI < &lq_bmi_1 - 1.5*IQR_BMI) 
		THEN 
			PotentialOutlierClass = "BMI (Having CVD)"
		;
		
		IF 
			(SleepTime > &uq_sleepTime_1 + 1.5*IQR_SleepTime) OR
			(SleepTime < &lq_sleepTime_1 - 1.5*IQR_SleepTime)
			
		THEN 
			PotentialOutlierClass = "SleepTime (Having CVD)"
		;
	END;
	
	ELSE IF  HavingCVD = 0 THEN DO;
		IQR_BMI = &uq_bmi_0 - &lq_bmi_0;
		IQR_SleepTime = &uq_sleepTime_0 - &lq_sleepTime_0;
		
		IF
			(BMI > &uq_bmi_0 + 1.5*IQR_BMI) OR 
			(BMI < &lq_bmi_0 - 1.5*IQR_BMI) 
		THEN 
			PotentialOutlierClass = "BMI (Not Having CVD)"
		;
		
		IF 
			(SleepTime > &uq_sleepTime_0 + 1.5*IQR_SleepTime) OR
			(SleepTime < &lq_sleepTime_0 - 1.5*IQR_SleepTime)
			
		THEN 
			PotentialOutlierClass = "SleepTime (Not Having CVD)"
		;
	END;
	
	ELSE
		PotentialOutlierClass = "Not Potential Outlier"
	;
	
	DROP IQR_BMI;
RUN;

PROC SORT DATA=outliers OUT=ranked_bmi_outliers;
    WHERE PotentialOutlierClass IN ("BMI (Having CVD)", "BMI (Not Having CVD)");
    BY PotentialOutlierClass DESCENDING BMI;
RUN;

PROC SORT DATA=outliers OUT=ranked_SleepTime_outliers;
    WHERE PotentialOutlierClass IN ("SleepTime (Having CVD)", "SleepTime (Not Having CVD)");
    BY PotentialOutlierClass DESCENDING SleepTime;
RUN;

/*Remove Outliers*/
**Outliers Summary;
PROC PRINT DATA=ranked_bmi_outliers;
	TITLE "Potential Outliers of BMI";
RUN;
PROC PRINT DATA=ranked_SleepTime_outliers;
	TITLE "Potential Outliers of SleepTime";
RUN;

DATA lib.rm_outliers_data;
	SET outliers_data;
	IF SleepTime >= 16 OR SleepTime <= 2 THEN DELETE; **No Outliers Found in BMI;
	TITLE "Cleaned_Data";
RUN;

PROC PRINT DATA=lib.rm_outliers_data;
RUN;
