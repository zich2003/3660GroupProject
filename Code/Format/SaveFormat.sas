PROC FORMAT;
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
    
   	VALUE bool
		0 = "No"
		1 = "Yes"
	;
	
    
    VALUE Gender
    	0 = 'Male'
    	1 = 'Female'
    ;

	VALUE level
		1 = "Normal"
		2 = "Above Normal"
		3 = "Well Above Normal"
	;
    


	VALUE bool
		0 = 'No'
		1 = 'Yes'
	;
	

RUN;


