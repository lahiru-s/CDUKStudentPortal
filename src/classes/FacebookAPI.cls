public with sharing class FacebookAPI {
    //public static final String FACEBOOK_LEADS_ENDPOINT = 'https://graph.facebook.com/v3.1/545322862568323/leads';
    
    public static Map<String, String> fieldMapping {
        get {
            return new Map<String, String> {
                //Custom Details
                'passport_number'               => 'Passport_Number__c'
                ,'how_did_hear_about_us?'       => 'Lead_Source__c'
                ,'expected_year_to_begin'       => 'Expected_Year_to_Begin__c'
                ,'current_qualification'        => 'Current_Qualification__c'
                ,'interested_field_of_study'    => 'Interested_Field_of_Study__c'
                ,'current_city'                 => 'City__c'
                
                //Personal Details
                ,'first_name'                   => 'Name'
                ,'last_name'                    => 'Last_Name__c'
                ,'email'                        => 'Email__c'
                ,'phone_number'                 => 'Mobile__c'
                ,'gender'                       => 'Gender__c'
                ,'marital_status'               => 'Marital_Status__c'
                               
                //Address Details
                ,'street_address'               => 'Address_Line_1__c'
                ,'city'                         => 'City_p__c'
                ,'state'                        => 'Address_Line_2__c'
                ,'country'                      => 'Country_p__c'
                ,'zip_code'                     => 'Postal_Zip_Code_p__c'
            };
        }
    }
    
    @future(callout=true)
    public static void getLeads() {
       
        HttpRequest req = new HttpRequest();
        
        req.setMethod( 'GET' );
        req.setEndpoint('callout:Facebook_Named');
        req.setheader('accept','application/json');
        
        HttpResponse resp = new Http().send( req );
        if( resp.getStatusCode() == 200 ) {
            FacebookClasses.FacebookResponse fbResp = ( FacebookClasses.FacebookResponse ) JSON.deserialize( resp.getBody(), FacebookClasses.FacebookResponse.class );
           
            List<Lead__c> leads = new List<Lead__c>();
            
            Map<String, String> universities = getStoredUniversities();
            
            for( FacebookClasses.Datum datum : fbResp.data ) {
                Lead__c ld = new Lead__c();
                
                for( FacebookClasses.FieldDatum fldDatum : datum.field_data ) {
                    /**
                     * Exception for Country
                     */
                    if( fldDatum.name.startsWith( 'country_interested_in' ) ) {
                        ld.Country_Interested_In__c = String.join( fldDatum.values, '' ).replace( ',', ';' );
                        //ld.Country_Interested_In__c = fldDatum.values[0].replace( ',', ';' );
                    }
                    
                    /**
                     * Exception for DOB
                     */
                    else if( fldDatum.name.equals( 'date_of_birth' ) ) {
                        List<String> parts = new List<String>();
                        parts = String.join( fldDatum.values, '' ).split('/');
                        Date DOB = Date.newInstance(Integer.valueOf(parts[2]), Integer.valueOf(parts[0]), Integer.valueOf(parts[1]));
                        ld.DOB__c = DOB;
                    }
                    
                    /**
                     * Exception for Preferred University
                     */
                    else if( fldDatum.name.equals( 'preferred_university' ) ) {
                        ld.Preferred_University__c = universities.get( String.join( fldDatum.values, '' ) );
                        //ld.Preferred_University__c = universities.get( fldDatum.values[0] );
                    }
                    
                    else {
                        String fieldAPIName = fieldMapping.get( fldDatum.name );
                        ld.put( fieldAPIName, String.join( fldDatum.values, '' ) );
                        //ld.put( fieldAPIName, fldDatum.values[0] );
                    }
                }
                
                ld.Lead_Source__c = 'Facebook';   
                System.debug('The leads is '+leads);
                leads.add( ld );
            }
            
            UPSERT leads Email__c;
        }
        
    }
    
    private static Map<String, String> getStoredUniversities() {
        Map<String, String> storedUniversities = new Map<String, String>();
        
        for( University__c univ : [
                SELECT  Id
                        ,Name
                FROM    University__c
                LIMIT   50000
            ]
        ) {
            storedUniversities.put( univ.Name, univ.Id );
        }
        
        return storedUniversities;
    }
}