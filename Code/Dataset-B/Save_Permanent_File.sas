LIBNAME lib "/home/u64324048/Group_Project/git/Code/Dataset-B/lib";

DATA original_data;
	INFILE "/home/u64324048/Group_Project/git/Code/Dataset/cardio_sample_1500.dat"
	FIRSTOBS=2
	DELIMITER=","
	;
	INPUT id
	age
	gender	
	height	
	weight	
	ap_hi	
	ap_lo	
	cholesterol	
	gluc	
	smoke	
	alco	
	active	
	cardio
;
RUN;

DATA lib.original_data;
	SET original_data;
RUN;

PROC PRINT DATA=lib.original_data;
RUN;

