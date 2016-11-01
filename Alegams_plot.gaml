/**
* Name: Alegams_plot
* Author: Ligte002
* Description: 
* Tags: Tag1, Tag2, TagN
*/
model Alegams_plot

import "./Alegams_globals.gaml"
//import "./Alegams_base_0.1.gaml"
species plot
{
	int plot_Id;
	//int forest;
	//int agrArea;
	float area_INT;
	float area_IE;
	float area_IMS;
	float tot_Area;
	string LU_office;
	string LU_cad;
	int LU_local;
	int LU_model;	
	int production_System update: self color_plots [];
	rgb color <- # gray;
	int shrimp_Type;
	float yield_INT_mono;
	float yield_INT_vana;
	float yield_IE;
	float yield_IMS;
	init
	{
		//do determine_initial_land_use;
		//do determine_prod_system;
		do determine_area_production_system;
		do color_plots;
	}



	
	action determine_area_production_system{
		switch LU_model{
			match 1{
				if tot_Area < 3 {
					set area_INT <- rnd(min_INT_size,max_INT_size);
				}
				else{
					area_INT <- tot_Area * 0.7;
				}
				if flip(0.5){
					set shrimp_Type <- 1;
				}else{
					set shrimp_Type <- 2;
				}
				set production_System <- INT;
				
			}
			match 2{
				if tot_Area < 3 {
					set area_IE <- rnd(min_IE_size,max_IE_size);
				}
				else{
					area_IE <- tot_Area * 0.7;
				}
				set production_System <- IE;
				
			}
			match 3{
				set area_IMS <- tot_Area;
				set production_System <- IMS;
				
			}
			match 4 {
				set area_INT <- rnd(min_INT_size,max_INT_size);
				set area_IE <- rnd(min_IE_size,max_IE_size);
				if area_INT > area_IE{
					set area_INT <- area_IE;
				}
				
				if (area_INT + area_IE) > tot_Area * 0.7{
					let d_area <- (area_INT + area_IE) - ((tot_Area * 0.7)/2);
					set area_INT <-  area_INT - d_area;
					set area_IE <- area_IE - d_area;
				}
				set shrimp_Type <- rnd(1, 2);
				set production_System <- INT_IE;
			}
			match 5 {
				set area_INT <- rnd(min_INT_size,max_INT_size);
				if area_INT > 1 {
					area_INT <- 1.0;
				}
				if (area_INT) < tot_Area * 0.5 {
					set area_IMS <- tot_Area - area_INT;
				}else{
					set area_INT <- tot_Area/2;
					set area_IMS <- tot_Area - area_INT;
				}
				set shrimp_Type <- rnd(1, 2);
				set production_System <- INT_IMS;
			}
			match 6 {
				set area_IE <- rnd(min_IE_size,max_IE_size);
				if (area_IE * 2) < tot_Area{
					set area_IE <- tot_Area - area_IE;
				}else{
					set area_IE <- tot_Area * 0.5;
					set area_IE <- tot_Area - area_IE;
				}
				set production_System <- IE_IMS;
			}
			default{
				set production_System <- 999;
			}

			
						
		}
			set production_System <- LU_model;		

	}


	//this action determines the name of the production system 
	action determine_prod_system
	{
		int INT_true <- 0;
		int IE_true <- 0;
		int IMS_true <- 0;
		int type_string <- 0;
		if area_INT > 0
		{
			set INT_true <- 1;
		}

		if area_IE > 0
		{
			set IE_true <- 10;
		}

		if area_IMS > 0
		{
			set IMS_true <- 100;
		}

		type_string <- INT_true + IE_true + IMS_true;
		switch type_string
		{
			match 1
			{
				set production_System <- INT;
			}

			match 10
			{
				set production_System <- IE;
			}

			match 100
			{
				set production_System <- IMS;
			}

			match 11
			{
				set production_System <- INT_IE;
			}

			match 101
			{
				set production_System <- INT_IMS;
			}

			match 110
			{
				set production_System <- IE_IMS;
			}

			default
			{
				set production_System <- unKnown;
			}

		}

	} //end determine_prod_system


	//Calculates the cost of growing crop based on areas of different production systems on one plot


	//color the plot
	action color_plots
	{
		switch production_System
		{
			match INT
			{
				color <- # red;
			}

			match IE
			{
				color <- # yellow;
			}

			match IMS
			{
				color <- # green;
			}

			match INT_IE
			{
				color <- # sienna;
			}

			match INT_IMS
			{
				color <- # darkseagreen;
			}

			match IE_IMS
			{
				color <- # mediumaquamarine;
			}

		}

	} //end color_plots
	aspect base
	{
		draw shape color: color border: true;
	}

}			


