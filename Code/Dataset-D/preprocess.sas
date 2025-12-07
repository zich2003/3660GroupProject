LIBNAME lib "/home/u64324048/Group_Project/git/Code/Dataset-D/lib";

DATA orginal_data;
	SET lib.original_data;
	
	RENAME 
		Heart_Disease = HavingCVD
	;
	
	DROP
		Fruit_Consumption
		Green_Vegetables_Consumption
		FriedPotato_Consumption
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
    
   	VALUE bool
		0 = "No"
		1 = "Yes"
	;
	
    
    VALUE Gender
    	0 = 'Male'
    	1 = 'Female'
    ;

RUN;


DATA convert_data;
	SET orginal_data;
	 
	ARRAY binary_data(8) 
		Exercise 
		Skin_Cancer 
		Other_Cancer 
		Depression 
		Diabetes
		Arthritis
		Smoking_History
		HavingCVD
	;
	
	ARRAY binary_data_num(8) 
		Exercise_num
		Skin_Cancer_num
		Other_Cancer_num
		Depression_num
		Diabetes_num
		Arthritis_num
		Smoking_History_num
		HavingCVD_num 
	;
	
	DO i = 1 TO 8;
		IF 
			binary_data(i) = "Yes" THEN binary_data_num(i) = 1;
		ELSE IF 
			binary_data(i) = "No" THEN binary_data_num(i) = 0;
		ELSE 
			binary_data_num(i) = .
		;
		
	END;

    
    IF 
    	Sex = "Female" THEN GENDER = 1;
    ELSE IF 
    	Sex = "Male" THEN GENDER = 0;
    ELSE 
    	GENDER = .
    ;
    
    IF Age_Category NOT = '80+' THEN DO;
	    dash_pos = INDEX(Age_Category, '-');
	    upper = INPUT(SUBSTR(Age_Category, dash_pos + 1), 8.);
	    
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
	    ELSE Age_Range = .;
	END;
	
   	ELSE IF Age_Category = '80+' THEN Age_Range = 10;             
    ELSE Age_Range = .;
    
    DROP
		Sex
		i
		General_Health
		Checkup
	    Skin_Cancer 
	    Other_Cancer 
	    Depression 
	    Diabetes
	    Arthritis
	    HavingCVD
	    Smoking_History
	 	'Height_(cm)'n
	 	'Weight_(kg)'n
	 	upper
	 	Age_Category
	 	dash_pos
	 	Exercise
	;
	

	RENAME 
	    Exercise_num = Exercise
	    Skin_Cancer_num = Skin_Cancer
	    Other_Cancer_num = Other_Cancer
	    Depression_num = Depression
	    Diabetes_num = Diabetes
	    Arthritis_num = Arthritis
	    Smoking_History_num = SmokingStatus
	   	HavingCVD_num = HavingCVD
	;
 	
RUN;

DATA lib.process_data;
	SET convert_data;
	FORMAT 
		Exercise bool.
		Skin_Cancer bool.
		Other_Cancer bool.
		Depression bool.
		Diabetes bool.
		Arthritis bool.
		SmokingStatus bool.
		HavingCVD bool.
		GENDER Gender.
		Age_range agefmt.
	  ;
RUN;

PROC PRINT DATA=lib.process_data;
RUN;
