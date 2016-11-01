/**
* Name: alagamsglobals
* Author: ligte002
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model Alegamsglobals
 global{
	// gobal vars	
 	
 	//coding of production systems
 	int INT <- 1;
 	int IE <- 2;
 	int IMS <- 3;
 	int INT_IE <- 4;
 	int INT_IMS <- 5;
 	int IE_IMS <- 6;
 	int unKnown <- 999;
 	
 	//init probabilities for initial production systems
 	float Prob_INT <- 0.5;
 	float Prob_IE <- 0.5;
 	float Prob_IMS <- 0.1;
 	float Prob_INT_IE <- 0.1;
 	float Prob_INT_IMS <- 0.3;
 	float Prob_IE_IMS <- 0.1;
 	
 	//max number of Cycles:
 	int max_cycle_INT_mono <- 2;
 	int max_cycle_INT_vana <- 3;
	int max_cycle_IE <- 3;
	int max_cycle_IMS <- 999;
	
 	//Times to harvest
 	int time_Harvest_INT_mono <- 4 parameter: "time to harvest intensive Monodon (months)" category: "Crop" ;
	int time_Harvest_INT_vana <- 3 parameter: "time to harvest intensive Vannamei (months)" category: "Crop" ;
	int time_Harvest_IE <- 6 parameter: "time to harvest intensive improved extensive (months)" category: "Crop" ;
	int time_Harvest_IMS <- 2 parameter: "time to harvest integrated mangrove (months)" category: "Crop" ;
	
	//In case of disease can harvest after:
 	int time_Harvest_fail_INT_mono <- 2 parameter: "min. req. period toharvest intensive Monodon (months)" category: "Crop" ;
	int time_Harvest_fail_INT_vana <- 1 parameter: "min. req. period toharvest intensive Vannamei (months)" category: "Crop" ;
	int time_Harvest_fail_IE <- 1 parameter: "min. req. period toharvest improved extensive (months)" category: "Crop" ;
	int time_Harvest_fail_IMS <- 1 parameter: "min. req. period toharvest integrated mangrove (months)" category: "Crop" ;

 	
 	//Risk for disease for the different production systems (per month)
 	//float farmPlotFailureRate_IE <- 0.58.;
 	//float farmPlotFailureRate_INT <- 0.56.;
 	//float farmPlotFailureRate_IMS <- 0.47.;

 	float farmPlotFailureRate_INT <- 0.2 parameter: "chance of disease for intensive" category: "Crop" ; //0.2;
 	float farmPlotFailureRate_IE <- 0.12 parameter: "chance of disease for improved extensive" category: "Crop" ; //0.12;
 	float farmPlotFailureRate_IMS <- 0.1 parameter: "chance of disease for integrated mangrove" category: "Crop" ; //0.1;

 	
 	//cost to seed new shrimp (mVnd/ha)
 	float shrimp_init_INT_mono <- 250.00 parameter: "cost to seed new intensive Monondon(mVnd/ha)" category: "Crop" ;
 	float shrimp_init_INT_vana <- 250.00 parameter: "cost to seed new intensive Vannamei(mVnd/ha)" category: "Crop" ;
 	float shrimp_init_IE <- 75.00 parameter: "cost to seed new improved extensive(mVnd/ha)" category: "Crop" ;
 	float shrimp_init_IMS <- 76.00 parameter: "cost to seed new integrated mangrove(mVnd/ha)" category: "Crop" ; 	 
 	
 	
 	
	//crop yields  (kg/ha/cycle) 
	int crop_yield_INT_mono <- 5814 parameter: "crop yields intensive Monodon (kg/ha/cycle)" category: "Crop" ;
	int crop_yield_INT_vana <- 8897	parameter: "crop yields intensive Vannamei (kg/ha/cycle)" category: "Crop" ;	
	int crop_yield_IE <- 568 parameter: "crop yields improved extensive (kg/ha/cycle)" category: "Crop" ;	
	int crop_yield_IMS <- 308 parameter: "crop yields integrated mangrove (kg/ha/cycle)" category: "Crop" ;	

	
	//crop yields in case of failure (kg/ha/cycle) 
	int crop_yield_fail_INT_mono <- 1431 parameter: "crop yields if disease intensive Monodon (kg/ha/cycle)" category: "Crop" ;
	int crop_yield_fail_INT_vana <- 2853 parameter: "crop yields if disease intensive Vannamei (kg/ha/cycle)" category: "Crop" ;	 		
	int crop_yield_fail_IE <- 134 parameter: "crop yields if disease improved extensive (kg/ha/cycle)" category: "Crop" ;	
	int crop_yield_fail_IMS <- 87 parameter: "crop yields if disease integrated mangrove (kg/ha/cycle)" category: "Crop" ;			
 
 
 
	//household related
	
	float avg_income <- 150.0;

	// houshold expenses (Mvdn/person/month	
	//float HH_expense_INT_mono <- 2.1;
	//float HH_expense_INT_vana <- 3.1;
	//float HH_expense_IE <- 1.6;
	//float HH_expense_IMS <- 2.1;
	float HH_expenses_avg <- 2.5 parameter: "average household expenses (mVnd/pp/month)" category: "Farm" ;
	
	// average loan (Mvnd/ha/year (stdev are estimated
	//float HH_loan_avg_IE <- 116.00;
	//float HH_loan_std_IE <- 35.00;
	//float HH_loan_avg_INT <- 152.00;
	//float HH_loan_std_INT <- 50.00;
	//float HH_loan_avg_IMS <- 91.00;
	//float HH_loan_std_IMS <- 30.00;
	
 	//basic pond size
 	float min_INT_size <- 0.1 parameter: "min size of intensive ponds (ha.)" category: "Farm" ;
	float max_INT_size <- 1.5 parameter: "max size of intensive ponds (ha.)" category: "Farm" ; 	
 	float min_IE_size <- 0.5 parameter: "min size of improved extensive ponds)" category: "Farm" ;
    float max_IE_size <- 2.0 parameter: "max size of improved extensive ponds)" category: "Farm"; 
	
	float HH_2ndincome_avg_INT_mono <-229.00/12 parameter: "average sec. income intensive Monodon(mVnd/month)" category: "Farm" ;
	float HH_2ndincome_stddev_INT_mono <- 50.00/12;
	float HH_2ndincome_avg_INT_vana <- 131.00/12 parameter: "average sec. income intensive Vannamei (mVnd/month)" category: "Farm" ;
	float HH_2ndincome_stddev_INT_vana <- 50.00/12;
	float HH_2ndincome_avg_IE <- 50.00/12 parameter: "average sec. income improved extensive (mVnd/month)" category: "Farm" ;
	float HH_2ndincome_stddev_IE <- 15.00/12; 
	float HH_2ndincome_avg_IMS <- 31.00/12 parameter: "average sec. income integrated mangrove (mVnd/month)" category: "Farm" ;
	float HH_2ndincome_stddev_IMS <- 10.00/12 ;
				
	//crop costs (Mvnd/ha/month
	float cropcost_avg_INT_mono <- 122.0 parameter: "crop costs intensive Monodon (mVnd/ha/month)" category: "Crop" ;
	float cropcost_stddev_INT_mono <- 0.0;
	float cropcost_avg_INT_vana <- 218.0 parameter: "crop costs intensive Vanamei (mVnd/ha/month)" category: "Crop" ;
	float cropcost_stddev_INT_vana <- 0.0;	
	float cropcost_avg_IE <- 17.00 parameter: "crop costs improved extensive (mVnd/ha/month)" category: "Crop" ;
	float cropcost_stddev_IE <- 0.0;	
	float cropcost_avg_IMS <- 3.0 parameter: "crop costs integrated mangrove (mVnd/ha/month)" category: "Crop" ;
	float cropcost_stddev_IMS <- 0.0;
	
	// post larvae (pl/m2) **need costs per ha
	int PL_avg_IE <- 8; 
	int PL_avg_INT_mono <- 25; 
	int PL_avg_INT_vana <- 72; 
	int PL_avg_IMS <- 3;
	
	//shrimp prices Mvnc/kg
	float shrimp_price_INT_mono <- 0.25 parameter: "shrimp price intensive Monodon (mVnd/kg)" category: "Market" ;
	float shrimp_price_INT_vana <- 0.12 parameter: "shrimp price intensive Vannamei (mVnd/kg)" category: "Market" ;
	float shrimp_price_IE <- 0.25 parameter: "shrimp price improved extensive (mVnd/kg)" category: "Market" ;
	float shrimp_price_IMS <- 0.25 parameter: "shrimp price integrated mangrove (mVnd/kg)" category: "Market" ;
	
	
 	file plot_file <- file ('../includes/LongVinhProvinceCorrectFinal2.shp');
 	}

