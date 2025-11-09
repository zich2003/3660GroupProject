LIBNAME lib "/home/u64324048/Group_Project/Code/heart_disease_behaviour/lib";
LIBNAME common "/home/u64324048/Group_Project/Code/CommonFactors/lib";

DATA orginal_data;
	SET lib.rm_outlier_data;
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

DATA labelling;
	SET orginal_data;
	
    dash_pos = INDEX(AgeCategory, '-');
    upper = INPUT(SUBSTR(AgeCategory, dash_pos + 1), 8.);
    
   
   	LENGTH BMI_class 8.;
   	
	IF BMI NOT = . THEN DO;
		IF BMI <= 18.5 THEN BMI_class = 1;
	    ELSE IF BMI > 18.5 AND BMI <= 24 THEN BMI_class = 2;
	    ELSE IF BMI > 24.0 AND BMI <= 28 THEN BMI_class = 3;
	    ELSE IF BMI > 28.0 THEN BMI_class = 4;
	END;
	
	LENGTH Age_Range 8; 
    
    IF upper <= 40 THEN Age_Range = 1;                
    ELSE IF upper > 40 AND upper <= 45 THEN Age_Range = 2; 
    ELSE IF upper > 45 AND upper <= 50 THEN Age_Range = 3; 
    ELSE IF upper > 50 AND upper <= 55 THEN Age_Range = 4; 
    ELSE IF upper > 55 AND upper <= 60 THEN Age_Range = 5;
    ELSE IF upper > 60 AND upper <= 65 THEN Age_Range = 6; 
    ELSE IF upper > 65 AND upper <= 70 THEN Age_Range = 7; 
    ELSE IF upper > 70 AND upper <= 75 THEN Age_Range = 8; 
    ELSE IF upper > 75 AND upper <= 80 THEN Age_Range = 9;
    ELSE IF upper > 80 THEN Age_Range = 10;             
    ELSE Age_Range = .;
    
    
    FORMAT Age_Range agefmt. BMI_class bmifmt.; 
RUN;

DATA common.behavior_data;
	SET labelling;
	KEEP Age_Range GENDER BMI BMI_class Smoking alco SleepTime cardio;
RUN;

DATA lib.labelling_data;
	SET labelling;
RUN;

PROC PRINT DATA= labelling_data;
RUN;

