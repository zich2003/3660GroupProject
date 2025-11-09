LIBNAME lib "/home/u64324048/Group_Project/Code/healthStatus/lib";
LIBNAME common "/home/u64324048/Group_Project/Code/CommonFactors/lib";

DATA original_data;
	SET lib.health_statistic;
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
	IF Blood_Pressure >= 140 THEN HBP = 1;
	ELSE IF  Blood_Pressure < 140 THEN HBP= 0;
	ELSE High_Blood_Pressure = .;
	
	LENGTH BMI_class 8.;
	
	IF BMI NOT = . THEN DO;
		IF BMI <= 18.5 THEN BMI_class = 1;
	    ELSE IF BMI > 18.5 AND BMI <= 24 THEN BMI_class = 2;
	    ELSE IF BMI > 24.0 AND BMI <= 28 THEN BMI_class = 3;
	    ELSE IF BMI > 28.0 THEN BMI_class = 4;
	END;
	
	LENGTH Age_Range 8.;
	
	IF Age < 40 THEN Age_Range = 1;
	    ELSE IF Age >= 40 AND age < 44 THEN Age_Range = 2;
	    ELSE IF Age >= 44 AND age < 49 THEN Age_Range = 3;
	    ELSE IF Age >= 49 AND age < 54 THEN Age_Range = 4;
	    ELSE IF Age >= 54 AND age < 59 THEN Age_Range = 5;
	    ELSE IF Age >= 59 AND age < 64 THEN Age_Range = 6;
	    ELSE IF Age >= 64 AND age < 69 THEN Age_Range = 7;
	    ELSE IF Age >= 69 AND age < 74 THEN Age_Range = 8;
	    ELSE IF Age >= 74 AND age < 80 THEN Age_Range = 9;
	    ELSE IF Age >= 80 THEN Age_Range = 10;
    
    FORMAT Age_Range agefmt. BMI_class bmifmt.;
RUN;


DATA common.healthStatus;
	SET labelling_data (
	KEEP=Age_Range
	BMI_class
	High_Blood_Pressure 
	Gender
	alco
	Smoking 
	SleepTime
	cardio
	);
	
	IF alco >= 2 THEN alco=1;
	ELSE IF alco = 1 THEN alco = 0;
RUN;

DATA lib.health_statistic;
	SET labelling_data;
RUN;

PROC PRINT DATA=lib.health_statistic;
RUN;