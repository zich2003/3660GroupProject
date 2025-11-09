LIBNAME lib "/home/u64324048/Group_Project/Code/CommonFactors/lib";

DATA behavior_data;
	SET lib.behavior_data;
	
	Smoking_Numeric = INPUT(Smoking, 18.);
	Alco_Numeric = INPUT(alco, 18.);
	Cardio_Numeric = INPUT(cardio, 18.);
	GENDER_Numeric = INPUT(gender, 18.);
	
	DROP 
		Smoking 
		alco
		cardio
		gender
		;
		
	RENAME 
		Smoking_Numeric = Smoking
		Alco_Numeric = AlchoDrinking
		Cardio_Numeric = HasCardioDisease
		GENDER_Numeric = GENDER
		;
RUN;

DATA cardio_data;
	SET lib.cardio ;
	
	Smoking_Numeric = INPUT(smoking, 18.);
	Alco_Numeric = INPUT(alco, 18.);
	Cardio_Numeric = INPUT(cardio, 18.);
	GENDER_Numeric = INPUT(gender, 18.);
	HBP_Numeric = INPUT(high_blood_pressure, 18.);
	
	DROP 
		smoking
		alco
		cardio
		gender
		high_blood_pressure
		;
		
	RENAME 
	
		Smoking_Numeric = Smoking
		Alco_Numeric = AlchoDrinking
		Cardio_Numeric = HasCardioDisease
		GENDER_Numeric = GENDER
		HBP_Numeric = HBP
		;
RUN;

DATA health_data;
	SET lib.healthstatus;
	
	Smoking_Numeric = INPUT(Smoking, 18.);
	Alco_Numeric = INPUT(alco, 18.);
	Cardio_Numeric = INPUT(cardio, 18.);
	GENDER_Numeric = INPUT(gender, 18.);
	HBP_Numeric = INPUT(high_blood_pressure, 18.);
	
	DROP 
		Smoking 
		alco
		cardio
		gender
		high_blood_pressure
		;
		
	RENAME 
		Smoking_Numeric = Smoking
		Alco_Numeric = AlchoDrinking
		Cardio_Numeric = HasCardioDisease
		GENDER_Numeric = GENDER
		HBP_Numeric = HBP
		;
RUN;

DATA combined_cardio_data;
	SET 
		cardio_data  (DROP=Smoking GENDER AlchoDrinking active) 
		health_data  (DROP=Smoking GENDER AlchoDrinking SleepTime)
	;
RUN;

DATA combinded_behavior_cardio;
	SET 
		cardio_data  (DROP=active HBP AlchoDrinking) 
		behavior_data  (DROP=SleepTime AlchoDrinking)
	;
RUN;

DATA lib.all;
	SET 
		behavior_data(DROP=SleepTime AlchoDrinking)
		cardio_data  (DROP=active HBP AlchoDrinking HBP)
		health_data  (DROP=SleepTime AlchoDrinking HBP)
		;
RUN;

DATA lib.CardioHealth;
	SET combined_cardio_data;
RUN;

DATA lib.CardioBehavior;
	SET combinded_behavior_cardio;
RUN;

PROC PRINT DATA=lib.CardioBehavior;
RUN;