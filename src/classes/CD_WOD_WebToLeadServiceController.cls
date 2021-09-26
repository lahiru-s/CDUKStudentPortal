/**************************************************************
* Description       : Controller class for CD_WOD_WebToLead: with EmailServicesUtil added
* @author           : Lahiru Subasinghe
* @since            : February 17, 2018
***************************************************************/

public class CD_WOD_WebToLeadServiceController  {
    
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String emailAddress { get; set; }
    public String mobile { get; set; }
    public String infoTextArea { get; set; }
    public String homePhoneNumber { get; set; } 
    public String studyArea { get; set; }    
    public String preferredCountry { get; set; }
    public String hearUs { get; set; }
    public String vfPageNumber { get; set; }
    
    public String selectedMethod { get; set; }
    
    public String errorMsg { get; set; }
    public Boolean showError { get; set; }
    public Boolean showSuccess { get; set; }
    
    //Email related fields
    public String vfVersion { get; set; } 
    public String campaignName;
    public String studentName;
    public DateTime startDate;
    public String duration;
    public String eventLocation;
    
    Map<Id, List<Lead__c>> campToLeadMap = new Map<Id, List<Lead__c>>();
    Map<Id, Campaign> campMap = new Map<Id, Campaign>();
    List<Lead__c> leadList = new List<Lead__c>();
    CD_EmailServicesUtil utilClass = new CD_EmailServicesUtil();
    
    public CD_WOD_WebToLeadServiceController(){
        this.showError = false;
        this.showSuccess = false;
        this.errorMsg = '';
    }
    
    //Add options to selected methods
    public List<SelectOption> getPrefOptions() {
         
        List<SelectOption> options = new List<SelectOption>();
            
        Schema.DescribeFieldResult fieldResult = Lead__c.Country_Interested_In__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        //ops.add(new SelectOption('', '--Select--'));
        for (Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        
        return options; 
    }
    
    
    
    //Add options to hear about us
    public List<SelectOption> getHearAbtUs() {
         
        List<SelectOption> opts = new List<SelectOption>();
            
        Schema.DescribeFieldResult fieldResult = Lead__c.Lead_Source__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        system.debug('=====> ple'+ple);
        
        opts.add(new SelectOption('', '--Select--'));
        for (Schema.PicklistEntry f : ple){
            opts.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        system.debug('====> opts'+opts);
        return opts; 
    }
    
   
    
    //Create new Lead
    public void saveLead(){
    
        try{
            
            //Get organization wide address
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'suresh@cduk.lk'];
            
            
            this.vfVersion = 'v1';
                
            Campaign_List__mdt clm = [Select Id, Campaign_Name__c, Page_Version__c From Campaign_List__mdt Where Page_Version__c =:vfVersion];
            Campaign camRec;
            system.debug('====> clm '+clm);
                
            if (clm != null){
                
                camRec = [Select Id, Name, StartDate, EndDate, Duration__c, Location__c From Campaign Where Name =:clm.Campaign_Name__c ];
                this.campaignName = camRec.Name;
                this.startDate = camRec.StartDate;
                this.duration = camRec.Duration__c;
                this.eventLocation = camRec.Location__c;
                
                campMap.put(camRec.Id, camRec);
            }
            
            if (processValidations(camRec, this.emailAddress)){
            
                //First create a lead record and send the email with QR Code
                System.debug('preferredCountry::'+preferredCountry);
                String finalPrefCountryString = '';
                //Prepare preferred Country mpl
                if (preferredCountry != '' && preferredCountry.contains(','))
                    finalPrefCountryString = preferredCountry.substringBetween('[',']').replace(',', ';');
                else if (preferredCountry != '')
                    finalPrefCountryString = preferredCountry.substringBetween('[',']');
                    
                    
                system.debug('finalPrefCountryString'+finalPrefCountryString);
                
                Lead__c aLead = new Lead__c();
                aLead.First_Name__c = firstName;
                aLead.Last_Name__c = lastName;
                aLead.Email__c = emailAddress;
                aLead.Mobile__c = mobile;
                aLead.Home_Phone_Number__c = homePhoneNumber;
                aLead.Interested_Field_of_Study__c = studyArea;
                aLead.Lead_Source__c = hearUs;
                aLead.Campaign_Email_Triggered__c = true;
                if (camRec != null)
                    aLead.Campaign__c = camRec.Id;
                if (finalPrefCountryString != '')
                    aLead.Country_Interested_In__c = finalPrefCountryString;
                aLead.Comments__c = infoTextArea;
                
                insert aLead;
                
                //Implemented this for bulk operations. However here we are pretty sure that Leads comes individually
                leadList.add(aLead);
                campToLeadMap.put(camRec.Id, leadList);
                
                //Load necesary fields to send the email if Lead creation is successfull 
                
                System.debug('====> campMap:: '+campMap);
                System.debug('====> campToLeadMap:: '+campToLeadMap);
                
                List<EmailServiceDTO> esList = prepareEmailServiceWrapper(campMap, campToLeadMap);
                System.debug('====> esList:: '+esList);
                
                utilClass.CD_sendEmails(esList);
                    
                clearForm();
                this.showSuccess = true;
                
                
            }
            
        }catch(exception ex){
            System.debug('EX message::'+ex.getMessage());
            this.errorMsg = 'There are some issues submitting the form. '+ex.getMessage();
            this.showError = true;
            
        }
      
    }
    
    //Process Lead validations
    public Boolean processValidations(Campaign cmp, String email){
        
        //Email validation
        //List<Lead__c> leads = [Select Id, Name, Email__c, Campaign__c From Lead__c Where Campaign__c =:cmp.Id AND Email__c =:email];
        List<Lead__c> leads = [Select Id, Name, Email__c, Campaign__c From Lead__c Where Email__c =:email];
        
        if (leads.size() > 0){
            throw new applicationException('A Lead Student was already created for the same Email');
            //this.errorMsg = 'A Student record was already created for this email address. Please use different email or contact us!';
            //this.showError = true;
            return false;
        }
        else
            return true;
    }
    
    
    //Clears content
    public void clearForm(){
        
        this.firstName = '';
        this.lastName = '';
        this.mobile = '';
        this.emailAddress = '';
        this.infoTextArea = '';
        this.selectedMethod = '--Select--';
        this.preferredCountry = '';
        this.hearUs = '';
        this.homePhoneNumber = '';
    }
   
    
    public void closeNotification(){
        this.showError = false;
        this.showSuccess = false;
    }
    
    public class applicationException extends Exception {}
    
    public List<EmailServiceDTO> prepareEmailServiceWrapper(Map<Id, Campaign> cmpMap, Map<Id, List<Lead__c>> campToLdMap){
        
        List<EmailServiceDTO> esList = new List<EmailServiceDTO>();
        EmailServiceDTO es;
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'suresh@cduk.lk'];
        
        for (Id cmpId: cmpMap.keyset()){
            for (Lead__c ld: campToLdMap.get(cmpId)){
                es = new EmailServiceDTO();
                es.campaignName = cmpMap.get(cmpId).Name;
                es.campaignLocation = cmpMap.get(cmpId).Location__c;
                es.campaignDuration = cmpMap.get(cmpId).Duration__c;
                es.campaignStartDate = cmpMap.get(cmpId).StartDate;
                es.leadRecord = ld;
                es.emailTo = new List<String>{ ld.Email__c };
                
                if ( owea.size() > 0 ) {
                    es.emailFromId = owea.get(0).Id;
                } 
                
                esList.add(es);
            }
        }
        
        return esList;
    } 
    
    

}