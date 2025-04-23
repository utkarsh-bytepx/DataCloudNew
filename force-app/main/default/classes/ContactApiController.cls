public with sharing class ContactApiController {
    @AuraEnabled(cacheable=false)
    public static List<Map<String, String>> fetchContactData(String phone, String email) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://sf-api-3.onrender.com/search');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');

        Map<String, String> payload = new Map<String, String>{
            'phone' => phone,
            'email' => email
        };
        request.setBody(JSON.serialize(payload));

        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            throw new AuraHandledException('API call failed: ' + response.getBody());
        }

        List<Object> rawResponse = (List<Object>) JSON.deserializeUntyped(response.getBody());
        System.debug('rawResponse for Contact' + rawResponse);
        List<Map<String, String>> formattedData = new List<Map<String, String>>();

        for (Object obj : rawResponse) {
            Map<String, Object> table = (Map<String, Object>) obj;
            String tableName = (String) table.get('table_name');
            List<Object> rows = (List<Object>) table.get('rows');

            // Determine source based on table name
            String source = '';
            if (tableName == 'Table1') {
                source = 'Org1';
            } else if (tableName == 'Table2') {
                source = 'Org2';
            } else if (tableName == 'Table3') {
                source = 'Org3';
            } else {
                source = 'Unknown';
            }

            for (Object rowObj : rows) {
                Map<String, Object> row = (Map<String, Object>) rowObj;
                Map<String, String> entry = new Map<String, String>{
                    'Source' => source,
                    'Name' => (String) row.get('FIRSTNAME') + ' ' + (String) row.get('LASTNAME'),
                    'Email' => (String) row.get('EMAIL'),
                    'Phone' => (String) row.get('MOBILEPHONE'),
                    'Birth Date' => (String) row.get('BIRTHDATE')
                };
                formattedData.add(entry);
            }
        }

        return formattedData;
    }

    @AuraEnabled(cacheable=false)
    public static List<Map<String,String>> fetchOrderData(String email){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://sf-api-3.onrender.com/search_order?email=' + EncodingUtil.urlEncode(email, 'UTF-8'));
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');

        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            throw new AuraHandledException('Order API call failed: ' + response.getBody());
        }

        Map<String, Object> rawResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        List<Map<String, String>> formattedOrders = new List<Map<String, String>>();

        System.debug('rawResponse' + rawResponse);
        for (String key : rawResponse.keySet()) {
            List<Object> orders = (List<Object>) rawResponse.get(key);
            for (Object orderObj : orders) {
                Map<String, Object> order = (Map<String, Object>) orderObj;
                Map<String, String> entry = new Map<String, String>{
                    'Source' => key,
                    'Email' => (String) order.get('EMAIL'),
                    'Phone' => (String) order.get('MOBILEPHONE'),
                    'Amount' => String.valueOf(order.get('ORDER_AMOUNT')),
                    'Date' => (String) order.get('ORDER_DATE'),
                    'Description' => (String) order.get('DESCRIPTION'),
                    'OrderNumber' => (String) order.get('ORDER_NUMBER')
                };
                formattedOrders.add(entry);
            }
        }

        return formattedOrders;
    }
}