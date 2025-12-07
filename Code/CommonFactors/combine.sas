LIBNAME lib "/home/u64324048/Group_Project/git/Code/CommonFactors/lib";

DATA lib.ALL;
	SET 
	 lib.datasetA (KEEP = BMI Age_Range BMI_Class GENDER HavingCVD)
	 lib.datasetB (KEEP = BMI Age_Range BMI_Class GENDER HavingCVD)
	 lib.datasetD (KEEP = BMI Age_Range BMI_Class GENDER HavingCVD)
	;
RUN;

DATA lib.DatasetAD;
	SET
		lib.datasetA (KEEP = BMI Age_Range BMI_Class GENDER SmokingStatus Diabetes Exercise HavingCVD)
		lib.datasetD (KEEP = BMI Age_Range BMI_Class GENDER SmokingStatus Diabetes Exercise HavingCVD)
	;
RUN;

DATA lib.DatasetAB;
	SET
		lib.datasetA (KEEP =  BMI Age_Range BMI_Class GENDER AlcoholDrinking HavingCVD)
		lib.datasetB (KEEP =  BMI Age_Range BMI_Class GENDER AlcoholDrinking HavingCVD)
	;
RUN;

PROC PRINT DATA=lib.ALL;
RUN;
