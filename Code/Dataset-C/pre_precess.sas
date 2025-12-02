LIBNAME lib "/home/u64324048/Group_Project/git/Code/Dataset-C/lib";

DATA original_data;
	SET lib.health_statistic;
	
	RENAME 
        'Blood Pressure'n = Blood_Pressure
        'Cholesterol Level'n = Cholesterol_Level
        'Exercise Habits'n = active
        'Family Heart Disease'n = Family_Disease
        'High Blood Pressure'n = High_Blood_Pressure
        'Low HDL Cholesterol'n = Low_HDL_Cholesterol
        'High LDL Cholesterol'n = High_LDL_Cholesterol
        'Alcohol Consumption'n = alco
        'Stress Level'n = Stress_Level
        'Sleep Hours'n = SleepTime
        'Sugar Consumption'n = Sugar_Consumption
        'Triglyceride Level'n = Triglyceride_Level
        'Fasting Blood Sugar'n = Fasting_Blood_Sugar
        'CRP Level'n = CRP_Level
        'Homocysteine Level'n = Homocysteine_Level
        'Heart Disease Status'n = cardio
    ;
RUN;

DATA renamed_data;
	SET original_data (DROP=
		Cholesterol_Level
		Triglyceride_Level
		Fasting_Blood_Sugar
		CRP_Level
		Homocysteine_Level
	);
RUN;

DATA convert_data;
	SET renamed_data;
	
	ARRAY Binary_Data(7) 
		Gender 
		Smoking 
		Family_Disease 
		Diabetes 
		Low_HDL_Cholesterol 
		High_LDL_Cholesterol 
		cardio
	;
	
	ARRAY MultiVar_Data(4) 
		active
		alco
		Stress_Level 
		Sugar_Consumption
	;
	
    DO i = 1 TO 7;
        IF Binary_Data(i) = "Yes" OR Binary_Data(i) = "Female" THEN Binary_Data(i) = 1;
        ELSE IF Binary_Data(i) = "No" OR Binary_Data(i) = "Male" THEN Binary_Data(i) = 0;
        ELSE Binary_Data(i) = .;
    END;
    
    /* 多分类变量：字符转数值，处理缺失值 */
    DO i = 1 TO 4;
        IF MultiVar_Data(i) = "High" THEN MultiVar_Data(i) = 3;
        ELSE IF MultiVar_Data(i) = "Medium" THEN MultiVar_Data(i) = 2;
        ELSE IF MultiVar_Data(i) = "Low" THEN MultiVar_Data(i) = 1;
        ELSE MultiVar_Data(i) = .;
    END;
RUN;
	

DATA lib.health_statistic;
	SET convert_data;
RUN;

PROC PRINT DATA=lib.health_statistic;
RUN;

