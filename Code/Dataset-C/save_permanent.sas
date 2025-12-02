LIBNAME lib "/home/u64324048/Group_Project/git/Code/Dataset";

PROC IMPORT DATAFILE="/home/u64324048/Group_Project/git/Code/Dataset/heart_disease_sample_1500.xlsx"
	DBMS=XLSX
	OUT=lib.health_statistic
	REPLACE;
RUN;

PROC PRINT DATA=lib.health_statistic;
RUN;