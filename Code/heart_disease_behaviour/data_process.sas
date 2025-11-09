LIBNAME lib "/home/u64324048/Group_Project/Code/heart_disease_behaviour/lib";
LIBNAME common "/home/u64324048/Group_Project/Code/CommonFactors/lib";

DATA orginal_data;
	SET lib.original_data;
	
	RENAME 
		HeartDisease = cardio
		AlcoholDrinking = alco
		;
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


DATA convert_data;
	SET orginal_data;
	LENGTH AgeCategory $ 15;
	    
	ARRAY binary_data(4) Smoking alco PhysicalActivity cardio;
	
	DO i = 1 TO 4;
		IF binary_data(i) = "Yes" OR binary_data(i) = "Ye" THEN binary_data(i) = 1;
		ELSE IF binary_data(i) = "No" THEN binary_data(i) = 0;
		ELSE binary_data(i) = .;
	END;

    
    IF Sex = "Female" THEN GENDER = 1;
    ELSE IF Sex = "Male" THEN GENDER = 0;
    ELSE GENDER = .;
 
RUN;

DATA lib.convert_data;
	SET convert_data;
RUN;

PROC PRINT DATA=lib.convert_data;
RUN;


