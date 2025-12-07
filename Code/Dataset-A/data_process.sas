LIBNAME lib "/home/u64324048/Group_Project/git/Code/Dataset-A/lib";

DATA orginal_data;
	SET lib.original_data;
	
	RENAME 
		HeartDisease = HavingCVD
		Smoking = SmokingStatus
		Diabetic = Diabetes
		skinCancer = Skin_Cancer
	;
	
	DROP
		DiffWalking
		Race
		GenHealth
	;
		
RUN;

PROC FORMAT;
	VALUE GENDER
		0 = 'Male'
		1 = 'Female'
	;
	
	VALUE bool
		0 = 'No'
		1 = 'Yes'
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

DATA convert_data;
	SET orginal_data;
	    
	ARRAY binary_data(9) 
		SmokingStatus
		Stroke
		PhysicalActivity 
		AlcoholDrinking
		Asthma 
		Diabetes
		KidneyDisease
		Skin_Cancer
		HavingCVD
	;
	
	ARRAY binary_data_num(9) 
		SmokingStatus_num
		Stroke_num
		PhysicalActivity_num
		AlcoholDrinking_num
		Asthma_num
		Diabetes_num
		KidneyDisease_num
		Skin_Cancer_num
		HavingCVD_num
	;
	
	DO i = 1 TO 9;
		IF binary_data(i) = "Yes" OR binary_data(i) = "Ye" THEN binary_data_num(i) = 1;
		ELSE IF binary_data(i) = "No" THEN binary_data_num(i) = 0;
		ELSE binary_data_num(i) = .;
	END;

    
    IF Sex = "Female" THEN GENDER = 1;
    ELSE IF Sex = "Male" THEN GENDER = 0;
    ELSE GENDER = .;
    
    IF AgeCategory NOT = '80 or older' THEN DO;
	    dash_pos = INDEX(AgeCategory, '-');
	    upper = INPUT(SUBSTR(AgeCategory, dash_pos + 1), 8.);
	    
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
	
   	ELSE IF AgeCategory = '80 or older' THEN Age_Range = 10;             
    ELSE Age_Range = .;
 	
RUN;

DATA numeric_data;
	SET convert_data;
	Index = _N_;
	DROP
		SmokingStatus
		Stroke
		AgeCategory
		PhysicalActivity 
		AlcoholDrinking
		Asthma 
		Diabetes
		KidneyDisease
		Skin_Cancer
		HavingCVD
		Sex
		i
		upper
		dash_pos
	;
	
	RENAME
		SmokingStatus_num = SmokingStatus
		Stroke_num = Stroke
		PhysicalActivity_num = Exercise
		AlcoholDrinking_num = AlcoholDrinking
		Asthma_num = Asthma 
		Diabetes_num = Diabetes
		KidneyDisease_num = KidneyDisease
		Skin_Cancer_num = Skin_Cancer
		HavingCVD_num = HavingCVD
		
	;
RUN;

DATA displayed_data;
	SET numeric_data;
	FORMAT 
		Age_Range agefmt.
		SmokingStatus bool.
		Stroke bool.
		Exercise bool.
		AlcoholDrinking bool.
		Asthma bool.
		Diabetes bool.
		KidneyDisease bool.
		Skin_Cancer bool.
		HavingCVD bool.
		GENDER GENDER.
	;
RUN;

DATA lib.convert_data;
	SET displayed_data;
RUN;

PROC PRINT DATA=displayed_data;
RUN;


