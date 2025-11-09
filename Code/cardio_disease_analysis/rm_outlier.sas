LIBNAME lib "/home/u64324048/Group_Project/Code/cardio_disease_analysis/lib";

DATA outliers_data;
	SET lib.process_data;
RUN;

/*Qualtile of Age*/
PROC MEANS DATA=outliers_data
	Q1 Q3 NOPRINT
;
	CLASS cardio;
	
	OUTPUT
		Q1(ap_hi) = LQ_sbp
		Q3(ap_hi) = UQ_sbp
		
		Q1(ap_lo) = LQ_dbp
		Q3(ap_lo) = UQ_dbp
		
		Q1(BMI) = LQ_bmi
		Q3(BMI) = UQ_bmi
		
	 OUT = quartile
	;
RUN;


DATA _NULL_;
	SET quartile;
	IF cardio = 1 THEN DO;
		CALL SYMPUTX("lq_sbp_1", LQ_sbp);
		CALL SYMPUTX("uq_sbp_1", UQ_sbp);
		
		CALL SYMPUTX("lq_dbp_1", LQ_dbp);
		CALL SYMPUTX("uq_dbp_1", UQ_dbp);
		
		CALL SYMPUTX("lq_bmi_1", LQ_bmi);
		CALL SYMPUTX("uq_bmi_1", UQ_bmi);
	END;
	
	IF cardio = 0 THEN DO;
		CALL SYMPUTX("lq_sbp_0", LQ_sbp);
		CALL SYMPUTX("uq_sbp_0", UQ_sbp);
		
		CALL SYMPUTX("lq_dbp_0", LQ_dbp);
		CALL SYMPUTX("uq_dbp_0", UQ_dbp);
		
		CALL SYMPUTX("lq_bmi_0", LQ_bmi);
		CALL SYMPUTX("uq_bmi_0", UQ_bmi);
	END;
RUN;

DATA outliers;
	SET outliers_data;
	
	IF cardio = 1 THEN DO;
		IQR_SBP = &uq_sbp_1 - &lq_sbp_1;
		IQR_DBP = &uq_dbp_1 - &lq_dbp_1;
		IQR_BMI = &uq_bmi_1 - &lq_bmi_1;
			
		IF (ap_hi > &uq_sbp_1 + 1.5*IQR_SBP OR ap_hi < &lq_sbp_1 - 1.5*IQR_SBP) THEN Outlier_TYPE = "ap_hi";
		ELSE IF(ap_lo > &uq_dbp_1 + 1.5*IQR_DBP) OR (ap_lo < &lq_dbp_1 - 1.5*IQR_DBP) THEN Outlier_TYPE = "ap_lo";
		ELSE IF(BMI > &uq_bmi_1 + 1.5*IQR_BMI) OR (BMI < &lq_bmi_1 - 1.5*IQR_BMI) THEN Outlier_TYPE = "BMI";
		
	END;
	
	IF cardio = 0 THEN DO;
		IQR_SBP = &uq_sbp_0 - &lq_sbp_0;
		IQR_DBP = &uq_dbp_0 - &lq_dbp_0;
		IQR_BMI = &uq_bmi_0 - &lq_bmi_0;
		
		IF (ap_hi > &uq_sbp_0 + 1.5*IQR_SBP OR ap_hi < &lq_sbp_0 - 1.5*IQR_SBP) THEN Outlier_TYPE = "ap_hi";
		ELSE IF (ap_lo > &uq_dbp_0 + 1.5*IQR_DBP OR ap_lo < &lq_dbp_0 - 1.5*IQR_DBP) THEN Outlier_TYPE = "ap_lo";
		ELSE IF(BMI > &uq_bmi_0 + 1.5*IQR_BMI) OR (BMI < &lq_bmi_0 - 1.5*IQR_BMI) THEN Outlier_TYPE = "BMI";
	END;
RUN;

DATA selected_outliers;
	SET outliers;
	IF Outlier_TYPE = "BMI";
RUN;

/*
DATA final_outliers;
	SET  outliers_data;
	IF (ap_lo >= 1000 OR ap_hi >= 1000) OR (ap_lo <= 40 OR ap_hi <= 40);
RUN;
*/

/*Remove Outliers*/
DATA final_result;
	SET outliers_data;
	
	IF (ap_lo >= 1000 OR ap_hi >= 1000) OR 
	(ap_lo <= 40 OR ap_hi <= 40) OR 
	(ap_lo >= ap_hi)
	
	THEN DO;
		ap_lo = .;
		ap_hi = .;
	END;
	
	ELSE IF (BMI > 60) THEN BMI =.;
RUN;

DATA lib.rm_outlier;
	SET final_result;
RUN;

