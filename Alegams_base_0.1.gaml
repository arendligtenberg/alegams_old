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
import "./Alegams_farm.gaml"
import "./Alegams_plot.gaml"

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
			tot_Area::(float(read("Shape_Area")))/10000		
		]{		}

	//create a farm on each plot with a shrimp farm
		ask plot{
			
			if self.production_System != 999{
					write "Creating farmer";
					create farm number:1 {
						set farmPlot <- myself;
						set name <- "Schrimpfarmer_"+farmPlot.plot_Id;
						set farmPlot.name <- "plot of: "+name;
						location <- any_location_in(farmPlot);
					}		
				}
		}

	//a number of initialisation staps for the farm. Need to be done here since the routine for creating agents has been changed in 1.7
	//can't be done in the init routine of the agent zelf;
//	ask farm{
//			write "Executing init for Farm";
//						
//
//	}

	}//end init
	

	
	
} //end global section


//Species section


	
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


