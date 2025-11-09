LIBNAME lib "/home/u64324048/Group_Project/Code/healthStatus/lib";

PROC IMPORT DATAFILE="/home/u64324048/Group_Project/Code/Dataset/heart_disease_sample_1500.xlsx"
	DBMS=XLSX
	OUT=lib.health_statistic
	REPLACE;
RUN;

PROC PRINT DATA=lib.health_statistic;
RUN;