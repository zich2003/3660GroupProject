LIBNAME lib "/home/u64324048/Group_Project/git/Code/Dataset-B/lib";



PROC FORMAT;
	VALUE level
		1 = "Normal"
		2 = "Above Normal"
		3 = "Well Above Normal"
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
	SET lib.original_data;
	
	RENAME 
    	cardio = HavingCVD
    	ap_hi = SBP
    	ap_lo = DBP
    	alco = AlcoholDrinking
    	smoke = SmokingStatus
    ;
RUN;

DATA main_convert;
	SET convert_data;
	age = age/365;
	BMI = ROUND(weight/(height/100)**2, 0.01);
	
    IF gender = 1 THEN gender = 0;
    ELSE IF gender = 2 THEN gender = 1;
    ELSE gender = .;
   
    Index = _N_;
RUN;


DATA lib.process_data;
	SET main_convert;

	DROP 
		height
		weight
	;
	
	FORMAT 
		cholesterol level.
		active bool.
		HavingCVD bool.
		gluc level.
		gender gender.
		AlcoholDrinking bool.
		SmokingStatus bool.
	;
	
RUN;

PROC PRINT DATA=lib.process_data;
	WHERE BMI > 100;
RUN;