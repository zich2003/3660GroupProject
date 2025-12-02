LIBNAME lib "/home/u64324048/Group_Project/git/Code/Dataset-D/lib";

PROC IMPORT DATAFILE="/home/u64324048/Group_Project/git/Code/Dataset/datasetD_sample_1500.xlsx"
	DBMS=XLSX
	OUT=lib.original_data
	REPLACE;
RUN;

PROC PRINT DATA=lib.original_data;
RUN;