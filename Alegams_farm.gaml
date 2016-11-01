/**
* Name: Alemans_farm
* Author: Ligte002
* Description: 
* Tags: Tag1, Tag2, TagN
*/
model Alemans_farm

import "./Alegams_globals.gaml"
import "./Alegams_base.gaml"
species farm
{
//declaration of the farm characteristics
	plot farmPlot;
	int plotId;
	int nr_Plots;
	int hh_Size;
	float bank_Account;
	float second_Income;
	float bank_Loan;
	int extra_Loan;
	float max_Loan;
	int age; //years
	float interest_Bank;
	float interest_Commercial;
	int nr_Labour;
	int prob_Shift;
	int time; //month
	int grow_Time_INT; //month
	int grow_Time_IE; //month
	int grow_Time_IMS; //month
	int cycle_INT;
	int cycle_IE;
	int cycle_IMS;
	bool disease_INT;
	bool disease_IE;
	bool disease_IMS;
	float crop_cost;
	float income_from_INT_mono;
	float income_from_INT_vana;
	float income_from_IE;
	float income_from_IMS;
	float second_income;
	init
	{
		set hh_Size <- rnd(1, 5);
		set age <- rnd(22, 70);
		set time <- 1;
		set grow_Time_INT <- rnd(0, time_Harvest_INT_mono);
		set grow_Time_IE <- rnd(0, time_Harvest_IE);
		set grow_Time_IMS <- rnd(0, time_Harvest_IMS);
		set cycle_INT <- rnd(0, max_cycle_INT_mono);
		set cycle_INT <- rnd(0, max_cycle_INT_vana);		
		set cycle_IE <- rnd(0, max_cycle_IE);
		set cycle_IMS <- rnd(0, max_cycle_IMS);				
		set max_Loan <- rnd(25.0, 50.0);
		set bank_Account <- rnd((-1 * max_Loan), (avg_income));
		
	}

	reflex grow_Shrimp
	{
	//reset disease indicators
		set disease_INT <- false;
		set disease_IE <- false;
		set disease_IMS <- false;

		//reset yield and income
		set farmPlot.yield_INT_mono <- 0.0;
		set farmPlot.yield_INT_vana <- 0.0;
		set farmPlot.yield_IE <- 0.0;
		set farmPlot.yield_IMS <- 0.0;
		set income_from_INT_mono <- 0.0;
		set income_from_INT_vana <- 0.0;
		set income_from_IE <- 0.0;
		set income_from_IMS <- 0.0;
		set second_income <- 0.0;
		
		if time = 12{
			set cycle_INT <- 0;
			set cycle_IE <- 0;
			set cycle_IMS <- 0;
			set time <- 0;
		}
		

		//reset crop costs
		set crop_cost <- 0.0;
		
		//start farming actions
		do check_for_disease;
		do check_for_harvest;
		do calc_second_income;
		do calc_crop_costs;
		do update_loan_and_bank;

		//update timers
		set time <- time + 1;
		set grow_Time_INT <- grow_Time_INT + 1;
		set grow_Time_IE <- grow_Time_IE + 1;
		set grow_Time_IMS <- grow_Time_IMS + 1;
	}

	reflex reset_Int_time when: farmPlot.area_INT = 0
	{
		set grow_Time_INT <- 0;
	}

	reflex reset_IE_time when: farmPlot.area_IE = 0
	{
		set grow_Time_IE <- 0;
	}

	reflex reset_IMS_time when: farmPlot.area_IMS = 0
	{
		set grow_Time_IMS <- 0;
	}

	action calc_crop_costs
	{
	//calculate cost of maintaining crop based on area of different farming systems
		float int_cost <- 0.0;
		float ie_cost <- 0.0;
		float ims_cost <- 0.0;
		if farmPlot.shrimp_Type = 1
		{
			int_cost <- gauss({ cropcost_avg_INT_mono, cropcost_stddev_INT_mono }) * farmPlot.area_INT;
		} else if farmPlot.shrimp_Type = 2
		{
			int_cost <- gauss({ cropcost_avg_INT_vana, cropcost_stddev_INT_vana }) * farmPlot.area_INT;
		}

		set ie_cost <- gauss({ cropcost_avg_IE, cropcost_stddev_IE }) * farmPlot.area_IE;
		set ims_cost <- gauss({ cropcost_avg_IMS, cropcost_stddev_IMS }) * farmPlot.area_IMS;

		// calculate total crop cost. If in this month new shrimps are seeded than the montly cost are added to the 
		// seed costs (which is the case when harvest has occured) 
		//if (farmPlot.shrimp_Type = 1) or (farmPlot.shrimp_Type = 2)
		//{
			//write "---" + crop_cost;
			set crop_cost <- crop_cost + int_cost + ie_cost + ims_cost;
			//write "int: " + int_cost;
			//write "ie: " + ie_cost;
			//write "ims: " + ims_cost;
			//write "cropcost: " + crop_cost;
			//write "=======================";
		//}

	}

//========
	action calc_second_income

	{
		float int_second <- 0.0;
		float ie_second <- 0.0;
		float ims_second <- 0.0;
		if farmPlot.area_INT > 0
		{
			if farmPlot.shrimp_Type = 1
			{
				int_second <- gauss({ HH_2ndincome_avg_INT_mono, HH_2ndincome_stddev_INT_mono }) * hh_Size;
			} else if farmPlot.shrimp_Type = 2
			{
				int_second <- gauss({ HH_2ndincome_avg_INT_vana, HH_2ndincome_stddev_INT_vana }) * hh_Size;
			}

		}

		if farmPlot.area_IE > 0
		{
			set ie_second <- gauss({ HH_2ndincome_avg_IE, HH_2ndincome_stddev_IE }) * hh_Size;
		}

		if farmPlot.area_IMS > 0
		{
			set ims_second <- gauss({ HH_2ndincome_avg_IMS, HH_2ndincome_stddev_IMS }) * hh_Size;
		}

		set second_Income <- int_second + ie_second + ims_second;
	}



//======
	action check_for_harvest
	{

	//check disease
	//write "checking disease";
	//set disease_INT <- diseaseINT();
	//set disease_IE <- diseaseIE();	
	//set disease_IMS <- diseaseIMS();
	//In case of disease
	//INT
		if farmPlot.area_INT > 0 and disease_INT
		{
			if (farmPlot.shrimp_Type = 1){
				if grow_Time_INT >= time_Harvest_fail_INT_mono and cycle_INT < max_cycle_INT_mono{
					set farmPlot.yield_INT_mono <- crop_yield_fail_INT_mono * farmPlot.area_INT;
					set income_from_INT_mono <-  farmPlot.yield_INT_mono * shrimp_price_INT_mono;
					set cycle_INT <- cycle_INT + 1;
					set grow_Time_INT <- 0;
				}

			} else if (farmPlot.shrimp_Type = 2){
				if grow_Time_INT >= time_Harvest_fail_INT_vana and cycle_INT < max_cycle_INT_vana{
					set farmPlot.yield_INT_vana <- crop_yield_fail_INT_vana * farmPlot.area_INT;
					income_from_INT_vana <- farmPlot.yield_INT_vana * shrimp_price_INT_vana;
					set cycle_INT <- cycle_INT + 1;
					set grow_Time_INT <- 0;
				}

			} else{
				set farmPlot.yield_INT_mono <- 0.0;
				set farmPlot.yield_INT_vana <- 0.0;
				set grow_Time_INT <- 0;
			}

		}

		//IE
		if farmPlot.area_IE > 0 and disease_IE
		{
			if grow_Time_IE >= time_Harvest_fail_IE and cycle_IE < max_cycle_IE{
				set farmPlot.yield_IE <- crop_yield_fail_IE * farmPlot.area_IE;
				set income_from_IE <- farmPlot.yield_IE * shrimp_price_IE;
				set grow_Time_IE <- 0;
				set cycle_IE <- cycle_IE + 1;
			} else{
				set farmPlot.yield_IE <- 0.0;	
				set grow_Time_IE <- 0;
			}

		}

		//IMS
		if farmPlot.area_IMS > 0 and disease_IMS{
			if grow_Time_IMS >= time_Harvest_fail_IMS{
				set grow_Time_IMS <- 0;
				set farmPlot.yield_IMS <- crop_yield_fail_IMS * farmPlot.area_IMS;
				set income_from_IMS <-  farmPlot.yield_INT_mono * shrimp_price_IMS;
			} else{
				set grow_Time_IMS <- 0;
				set farmPlot.yield_IMS <- 0.0;
			}

		}

		//in case of regular harvest

		//INT
		if farmPlot.area_INT > 0{
			if (farmPlot.shrimp_Type = 1){			
				if (grow_Time_INT >= time_Harvest_INT_mono) and (cycle_INT < max_cycle_INT_mono){
					//write "...harvesting from intensiver monodon";
					set farmPlot.yield_INT_mono <- crop_yield_INT_mono * farmPlot.area_INT;
					set income_from_INT_mono <- farmPlot.yield_INT_mono * shrimp_price_INT_mono;
					set cycle_INT <- cycle_INT + 1;
					set grow_Time_INT <- 0;
				}
			}
			
			if (farmPlot.shrimp_Type = 2){				
				if (grow_Time_INT >= time_Harvest_INT_vana) and (cycle_INT < max_cycle_INT_vana){
					//write "...harvesting from intensive vanamei";					
					set farmPlot.yield_INT_vana <- crop_yield_INT_vana * farmPlot.area_INT;
					set income_from_INT_vana <- farmPlot.yield_INT_vana * shrimp_price_INT_vana;
					set cycle_INT <- cycle_INT + 1;
					set grow_Time_INT <- 0;
				}  
			}
		}
		
		
		//IE
		if farmPlot.area_IE > 0	{
			if grow_Time_IE >= time_Harvest_IE and (cycle_IE < max_cycle_IE){
				//write "...harvesting from improved extensive";				
				set farmPlot.yield_IE <- crop_yield_IE * farmPlot.area_IE;
				set income_from_IE <- farmPlot.yield_IE * shrimp_price_IE;
				set cycle_INT <- cycle_IE + 1;
				set grow_Time_IE <- 0;
			}

		}

		//IMS
		if farmPlot.area_IMS > 0
		{
			if grow_Time_IMS >= time_Harvest_IMS
			{
			//write "...harvesting from integrated monodon";				
				set grow_Time_IMS <- 0;
				set farmPlot.yield_IMS <- crop_yield_IMS * farmPlot.area_IMS;
				set income_from_IMS <- farmPlot.yield_IMS * shrimp_price_IMS;
				set cycle_IMS <- cycle_IMS + 1;
				set grow_Time_IMS <- 0;
				
				
			}

		}

		//TODO: improve efficiency of code	

		//we need to seed new shrimp for the systems that were harvested
		do seed_new_shrimp;
	}

// ===
	action check_for_disease
	{
	//TODO: need to check probabilities in globals. Currently extreme high!	
	//TODO currently probabilities are non-conditional: is this ok?
		if flip(farmPlotFailureRate_INT)
		{
			disease_INT <- true;
		}

		if flip(farmPlotFailureRate_IE)
		{
			disease_IE <- true;
		}

		if flip(farmPlotFailureRate_IMS)
		{
			disease_IMS <- true;
		}

	}

	action update_loan_and_bank
	{
	//update bankaccount and loans based on cropcosts, yield and second income for each month

	//suggestion is to skip calucalating loans explicitely but consider a negative bankaccount as a loan.
	//this saves us a lot of hassle

	//recalculate balance based on costs and income
		let hhcost <- hh_Size * HH_expenses_avg;
		set bank_Account <- bank_Account - hhcost - crop_cost + second_Income + income_from_INT_mono + income_from_INT_vana + income_from_IE + income_from_IMS;
	}

	action seed_new_shrimp
	{
	//New shrimps are seed for systems for which the time is reset to 0. This is done after harvest.
	//The cost for seed/initialisation are added to the crop costs of that month		
	//TODO: Discuss the costs of seeding.
	//INT
		if (grow_Time_INT = 0) and (farmPlot.area_INT > 0)
		{
			if farmPlot.shrimp_Type = 1
			{
				set crop_cost <- crop_cost;
			} else
			{
				set crop_cost <- crop_cost;
			}

		}

		//IE
		if (grow_Time_IE = 0) and (farmPlot.area_IE > 0)
		{
			set crop_cost <- crop_cost;
		}

		//IMS
		if (grow_Time_IMS = 0) and (farmPlot.area_IMS > 0)
		{
			set crop_cost <- crop_cost;
		}

	}

	aspect default
	{
		draw square(25) color: rgb('white');
	}

} //farm

