LIBNAME lib "/home/u64324048/Group_Project/git/Code/heart_disease_behaviour/lib";
ODS POWERPOINT FILE = '/home/u64324048/Group_Project/git/Code/heart_disease_behaviour/visualize(hdb).pptx';
ODS GRAPHICS / WIDTH=20cm HEIGHT=20cm;

PROC FORMAT;
	VALUE GenderLabel
		0 = "Male"
		1 = "Female"
	;
RUN;

PROC FORMAT;
	VALUE SmokingStatus
		0 = "Non-Smoker"
		1 = "Smoker"
	;
RUN;

DATA visualize_data;
	SET lib.estimate_data;
RUN;

DATA labelled_data;
	SET lib.labelling_data;
RUN;

PROC SGPLOT DATA=labelling_data;
	SCATTER 
		X = Age
		Y = BMI
		/ GROUP=cardio
			markerattrs=(
			symbol=CircleFilled
            size=8
           );
RUN;

PROC SGPLOT DATA=visualize_data;
	HBAR Attribute / 
		RESPONSE = OR
		GROUPDISPLAY=cluster
	;
	
	REFLINE 1.0 / 
		AXIS=X
		LINEATTRS=(COLOR = GREEN THICKNESS = 2 PATTERN = dash)
	;
	
	XAXIS LABEL="Odds Ratio";
	YAXIS LABEL="Key Factors";
RUN;



PROC SGPLOT DATA=labelled_data;
	VBAR Gender / 
		GROUP=Smoking
		STAT=FREQ
		GROUPDISPLAY=cluster
	;
	
	YAXIS LABEL="Count";
	XAXIS DISCRETEORDER=DATA;
	;
	
	TITLE 'Smoking rates between genders';
	
	FORMAT 
		Gender GenderLabel.
		Smoking SmokingStatus.
	;
RUN;

