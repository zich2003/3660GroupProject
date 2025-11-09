LIBNAME lib "/home/u64324048/Group_Project/Code/cardio_disease_analysis/lib";

DATA convert_data;
	SET lib.original_data;
RUN;

DATA main_convert;
	SET convert_data;
	age = INT(age/365);
	BMI = (weight/(height/100)**2);
	
	LENGTH BMI_class $ 12.;
	
    IF gender = 1 THEN gender = 0;
    ELSE IF gender = 2 THEN gender = 1;
    ELSE gender = .;
    
	KEEP age gender BMI smoke alco cholesterol active ap_hi ap_lo cardio;
RUN;


DATA lib.process_data;
	SET main_convert;
RUN;


PROC PRINT DATA=main_convert;
RUN;