LIBNAME lib "/home/u64324048/Group_Project/git/Code/Dataset-D/lib";

DATA outliers_data;
	SET lib.process_data;
RUN;

/*Qualtile of Age*/
PROC MEANS DATA=outliers_data
	Q1 Q3 NOPRINT
;
	CLASS HavingCVD;
	
	OUTPUT
		Q1(BMI) = LQ_bmi
		Q3(BMI) = UQ_bmi
	OUT = quartile
	;
RUN;


DATA _NULL_;
	SET quartile;
	IF  HavingCVD = 1 THEN DO;
		CALL SYMPUTX("lq_bmi_1", LQ_bmi);
		CALL SYMPUTX("uq_bmi_1", UQ_bmi);
	END;
	
	IF HavingCVD = 0 THEN DO;
		CALL SYMPUTX("lq_bmi_0", LQ_bmi);
		CALL SYMPUTX("uq_bmi_0", UQ_bmi);
	END;
RUN;

DATA outliers;
	SET outliers_data;
	
	IF HavingCVD = 1 THEN DO;
	
		IQR_BMI = &uq_bmi_1 - &lq_bmi_1;
		
		IF
			(BMI > &uq_bmi_1 + 1.5*IQR_BMI) OR 
			(BMI < &lq_bmi_1 - 1.5*IQR_BMI)
			
		THEN 
			PotentialOutlierClass = "BMI (Having CVD)"
		;
		
	END;
	
	IF  HavingCVD = 0 THEN DO;
		IQR_BMI = &uq_bmi_0 - &lq_bmi_0;
		IF
			(BMI > &uq_bmi_0 + 1.5*IQR_BMI) OR 
			(BMI < &lq_bmi_0 - 1.5*IQR_BMI) 
		THEN 
			PotentialOutlierClass = "BMI (Not Having CVD)"
		;
	END;
	
	DROP IQR_BMI;
RUN;

PROC SORT DATA=outliers OUT=ranked_bmi_outliers;
    WHERE PotentialOutlierClass IN ("BMI (Having CVD)", "BMI (Not Having CVD)");
    BY DESCENDING BMI;
RUN;

/*Remove Outliers*/
**Outliers Summary;
PROC PRINT DATA=ranked_bmi_outliers;
	TITLE "Potential Outliers of BMI";
RUN;

DATA lib.rm_outlier;
	SET outliers_data; **No outliers is found;
	TITLE "Cleaned_Data";
RUN;

PROC PRINT DATA=lib.rm_outlier;
RUN;

