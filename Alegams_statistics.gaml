/**
* Name: Alegams_statistics
* Author: Ligte002
* Description: 
* Tags: Tag1, Tag2, TagN
*/



model Alegams_statistics

import "./Alegams_globals.gaml"
import "./Alegams_farm.gaml"
import "./Alegams_plot.gaml"

global{

float avg_BankAccount;
float std_BankAccount;
float std_up_BankAccount;
float std_down_BankAccount;
float min_BankAccount;
float max_BankAccount;
float tot_INT;
float tot_IE;
float tot_IMS;
float tot_INT_IE;
float tot_INT_IMS;
float tot_IE_IMS;

	action calculate_averag_bankaccount{
		list<float> bankaccount_List <- [];
		std_BankAccount <- 0.0;
		ask farm{
			add bank_Account to:  bankaccount_List; 
		}	
		
		avg_BankAccount <- mean(bankaccount_List);
		std_BankAccount <- mean_deviation(bankaccount_List);
		min_BankAccount <- min(bankaccount_List);
		max_BankAccount <- max(bankaccount_List);
		std_up_BankAccount <- avg_BankAccount + std_BankAccount;
		std_down_BankAccount <- avg_BankAccount - std_BankAccount;  
	}

	action calculate_tot_areas{
		set tot_INT <- 0.0;
		set tot_IE <- 0.0;
		set tot_IMS <- 0.0;
		ask plot{
			set tot_INT <- tot_INT + area_INT;
			set tot_IE <- tot_IE +area_IE;
			set tot_IMS <- tot_IMS + area_IMS;		
		}		
	}


}





