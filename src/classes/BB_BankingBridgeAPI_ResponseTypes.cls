/**
 *	@group 			BankingBridge API
 * 	@description	Classes used in posts and responses of BankingBridgeAPI
 */
global without sharing class BB_BankingBridgeAPI_ResponseTypes {

    global class leadResponse {
        global String status { get; set; }
        global String email { get; set; }
        global String brand_id { get; set; }
    }

    global class subscriptionResponse {
        global String id { get; set; }
        global String nmls { get; set; }
        global String loid { get; set; }
        global quote_infoResponse quote_info { get; set; }
        global settingsResponse settings { get; set; }
        global String first_name { get; set; }
        global String last_name { get; set; }
        global String phone { get; set; }
        global String email { get; set; }
        global String type { get; set; }
        global Boolean active { get; set; }
    }

    global class quote_infoResponse {
        global String list_price { get; set; }
        global String loan_amount { get; set; }
        global String loan_type { get; set; }
        global String loan_purpose { get; set; }
        global String residency_type { get; set; }
        global String military_eligible { get; set; }
        global String cash_out { get; set; }
        global String credit_score { get; set; }
        global String debt_to_income { get; set; }
        global String property_type { get; set; }
        global String lock_period { get; set; }
        global String loan_term { get; set; }
        global String arm_term { get; set; }
        global locationResponse location { get; set; }
    }

    global class locationResponse {
        global String city { get; set; }
        global String state { get; set; }
        global String zipcode { get; set; }
        global String street_address { get; set; }
    }

    global class settingsResponse {
        global String frequency { get; set; }
    }

}