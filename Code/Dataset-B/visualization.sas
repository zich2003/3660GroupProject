LIBNAME lib "/home/u64324048/Group_Project/git/Code/cardio_disease_analysis/lib";
ODS POWERPOINT FILE = '/home/u64324048/Group_Project/git/Code/cardio_disease_analysis/visualize.pptx';
ODS GRAPHICS / WIDTH=19cm HEIGHT=19cm;

PROC FORMAT;
	VALUE cvdNumeric
	1 = "Having CVD"
	0 = "Not Having CVD"
	;
RUN;

DATA visualize_data;
	SET lib.labelling_data;
RUN;

DATA outlier_data;
	SET lib.process_data;
	FORMAT HavingCVD cvdNumeric.;
RUN;

DATA rm_outlier_data;
	SET lib.rm_outlier;
	FORMAT HavingCVD cvdNumeric.;
RUN;

PROC SGPLOT DATA=VISUALIZE_DATA;
	VBAR Cholesterol;
RUN;

PROC SGPLOT DATA=visualize_data;
	SCATTER
		X = BMI
		Y = SBP
		/ GROUP=HavingCVD
		markerattrs=(
            symbol=CircleFilled  
            size=7                   
        );
		;
	
	XAXIS 
		MIN=10
		MAX=50
	;
	
	YAXIS
		MIN=100
		MAX=225
	;
	
	
	keylegend / location=inside position=topright;
	
	TITLE "CVD status with SBP";
RUN;

PROC SGPLOT DATA=visualize_data;
	SCATTER
		X = BMI
		Y = dBP
		/ GROUP=HavingCVD
		markerattrs=(
            symbol=CircleFilled  
            size=7                   
        );
		;
	
	XAXIS 
		MIN=10
		MAX=50
	;
	
	YAXIS
		MIN=40
		MAX=140
	;
	
	
	keylegend / location=inside position=topright;
	
	TITLE "CVD status with DBP";
RUN;


PROC SGPLOT DATA=visualize_data;
	SCATTER
		X = Age
		Y = BMI
		/ GROUP=HavingCardioDisease
		markerattrs=(
            symbol=CircleFilled  
            size=3                  
        );
		;
	
	
	keylegend / location=inside position=topright;
	
	TITLE "CVD status with BMI and Age";
RUN;

PROC UNIVARIATE DATA=visualize_data;
	VAR BMI;
RUN;

PROC SGPLOT DATA=outlier_data;
	HBOX BMI  / EXTREME CATEGORY= cardio;
	XAXIS MIN = 1 MAX =  200;
	YAXIS LABEL="CVD Status";
	TITLE "BMI Distribution before removing outliers";
RUN;

PROC SGPLOT DATA=rm_outlier_data;
	HBOX BMI / EXTREME CATEGORY= cardio;
	XAXIS MIN = 1 MAX =  200;
	YAXIS LABEL="CVD Status";
	TITLE "BMI Distribution after removing outliers";
RUN;


PROC SGPLOT DATA=outlier_data;
	HBOX ap_hi / EXTREME CATEGORY= cardio;
	XAXIS MIN = 1 MAX =  1700;
	
	YAXIS LABEL="CVD Status";
	TITLE "SBP Distribution before removing outliers";
RUN;

PROC SGPLOT DATA=rm_outlier_data;
	HBOX ap_hi / EXTREME CATEGORY= cardio;
	XAXIS MIN = 1 MAX =  250;
	TITLE "SBP Distribution after removing outliers";
RUN;

DATA Notice;
	INFILE DATALINES;
	INPUT range $15. standards $10.;
	DATALINES;
	Less or equal to 18.5 OVER-THIN
	> 18.5 and <= 24 Normal
	> 24 and <= 28 OVER-FAT
	25 or higher OBESITY
	;
	
	TITLE 'BMI Standard';
RUN;

DATA Notice_BMI;
    INFILE DATALINES DLM=','; /* 指定逗号为分隔符 */
    LENGTH 
    	range $30. 
    	standards $15.
    ;
    
    INPUT 
    	range $ 
    	standards $
    ;
    
	DATALINES;
	Less or equal to 18.5, OVER-THIN
	> 18.5 and <= 24, NORMAL
	> 24 and <= 28, OVER-FAT
	> 28, OBESITY
	;

	TITLE 'BMI Standard';
RUN;

DATA Notice_HBP;
    INFILE DATALINES DLM=',';
    LENGTH 
    	range $30. 
    	standards $30.
    ;
    
    INPUT 
    	range $ 
    	standards $
    ;
    
	DATALINES;
	Less or equal to 18.5, OVER-THIN
	> 18.5 and <= 24, NORMAL
	> 24 and <= 28, OVER-FAT
	> 28, OBESITY
	;

	TITLE 'BMI Standard';
RUN;

PROC PRINT DATA=Notice;
RUN;

