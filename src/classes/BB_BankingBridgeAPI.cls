/**
 *  @group          BankingBridge API
 *  @description    Contains Apex logic to send data to BankingBridge API
 */
public class BB_BankingBridgeAPI {

    /**
     *	@description 			Sends lead data to Bankingbridge lead-status API
     * 	@param leadResponse 	Serialized BB_BankingBridgeAPI_ResponseTypes.leadResponse with lead data
     * 	@param leadId 	                Lead ID to update with response data
     */

    @Future (Callout=true)
    public static void sendLeadData(String leadResponse, Id leadId) {

        //Lead to update response data with
        Lead lead = new Lead(Id=leadId);

        try{
            //Create new http request
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            Http http = new Http();

            //Set endpoint to BankingBridge lead-status API, add API Key, set type to post
            request.setEndpoint(BB_BankingBridgeAPI_CONSTANTS.ENDPOINT_LEAD_STATUS);
            request.setHeader('x-api-key', BB_BankingBridgeAPI_CONSTANTS.API_KEY);
            request.setHeader('Content-Type','application/json');
            request.setMethod('POST');
            request.setCompressed(true);
            request.setBody(leadResponse);
            response = http.send(request);

            System.debug('LeadDataResponse:'+response);

            //Set lead BB_Last_API_Sync_Status__c to the response status
            lead.BB_Last_API_Sync_Status__c = response.getStatus();
            if (response.getStatusCode() == 200) {

                //Retrieve and deserialize the response body
                String responseBody = response.getBody();

                Map<String, String> responseMap = (Map<String,String>) JSON.deserialize(responseBody, Map<String,String>.class);
                System.debug('LeadDataResponseMap:'+responseMap);

            }
        }
        catch(System.CalloutException e){
            //If callout exception set lead BB_Last_API_Sync_Status__c to exception message
            lead.BB_Last_API_Sync_Status__c = e.getMessage();
        }

        //Update lead with new data
        update lead;

    }

    /**
     *	@description 			        Sends lead subscription data to Bankingbridge subscription API and updates lead with response status, dashboard link and subscriptionid
     * 	@param subscriptionResponse 	Serialized BB_BankingBridgeAPI_ResponseTypes.subscriptionResponse with lead data
     * 	@param leadId 	                Lead ID to update with response data
     */

    @Future (Callout=true)
    public static void sendSubscriptionData(String subscriptionResponse, Id leadId) {

        //Lead to update response data with
        Lead lead = new Lead(Id=leadId);

        try{
            //Create new http request
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            Http http = new Http();

            //Set endpoint to BankingBridge API subscription, enter API Key, set type to post
            request.setEndpoint(BB_BankingBridgeAPI_CONSTANTS.ENDPOINT_SUBSCRIPTION);
            request.setHeader('x-api-key', BB_BankingBridgeAPI_CONSTANTS.API_KEY);
            request.setHeader('Content-Type','application/json');
            request.setMethod('POST');
            request.setCompressed(true);
            request.setBody(subscriptionResponse);
            response = http.send(request);

            System.debug('SubscriptionResponse:'+response);

            //Set lead BB_Last_API_Sync_Status__c to the response status
            lead.BB_Last_API_Sync_Status__c = response.getStatus();
            if (response.getStatusCode() == 200) {

                //Retrieve and deserialize the response body
                String responseBody = response.getBody();

                Map<String, String> responseMap = (Map<String,String>) JSON.deserialize(responseBody, Map<String,String>.class);
                System.debug('SubscriptionResponseMap:'+responseMap);


                //If response body contains valid subscription id, update lead BB_Subscription_Id__c
                String subscriptionId = JSON.serialize(responseMap.get('subscription_id'));
                if(!String.isBlank(subscriptionId) && subscriptionId != 'null') {
                    lead.BB_Subscription_Id__c = subscriptionId.replaceAll('"','');
                }

                //If response body contains valid dashboard_link, update lead Subscription_URL__c
                String subscriptionURL = responseMap.get('dashboard_link');
                if(!String.isBlank(subscriptionURL)  && subscriptionURL != 'null') {
                    lead.BB_Subscription_URL__c = subscriptionURL;
                }

            }
        }
        catch(System.CalloutException e){

            //If callout exception set lead BB_Last_API_Sync_Status__c to exception message
            lead.BB_Last_API_Sync_Status__c = e.getMessage();
        }

        //Update lead with new data
        update lead;

    }

