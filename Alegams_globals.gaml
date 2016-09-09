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
 	
 	//basic pond size
 	float INT_size <- 5000;
 	float IE_size <- 10000;
 	
 	//Risk for disease for the differen production systems
 	float farmPlotFailureRate_IE <- 0.1;
 	float farmPlotFailureRate_INT <- 0.2;
 	float farmPlotFailureRate_IMS <- 0.05;
 		
 	//Times to harvest
 	int time_Harvest_INT_mono <- 4;
	int time_Harvest_INT_vana <- 3;
	int time_Harvest_IE <- 6;
	int time_Harvest_IMS <- 1; //continuous harvesting
 		
 	
 		
 	file plot_file <- file ('../includes/LongVinhCadCorrect.shp');
 	}

