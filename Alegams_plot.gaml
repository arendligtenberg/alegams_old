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
	string LU_Code;
	string land_Use;
	int specie;
	int production_System update: self color_plots [];
	rgb color <- # gray;
	int shrimp_Type;
	float yield_INT_mono;
	float yield_INT_vana;
	float yield_IE;
	float yield_IMS;
	init
	{
		do seed_initial_distribution_of_production_system;
		do determine_prod_system;
		do color_plots;
	}

	//Currently a very simple rule to create an initial distribution of production systems, need to be elaborated
	action seed_initial_distribution_of_production_system
	{
		if land_Use = "Protection forest"
		{
			set area_IMS <- tot_Area;
		}

		if land_Use = "Production forest"
		{
			if flip(Prob_INT_IMS)
			{
				set area_INT <- INT_size;
				set area_IMS <- tot_Area - area_INT;
				if area_IMS < 0
				{
					set area_IMS <- 0.0;
				}

			} else if flip(Prob_IE_IMS)
			{
				set area_IE <- IE_size;
				set area_IMS <- tot_Area - area_IE;
				set shrimp_Type <- rnd(1, 2);
			} else
			{
				set area_IMS <- tot_Area;
			}

		}

		if land_Use = "Shrimp"
		{
			if flip(Prob_INT_IE)
			{
				set area_INT <- INT_size;
				set area_IE <- tot_Area - area_INT;
				set shrimp_Type <- rnd(1, 2);
			} else if flip(Prob_IE)
			{
				set area_IE <- tot_Area;
			} else
			{
				set area_INT <- tot_Area; //todo: need to set max size for pure intensive farms.
				set shrimp_Type <- rnd(1, 2);
			}

		}

	} //end seed_initial_distribution_of_production_system

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


