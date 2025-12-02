LIBNAME lib "/home/u64324048/Group_Project/git/Code/Dataset-B/lib";
LIBNAME common "/home/u64324048/Group_Project/git/Code/CommonFactors/lib";

DATA original_data;
	SET lib.rm_outliers;
RUN;

PROC FORMAT;
	VALUE bool
		1 = 'Yes'
		0 = 'No'
	;
	
   	VALUE bmifmtConvert
        low - 18.5 = 1       
        18.5-24 = 2       
        24-28 = 3      
        28-HIGH = 4
    ;
    
   	VALUE bmifmt
        1 = 'OVER-THIN'       
        2 = 'NORMAL'
        3 = 'OVER-FAT'      
        4 = 'OBESITY'
    ;
    
 	
 	VALUE dayfmt
       0 = "0 days"
       1-7 = '1-7 days'
       8-14 = '8-14 days'
       15-21 = '15-21 days'
       22-28 = '22-28 days'
       28 - high = '>28 days'
    ;
    
    
    VALUE agefmtConvert  
        LOW -< 40 = 1    
        40 -< 45 = 2  
        45 -< 50 = 3   
        50 -< 55 = 4 
        55 -< 60 = 5  
        60 -< 65 = 6
        65 -< 70 = 7  
        70 -< 75 = 8    
        75 - 80 = 9     
        80 - HIGH = 10 
    ;
    
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


**HBP = High Blood Pressure;

DATA labelling_data;
	SET original_data;
	
	IF SBP NOT = . OR DBP NOT =. THEN DO;
	    IF 
		    (SBP >= 140 AND DBP < 90) OR 
		    (SBP < 140 AND DBP >= 90) OR
		    (SBP >= 140 AND DBP >= 90)
	    
	    THEN 
	    	HBPStatus = 1;
	    	
	    ELSE IF 
	    	(SBP< 140 AND DBP < 90)
	    	
	    THEN 
	    	HBPStatus = 0;
    END;
    
    IF BMI NOT = . THEN DO;
		BMI_Class = PUT(BMI, bmifmtConvert.);
	END;
	
	IF Age NOT = . THEN DO;
		Age_Range = PUT(Age, agefmtConvert.);
	END;
	
	Age_Range_Num = INPUT(Age_Range, 3.);
	
	DROP 
		Age_Range
	;
	
	RENAME 
		Age_Range_Num = Age_Range
	;
RUN;

DATA labelled_data;
	SET labelling_data;
	
	BMI_Class_Num = INPUT(BMI_Class,3.);
	
	DROP 
		BMI_Class
	;
	
	RENAME 
		BMI_Class_Num = BMI_Class
	;
RUN;

DATA common.datasetB;
	SET labelled_data (DROP = id age sbp dbp 'Index'n);
	FORMAT 
		Age_Range agefmt.
		HBPStatus bool.
		BMI_Class bmifmt.
	;
RUN;

DATA lib.labelling_data;
	SET labelled_data;
	FORMAT 
		Age_Range agefmt.
		HBPStatus bool.
		BMI_Class bmifmt.
	;
RUN;

PROC PRINT DATA=lib.labelling_data;
RUN;