LIBNAME lib "/home/u64324048/Group_Project/git/Code/Dataset-A/lib";
LIBNAME common "/home/u64324048/Group_Project/git/Code/CommonFactors/lib";

DATA orginal_data;
	SET lib.rm_outliers_data;
RUN;

PROC FORMAT;
    VALUE bmifmtConvert
        low - 18.5 = 1       
        18.5-24 = 2       
        24-28 = 3      
        28-HIGH = 4
    ;
    
   	VALUE bmifmt
        1 = 'OVER-THIN'       
        2 = 'NORMAL'
        3 = 'OVER-FAT'      
        4 = 'OBESITY'
    ;
    
    VALUE dayfmt
       0 = "0 days"
       1-7 = '1-7 days'
       8-14 = '8-14 days'
       15-21 = '15-21 days'
       22-28 = '22-28 days'
       28 - high = '>28 days'
    ;
    
    
     VALUE agefmt
        1 = "<= 40"        
        2 = "41-45"       
        3 = "46-50"      
        4 = "51-55"        
        5 = "56-60"      
        6 = "61-65"         
        7 = "66-70"       
        8 = "71-75"   
        9 = "76-80"        
        10 = ">= 80"  
    ;
    
RUN;


DATA labelling;
	SET orginal_data;
    	   
	BMI_Class = PUT(BMI, bmifmtConvert.);
	BMI_Class_Num = INPUT(BMI_Class,3.);
	DROP BMI_Class;
	RENAME BMI_Class_Num = BMI_Class;
		
    FORMAT 
    	Age_Range agefmt. 
    	MentalHealth dayfmt.
    	PhysicalHealth dayfmt.
    ; 
RUN;

DATA common.DatasetA;
	SET labelling (KEEP = 
		BMI 
		AlcoholDrinking 
		GENDER 
		Age_Range 
		MentalHealth 
		HavingCVD 
		BMI_Class 
		SmokingStatus 
		Diabetes 
		Skin_Cancer
		Exercise
	);
	FORMAT BMI_Class bmifmt.;
RUN;

DATA lib.labelling_data;
	SET labelling;
	FORMAT BMI_Class bmifmt.;
RUN;

PROC PRINT DATA=common.DatasetA;
RUN;

