/* Controller for Web to Lead form using Custom Lead Object
*  Developed By - Naveen
*/

global with sharing class WebToLead{
    public string LeadType { get;set; }
     
	Map<String , Lead__c> ldmap {get; set;}
    //Added by Lahiru
    public static String preferredCountry { get; set; }
	
    Public Lead__c ld { get; set; }
    public WebToLead(ApexPages.StandardController controller){
        ld = new Lead__c();
        getpickvalues();
        getPrefOptions();
        
        LeadType = Apexpages.currentPage().getParameters().get('leadtype');
	
		
        
    }
    
    /*    
    public static List<SelectOption> getPrefOptions() {
         
        List<SelectOption> options = new List<SelectOption>();
            
        Schema.DescribeFieldResult fieldResult = Lead__c.Country_Interested_In__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        //ops.add(new SelectOption('', '--Select--'));
        for (Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        
        return options; 
    }
	*/
    
    
    
    public list<String> leadSourceList { get;set; }
    public list<String> prefCountryList { get; set; }
    
    /* Get How did you Hear about us Picklist Values   */
    public void getpickvalues(){
        leadSourceList = new List<String>();
        Schema.DescribeFieldResult leadSource = Lead__c.Lead_Source__c.getDescribe();
        List<Schema.PicklistEntry> leadSourceVal = leadSource.getPicklistValues();
        for (Schema.PicklistEntry pickListVal : leadSourceVal) {
            leadSourceList.add(pickListVal.getLabel());
        }   
    }
    
    //Added by Lahiru
    public void getPrefOptions(){
        prefCountryList = new List<String>();
        Schema.DescribeFieldResult prefCoun = Lead__c.Country_Interested_In__c.getDescribe();
        List<Schema.PicklistEntry> prefCountryeVal = prefCoun.getPicklistValues();
        for (Schema.PicklistEntry pickListVal : prefCountryeVal) {
            prefCountryList.add(pickListVal.getLabel());
        }   
    }
    
    
    /*public PageReference receiveInput() {
		 String input1 = Apexpages.currentPage().getParameters().get('input1');
			ldmap.put(input1 , new Lead__c());
			return null;

		}

		public PageReference removeInput() {
        String input2 = Apexpages.currentPage().getParameters().get('input2');
        ldmap.remove(input2);
        return null;
    }*/  
		
	
	
    
    
    
     /* Wrapper  Class For Universities Lookup*/
    public class University {
        public String id;
        public String label;
        public String metaLabel;
        
        public University( String id, String label, String metaLabel ) {
            this.id         = id;
            this.label      = label;
            this.metaLabel  = metaLabel;
        }
        
        public University( University__c  UniversityRecord ) {
            id          = UniversityRecord.Id;
            label       = UniversityRecord.Name;
            metaLabel   = UniversityRecord.University_Address__c;
        }
    }
    
    /*
    @RemoteAction
    public static List<University> getExistingUniversities() {
        List<University__c> universityList = [
            SELECT      Id
                        ,Name
                        ,University_Address__c
            FROM        University__c
        ];
        
        if( universityList != NULL ) {
            List<University> allUniversities = new List<University>();
            for( University__c univVal : universityList ) {
                University univ = new University( univVal );
                allUniversities.add( univ );
            }
            
            return allUniversities;
        }
        
        return NULL;
    }
	/*
   
    /* Save Part */
    @RemoteAction
    global static String saveFormLd( String firstName, String lastName, String email,String mobile,String message,String university,String leadSource,String leadtype, String prefcountry) {
        try {
            Lead__c ld = new Lead__c();
            ld.First_Name__c = firstName;
            ld.Last_Name__c = lastName;
            ld.Email__c =  email;
            ld.Mobile__c = mobile;
            ld.Web_Lead_Message__c = message;
            ld.Preferred_University__c = university;
            ld.Lead_Source__c = leadSource;
            ld.Lead_Type__c = leadtype;
            
            system.debug(':: preferredCountry :: '+prefcountry);
            
            //Add preferred country
            String finalPrefCountryString = '';
            //Prepare preferred Country mpl
            if (prefcountry != '' && prefcountry.contains(','))
                finalPrefCountryString = prefcountry.substringBetween('[',']').replace(',', ';');
            else if (prefcountry != '')
                finalPrefCountryString = prefcountry.substringBetween('[',']');    
            
            ld.Country_Interested_In__c = finalPrefCountryString;
           
            INSERT ld;
        }
        catch(Exception e){
            System.debug('Query Issue:' +e);
        }
        
        return NULL;
    }
}