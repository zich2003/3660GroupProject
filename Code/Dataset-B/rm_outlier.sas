LIBNAME lib "/home/u64324048/Group_Project/git/Code/Dataset-B/lib";
ODS POWERPOINT FILE = '/home/u64324048/Group_Project/git/Code/Dataset-B/dataset_B_outliers.pptx';

DATA outliers_data;
	SET lib.process_data;
RUN;

/*Qualtile of Age*/
PROC MEANS DATA=outliers_data
	Q1 Q3 NOPRINT
;
	CLASS HavingCVD;
	
	OUTPUT
		Q1(sbp) = LQ_sbp
		Q3(sbp) = UQ_sbp
		
		Q1(dbp) = LQ_dbp
		Q3(dbp) = UQ_dbp
		
		Q1(BMI) = LQ_bmi
		Q3(BMI) = UQ_bmi
		
	 OUT = quartile
	;
RUN;


DATA _NULL_;
	SET quartile;
	IF  HavingCVD = 1 THEN DO;
		CALL SYMPUTX("lq_sbp_1", LQ_sbp);
		CALL SYMPUTX("uq_sbp_1", UQ_sbp);
		
		CALL SYMPUTX("lq_dbp_1", LQ_dbp);
		CALL SYMPUTX("uq_dbp_1", UQ_dbp);
		
		CALL SYMPUTX("lq_bmi_1", LQ_bmi);
		CALL SYMPUTX("uq_bmi_1", UQ_bmi);
	END;
	
	IF HavingCVD = 0 THEN DO;
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
	LENGTH PotentialOutlierClass $22.;
	IF HavingCVD = 1 THEN DO;
		IQR_SBP = &uq_sbp_1 - &lq_sbp_1;
		IQR_DBP = &uq_dbp_1 - &lq_dbp_1;
		IQR_BMI = &uq_bmi_1 - &lq_bmi_1;
			
		IF 
			(SBP > &uq_sbp_1 + 1.5*IQR_SBP) OR 
			(SBP < &lq_sbp_1 - 1.5*IQR_SBP) 
		THEN 
			PotentialOutlierClass = "SBP (Having CVD)"
		;
		
		ELSE IF
			(DBP > &uq_dbp_1 + 1.5*IQR_DBP) OR 
			(DBP < &lq_dbp_1 - 1.5*IQR_DBP)
			
		THEN 
			PotentialOutlierClass = "DBP (Having CVD)"
		;
		
		ELSE IF
			(BMI > &uq_bmi_1 + 1.5*IQR_BMI) OR 
			(BMI < &lq_bmi_1 - 1.5*IQR_BMI) 
		
		THEN 
			PotentialOutlierClass = "BMI (Having CVD)"
		;
		
	END;
	
	IF  HavingCVD = 0 THEN DO;
		IQR_SBP = &uq_sbp_0 - &lq_sbp_0;
		IQR_DBP = &uq_dbp_0 - &lq_dbp_0;
		IQR_BMI = &uq_bmi_0 - &lq_bmi_0;
		
		IF 
			(sbp > &uq_sbp_0 + 1.5*IQR_SBP) OR 
			(sbp < &lq_sbp_0 - 1.5*IQR_SBP) 
		THEN 
			PotentialOutlierClass = "SBP (Not Having CVD)"
		;
		
		ELSE IF 
			(dbp > &uq_dbp_0 + 1.5*IQR_DBP) OR 
			(dbp < &lq_dbp_0 - 1.5*IQR_DBP) 
		THEN 
			PotentialOutlierClass = "DBP (Not Having CVD)" 
		;
		
		ELSE IF
			(BMI > &uq_bmi_0 + 1.5*IQR_BMI) OR 
			(BMI < &lq_bmi_0 - 1.5*IQR_BMI) 
		THEN 
			PotentialOutlierClass = "BMI (Not Having CVD)"
		;
	END;
	
	KEEP Index BMI sbp dbp PotentialOutlierClass;
RUN;

PROC PRINT DATA=outliers_data;
	WHERE 
		(SBP >= 1000 OR SBP <= 12) OR
		(DBP >= 1000 OR DBP <= 20) 
	;
RUN;


PROC SORT DATA=outliers OUT=ranked_bmi_outliers;
    WHERE PotentialOutlierClass IN ("BMI (Having CVD)", "BMI (Not Having CVD)");
    BY DESCENDING BMI;
RUN;

PROC SORT DATA=outliers OUT=ranked_ap_hi_outliers;
    WHERE PotentialOutlierClass IN ("SBP (Having CVD)", "SBP (Not Having CVD)");
    BY DESCENDING SBP;
RUN;

PROC SORT DATA=outliers OUT=ranked_ap_lo_outliers;
    WHERE PotentialOutlierClass IN ("DBP (Having CVD)", "DBP (Not Having CVD)");
    BY DESCENDING DBP;
RUN;


/*Remove Outliers*/
**Outliers Summary;

PROC PRINT DATA=ranked_bmi_outliers;
	TITLE "Potential Outliers of BMI";
RUN;

PROC PRINT DATA=ranked_ap_lo_outliers;
	TITLE "Potential Outliers of DBP";
RUN;

PROC PRINT DATA=ranked_ap_hi_outliers ;
	TITLE "Potential Outliers of SBP";
RUN;

DATA filtered_data;
	**Setting the threshold value of outliers;
	SET outliers_data;
	IF 
		(SBP >= 1000 OR SBP <= 12) OR
		(DBP >= 1000 OR DBP <= 20) OR 
		BMI > 62.5
	THEN 
		DELETE
	;
RUN;

DATA lib.rm_outliers;
	SET filtered_data;
RUN;


