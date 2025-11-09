LIBNAME lib "/home/u64324048/Group_Project/Code/cardio_disease_analysis/lib";
LIBNAME common "/home/u64324048/Group_Project/Code/CommonFactors/lib";

DATA original_data;
	SET lib.rm_outlier;
	RENAME
		smoke = smoking;
RUN;

PROC FORMAT;
    VALUE bmifmt
        1 = "OVER-THIN"        
        2 = "NORMAL"       
        3 = "OVER-FAT"      
        4 = "OBESITY"
    ;
RUN;

PROC FORMAT;
    VALUE agefmt
        1 = "<= 40"        
        2 = "41-45"       
        3 = "46-50"      
        4 = "51-55"        
        5 = "56-60"      
        6 = "61-65"         
        7 = "66-70"       
        8 = "71-75"   
        9 = "76-80"        
        10 = ">= 80"  
    ;
RUN;

DATA labelling_data;
	SET original_data;
	
	IF ap_hi NOT = . OR ap_lo NOT =. THEN DO;
	    IF (
	    (ap_hi >= 140 AND ap_lo < 90) OR 
	    (ap_hi < 140 AND ap_lo >= 90) OR
	    (ap_hi >= 140 AND ap_lo >= 90)
	    )
	    THEN high_blood_pressure = 1;
	    ELSE IF (ap_hi < 140 AND ap_lo < 90)
	    THEN high_blood_pressure = 0;
    END;
    
    IF BMI NOT = . THEN DO;
		IF BMI <= 18.5 THEN BMI_class = 1;
	    ELSE IF BMI > 18.5 AND BMI <= 24 then BMI_class = 2;
	    ELSE IF BMI > 24.0 AND BMI <= 28 then BMI_class = 3;
	    ELSE IF BMI > 28.0 THEN BMI_class = 4;
	END;
	
	LENGTH Age_Range 8.;
	
	IF age < 40 THEN Age_Range = 1;
	    ELSE IF age >= 40 AND age < 44 THEN Age_Range = 2;
	    ELSE IF age >= 44 AND age < 49 THEN Age_Range = 3;
	    ELSE IF age >= 49 AND age < 54 THEN Age_Range = 4;
	    ELSE IF age >= 54 AND age < 59 THEN Age_Range = 5;
	    ELSE IF age >= 59 AND age < 64 THEN Age_Range = 6;
	    ELSE IF age >= 64 AND age < 69 THEN Age_Range = 7;
	    ELSE IF age >= 69 AND age < 74 THEN Age_Range = 8;
	    ELSE IF age >= 74 AND age < 80 THEN Age_Range = 9;
	    ELSE IF age >= 80 THEN Age_Range = 10;
    
    FORMAT Age_Range agefmt. BMI_class bmifmt.;
RUN;

DATA lib.labelling_data;
	SET labelling_data;
RUN;

DATA common.cardio;
	SET labelling_data (KEEP = gender smoking cardio high_blood_pressure BMI BMI_class Age_Range active);
RUN;


PROC PRINT DATA=labelling_data;
RUN;