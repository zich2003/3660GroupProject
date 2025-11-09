LIBNAME lib "/home/u64324048/Group_Project/Code/heart_disease_behaviour/lib";

PROC IMPORT DATAFILE="/home/u64324048/Group_Project/Code/Dataset/bad_behavior_sample_1500.csv"
	OUT=lib.original_data
	DBMS = CSV
	REPLACE
	;
	GETNAMES=YES;
RUN;

PROC PRINT DATA=lib.original_data;
RUN;
