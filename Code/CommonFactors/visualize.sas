LIBNAME lib "/home/u64324048/Group_Project/git/Code/CommonFactors/lib";
ODS POWERPOINT FILE = '/home/u64324048/Group_Project/git/Code/CommonFactors/visualize.pptx';
ODS GRAPHICS / WIDTH=20cm HEIGHT=20cm;

DATA visualize_data;
	SET lib.all;
RUN;

PROC SGPLOT DATA=visualize_data;
	VBAR GENDER / GROUP=HavingCVD groupdisplay=cluster;
RUN;