    /**
     *	@description    Creates a blank post to BankingBridge subscription API with API key.
     * 	@return 		Status of success or failure from endpoint based on validity of API key
     */

    public static String getConnectionStatus() {

        //String to return of response status
        String responseStatus;

        try{
            //Create new http request
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            Http http = new Http();

            //Set endpoint to BankingBridge subscription API, set API Key, set type to post
            request.setEndpoint(BB_BankingBridgeAPI_CONSTANTS.ENDPOINT_SUBSCRIPTION);
            request.setHeader('x-api-key', BB_BankingBridgeAPI_CONSTANTS.API_KEY==null?'':BB_BankingBridgeAPI_CONSTANTS.API_KEY);
            request.setHeader('Content-Type','application/json');
            request.setMethod('POST');
            request.setCompressed(true);
            response = http.send(request);

            //If response is 200 code, set response status to default connection success message
            if (response.getStatusCode() == 200) {
                responseStatus = BB_BankingBridgeAPI_CONSTANTS.CONNECTION_SUCCESS;

            }else {
                //If response fails, set message to default response failure message and failure response status
                responseStatus = BB_BankingBridgeAPI_CONSTANTS.CONNECTION_FAILURE+String.valueOf(response.getStatus());
            }
        }
        catch(System.CalloutException e){

            //If callout exception, set response to default failure message and callout exception
            responseStatus = BB_BankingBridgeAPI_CONSTANTS.CONNECTION_FAILURE+e.getMessage();
        }

        //Return response string
        return responseStatus;

    }

    /**
     *	@description 	Creates serialized BB_BankingBridgeAPI_ResponseTypes.leadResponse based on lead information
     * 	@param lead 	Lead with data to pass to BB_BankingBridgeAPI_ResponseTypes.leadResponse
     * 	@return 		JSON serialized string of BB_BankingBridgeAPI_ResponseTypes.leadResponse
     */

    public static String createLeadResponse(Lead lead){

        //Create new lead response type
        BB_BankingBridgeAPI_ResponseTypes.leadResponse leadResponse = new BB_BankingBridgeAPI_ResponseTypes.leadResponse();
        leadResponse.email = lead.Email;

        //Set leadStatus to default status
        String leadStatus = BB_BankingBridgeAPI_CONSTANTS.LEADSTATUS_DEFAULT;

        //If lead status contains closed or is convert, set lead status to default closed status
        if(lead.Status.toLowerCase().contains(BB_BankingBridgeAPI_CONSTANTS.LEADSTATUS_CLOSED) || lead.IsConverted){
            leadStatus = BB_BankingBridgeAPI_CONSTANTS.LEADSTATUS_CLOSED;
        }

        //If lead status contains approved, set lead status to default approved status
        else if(lead.Status.toLowerCase().contains(BB_BankingBridgeAPI_CONSTANTS.LEADSTATUS_APPROVED)){
            leadStatus = BB_BankingBridgeAPI_CONSTANTS.LEADSTATUS_APPROVED;
        }

        //If lead status contains locked, set lead status to default locked status
        else if(lead.Status.toLowerCase().contains(BB_BankingBridgeAPI_CONSTANTS.LEADSTATUS_LOCKED)){
            leadStatus = BB_BankingBridgeAPI_CONSTANTS.LEADSTATUS_LOCKED;
        }

        //Set lead status to converted status to match Banking Bridge API lead statuses
        leadResponse.status = leadStatus;

        //Set brand id to what is entered in API Config
        leadResponse.brand_id = BB_BankingBridgeAPI_CONSTANTS.BRAND_ID;

        //Return serialized lead response
        return JSON.serialize(leadResponse);

    }

    /**
     *	@description 	Creates serialized BB_BankingBridgeAPI_ResponseTypes.subscriptionResponse based on lead information
     * 	@param lead 	Lead with data to pass to BB_BankingBridgeAPI_ResponseTypes.subscriptionResponse
     * 	@return 		JSON serialized string of BB_BankingBridgeAPI_ResponseTypes.subscriptionResponse
     */

