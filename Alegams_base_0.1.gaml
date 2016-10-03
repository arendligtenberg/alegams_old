/**
* 
* Author: Arend, Hiêp
* Description: first version of update ABM for the Alegams project
* To be presented during the Vietnam workshop second half oktober 2016
* August 2016
* TBD 
* adding initialisation routine - only after proper dataset
* adding decision making behaviour according flow diagram
*/



model Alegams_base


/* Insert your model definition here */

//default shapefile with plots



import "./Alegams_globals.gaml"

global{
	
	geometry shape <- envelope(plot_file);

	init{
	// create plot though GIS file
		create plot from: plot_file with: 	
		[
			plot_id::int(read("OBJECTID")),
			lU_Code::string(read("Lu_Code")),
			forest::int(read("Forest2014")),
			agrArea::int(read("AgrArea201")),
			land_Use::string(read("LU_ModelDe")),
			tot_Area::float(read("Shape_Area"))		
		]{		}

	//create a farm on each plot with a shrimp farm
		ask plot{
			if self.production_System != 999{
					write " creating farmer";
					create farm number:1 {
						set farmPlot <- myself;
						set name <- "Schrimpfarmer_"+farmPlot.plot_Id;
						set farmPlot.name <- "plot of: "+name;
						location <- any_location_in(farmPlot);
					}		
				}
		}

	}//end init
}//end global section


//Species section
species plot{
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
		rgb color <- #gray;
		
		
		init{

			do seed_initial_distribution_of_production_system;
			do determine_prod_system;
			do color_plots;
		}
		
		
		//Currently a very simple rule to create an initial distribution of production systems, need to be elaborated
		action seed_initial_distribution_of_production_system{
			if land_Use = "Protection forest"{
					set area_IMS <- tot_Area;	
			}
			if land_Use = "Production forest"{
				if flip (Prob_INT_IMS) {
					set area_INT <- INT_size;
					set area_IMS <- tot_Area - area_INT;
				}
				else if flip (Prob_IE_IMS) {
					set area_IE <- INT_size;
					set area_IMS <- tot_Area - area_IE;	
				}
				else{
					set area_IMS <- tot_Area;
				}	
			}
			if land_Use = "Shrimp"{
					if flip (Prob_INT_IE){
						set area_INT <- INT_size;
						set area_IE <- tot_Area - area_INT;
					}
					else if flip (Prob_IE){
						set area_IE <- tot_Area;
					}
					else{
						set area_INT <- tot_Area;
					}	
			}
		} //end seed_initial_distribution_of_production_system
		
		//this action determines the name of the production system 
		action determine_prod_system{
			int INT_true <- 0;
			int IE_true <- 0; 
			int IMS_true <- 0;
			int type_string <- 0;
			
			if area_INT > 0 {set INT_true <- 1;}
			if area_IE > 0 {set IE_true <- 10;}
			if area_IMS > 0 {set IMS_true <- 100;}
			
			type_string <- INT_true + IE_true + IMS_true;
			
			switch type_string{
				match 1 {set production_System <- INT;}
				match 10 {set production_System <- IE;}
				match 100 {set production_System <- IMS;}
				match 11 {set production_System <- INT_IE;}
				match 101 {set production_System <- INT_IMS;}
				match 110 {set production_System <- IE_IMS;}	
				default{set production_System <- unKnown;}							
			}
			
		}//end determine_prod_system
		
		
		//color the plot
		action color_plots{
			switch production_System{
				match INT {color <- #red;}
				match IE {color <- #yellow;}
				match IMS {color <- #green;}
				match INT_IE {color <- #sienna;}
				match INT_IMS {color <-#darkseagreen;}
				match IE_IMS {color <- #mediumaquamarine;}				
			}
		}//end color_plots
		
		
		aspect base {
		    draw shape color: color border: true ;		
		}
}			

species farm{
		//declaration of the farm characteristics
		plot farmPlot;
		int plotId;
		int nr_Plots;
		int hh_Size;
		int hh_bank_account;
		int bank_Loan;
		int extra_Loan;
		int max_Loan;
		int age;
		float interest_Bank;
		float interest_Commercial;
		int nr_Labour;
		int prob_Shift;

		init{
			
			set hh_bank_account <- 100;
		}
		
		
		
		
		
	aspect default {
				draw square(25) color: rgb('white');
		}
}//farm






	
//experiment section 
		
experiment farms type: gui {
	parameter "Plot file" var: plot_file category: "GIS" ;

	output{
		display map_display {
			species plot aspect: base;
			species farm aspect: default;
		}
	}
}	


