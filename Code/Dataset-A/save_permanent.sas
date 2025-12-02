LIBNAME lib "/home/u64324048/Group_Project/git/Code/Dataset-A/lib";

PROC IMPORT DATAFILE="/home/u64324048/Group_Project/git/Code/Dataset/Dataset-A.csv"
	OUT=lib.original_data
	DBMS = CSV
	REPLACE
	;
	GETNAMES=YES;
RUN;

PROC PRINT DATA=lib.original_data;
RUN;
