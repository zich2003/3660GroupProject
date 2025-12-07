LIBNAME lib "/home/u64324048/Group_Project/git/Code/CommonFactors/lib";
ODS POWERPOINT FILE = '/home/u64324048/Group_Project/git/Code/CommonFactors/outputfile/analysis.pptx';
ODS GRAPHICS ON / width= 16cm height=12cm;

** Analysis All;
DATA analysis_data;
	SET lib.all;
RUN;


PROC TTEST DATA=analysis_data ALPHA=0.05;
	CLASS HavingCVD;
	VAR BMI;
	TITLE "The mean difference analysis between Diseased and non-disease samples";
RUN;


PROC TTEST DATA=analysis_data ALPHA=0.05;
	CLASS Gender;
	VAR BMI;
	TITLE "The BMI difference between Male and Female samples";
RUN;

PROC FREQ DATA = analysis_data;
	TABLE HavingCVD*Gender/ OUTPCT CHISQ OUT=Gender_analysis;
	TABLE HavingCVD*Age_Range/OUTPCT CHISQ OUT=Age_Range_analysis;
	TABLE HavingCVD*BMI_Class / OUTPCT CHISQ OUT=BMI_Class_analysis;
	
	TABLE Gender*BMI_Class / OUTPCT OUT=BMI_Class_Gender_analysis;
	TITLE "The association analysis between Discrete Data and CVD status";
RUN;

PROC PRINT DATA=Age_Range_analysis;
RUN;

PROC SGPLOT DATA=Gender_analysis;
	VBAR Gender / 
		Response=PCT_COL 	
		BARWIDTH=1
	;
	
	WHERE HavingCVD = 1;
	
	YAXIS 
		MIN = 0 
		MAX=100
		LABEL="Prevalence"
	;
	
	XAXIS 
		LABEL="Gender"
	;
	
	TITLE "The Prevalence analysis between Gender and CVD status";
RUN;

PROC SGPLOT DATA=Age_Range_analysis;
	WHERE HavingCVD = 1;
	SERIES 
		X = Age_Range
		Y = PCT_COL
	/	
		markers 
		markerattrs=(symbol=circlefilled size=6)
        lineattrs=(color=red thickness=2);
	;
	
	YAXIS 
		MIN = 0 
		MAX=100
		LABEL="Prevalence"
	;
	
	XAXIS 
	  	TYPE=discrete
		MIN = 0
		LABEL="Age Range"
	;
	
	TITLE "The Age_Range analysis between Gender and CVD status";
RUN;

PROC SGPLOT DATA=BMI_Class_analysis;
	WHERE HavingCVD = 1;
	VBAR BMI_CLASS / RESPONSE=PCT_COL BARWIDTH=1
	;
	YAXIS 
		MIN = 0 
		MAX=100
		LABEL="Percentage"
	;
	
	XAXIS 
	  	TYPE=discrete
		MIN = 0
		LABEL="BMI_Class"
	;
	
	TITLE "BMI distribution among disease samples";
RUN;

PROC SGPLOT DATA=BMI_Class_Gender_analysis;;
	VBAR Gender / 
		Response=PCT_COL 
		Group= BMI_Class 
		GROUPDISPLAY=cluster 
	;
	YAXIS 
		MIN = 0 
		MAX=100
		LABEL="Percentage"
	;
	
	XAXIS 
	  	TYPE=discrete
		MIN = 0
		LABEL="Gender"
	;
	
	TITLE "BMI distribution between genders";
RUN;

PROC ANOVA DATA=analysis_data;
	CLASS Age_Range;
	MODEL BMI = Age_Range;
	MEANS Age_Range / tukey;
RUN;

