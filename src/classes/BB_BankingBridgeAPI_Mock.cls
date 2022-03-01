/**
 *	@group 			Mock Generators
 * 	@description	Generates mocks for testing BankingBridge API
 */
@isTest
public without sharing class BB_BankingBridgeAPI_Mock {

    //Mock used in testing to return a successful lead-status response
    @TestVisible class LeadStatusResponseSuccess implements HttpCalloutMock {

        public HttpResponse respond(HttpRequest req) {

            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('success');
            response.setHeader('Content-Type', 'application/json');
            String responseBody = '{"status":"success"}';
            response.setBody(responseBody);

            return response;
        }
    }

    //Mock used in testing to return an error lead-status response
    @TestVisible class LeadStatusResponseError implements HttpCalloutMock {

        public HttpResponse respond(HttpRequest req) {

            HttpResponse response = new HttpResponse();
            response.setStatusCode(500);
            response.setStatus('error');
            response.setHeader('Content-Type', 'application/json');

            return response;
        }
    }

    //Mock used in testing to return a successful subscription response
    @TestVisible class SubscriptionResponseSuccess implements HttpCalloutMock {

        public HttpResponse respond(HttpRequest req) {

            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('success');
            response.setHeader('Content-Type', 'application/json');
            String responseBody = '{"status":"success","subscription_id":"1","dashboard_link":"http://dashboardlink.com"}';
            response.setBody(responseBody);

            return response;
        }
    }

    //Mock used in testing to return an error subscription response
    @TestVisible class SubscriptionResponseError implements HttpCalloutMock {

        public HttpResponse respond(HttpRequest req) {

            HttpResponse response = new HttpResponse();
            response.setStatusCode(500);
            response.setStatus('error');
            response.setHeader('Content-Type', 'application/json');

            return response;
        }
    }

    //Mock used in testing to return an unauthorized exception response
    @TestVisible class UnauthorizedEndpointResponse implements HttpCalloutMock {

        public HttpResponse respond(HttpRequest request) {
            CalloutException e = (CalloutException)CalloutException.class.newInstance();
            e.setMessage('unauthorized');
            throw e;
        }

    }

}