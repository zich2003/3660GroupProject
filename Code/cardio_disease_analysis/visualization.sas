LIBNAME lib "/home/u64324048/Group_Project/Code/cardio_disease_analysis/lib";

DATA visualize_data;
	SET lib.lib.labelling_data;
RUN;

PROC SGPLOT DATA=visualize_data;
	SCATTER X=ap_hi Y=ap_lo;
RUN;

PROC UNIVARIATE DATA=visualize_data;
	VAR BMI;
RUN;

