LIBNAME lib "/home/u64324048/Group_Project/Code/CommonFactors/lib";

DATA analysis_data;
	SET lib.all;
RUN;

DATA analysis_CardioBehavior;
	SET lib.cardiobehavior;
RUN;

PROC FREQ DATA=analysis_CardioBehavior;
	TABLES Age_Range * HasCardioDisease;
RUN;