    public static String createSubscriptionResponse(Lead lead){

        //Create new subscription response type
        BB_BankingBridgeAPI_ResponseTypes.subscriptionResponse subscriptionResponse = new BB_BankingBridgeAPI_ResponseTypes.subscriptionResponse();

        //Assign all values to corresponding lead data
        subscriptionResponse.id = lead.BB_Subscription_Id__c==null?'':lead.BB_Subscription_Id__c;
        subscriptionResponse.nmls = lead.BB_NMLS__c==null?'':lead.BB_NMLS__c;
        subscriptionResponse.loid = lead.BB_LOID__c==null?'':lead.BB_LOID__c;
        subscriptionResponse.first_name = lead.FirstName==null?'':lead.FirstName;
        subscriptionResponse.last_name = lead.LastName==null?'':lead.LastName;
        subscriptionResponse.email = lead.Email==null?'':lead.Email;
        subscriptionResponse.phone = lead.Phone==null?'':lead.Phone;
        subscriptionResponse.active = true;
        subscriptionResponse.type = 'specific';

        //Create new quote_info response type and assign all values to corresponding lead data
        BB_BankingBridgeAPI_ResponseTypes.quote_infoResponse quote_info = new BB_BankingBridgeAPI_ResponseTypes.quote_infoResponse();
        quote_info.arm_term = lead.BB_ARM_Term__c==null?'':String.valueOf(lead.BB_ARM_Term__c);
        quote_info.cash_out = lead.BB_Cash_Out__c==null?'':String.valueOf(lead.BB_Cash_Out__c);
        quote_info.credit_score = lead.BB_Credit_Score__c==null?'':String.valueOf(lead.BB_Credit_Score__c);
        quote_info.list_price = lead.BB_Property_Value__c==null?'':String.valueOf(lead.BB_Property_Value__c);
        quote_info.loan_amount = lead.BB_Loan_Amount__c==null?'':String.valueOf(lead.BB_Loan_Amount__c);
        quote_info.loan_purpose = lead.BB_Loan_Purpose__c==null?'':lead.BB_Loan_Purpose__c;
        quote_info.loan_term = lead.BB_Loan_Term__c==null?'':lead.BB_Loan_Term__c;
        quote_info.debt_to_income = lead.BB_Debt_to_Income__c==null?'':String.valueOf(lead.BB_Debt_to_Income__c);
        quote_info.loan_type = lead.BB_Loan_Type__c==null?'':lead.BB_Loan_Type__c;
        quote_info.lock_period = lead.BB_Lock_Period__c==null?'':String.valueOf(lead.BB_Lock_Period__c);
        quote_info.military_eligible = lead.BB_Military_Eligible__c?'yes':'no';
        quote_info.property_type = lead.BB_Property_Type__c==null?'':lead.BB_Property_Type__c;
        quote_info.residency_type = lead.BB_Residency_Type__c==null?'':lead.BB_Residency_Type__c;

        //Create new location response type and assign all values to corresponding lead data
        BB_BankingBridgeAPI_ResponseTypes.locationResponse location = new BB_BankingBridgeAPI_ResponseTypes.locationResponse();
        location.city = lead.BB_Property_City__c==null?'':lead.BB_Property_City__c;
        location.state = lead.BB_Property_State__c==null?'':lead.BB_Property_State__c;
        location.zipcode = lead.BB_Property_Zipcode__c==null?'':lead.BB_Property_Zipcode__c;
        location.street_address = lead.BB_Property_Street_Address__c==null?'':lead.BB_Property_Street_Address__c;
        quote_info.location = location;
        subscriptionResponse.quote_info = quote_info;

        //Create new settings response type and assign default value
        BB_BankingBridgeAPI_ResponseTypes.settingsResponse settings = new BB_BankingBridgeAPI_ResponseTypes.settingsResponse();
        settings.frequency = 'default';
        subscriptionResponse.settings = settings;

        //Serialize and return response
        return JSON.serialize(subscriptionResponse);

    }

}