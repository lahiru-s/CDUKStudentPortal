/**************************************************************
* Description       : Controller class for CD_WOD_WebToLead
* @author           : Lahiru Subasinghe
* @since            : February 17, 2018
***************************************************************/

public class CD_WOD_WebToLeadController  {
    
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
    public Datetime endDate;
    public String duration;
    public String eventLocation;
    public String virtualInfo;    
    
    public CD_WOD_WebToLeadController(){
        this.showError = false;
        this.showSuccess = false;        
        this.errorMsg = '';
    }
    
    //Add options to selected methods
    public List<SelectOption> getPrefOptions() {
         
        //16/09 Lahiru: Updated for limited countries
        Set<String> limitCountries = new Set<String>{'UK', 'Australia', 'USA', 'Canada'};
        List<SelectOption> options = new List<SelectOption>();
            
        Schema.DescribeFieldResult fieldResult = Lead__c.Country_Interested_In__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        //ops.add(new SelectOption('', '--Select--'));
        for (Schema.PicklistEntry f : ple){
            if (limitCountries.contains(f.getLabel()))                
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
            
            this.vfVersion = Apexpages.currentPage().getParameters().get('one');          
            
            system.debug('current version:::'+this.vfVersion);               
           
                
            //camRec = [Select Id, Name, StartDate, EndDate, Duration__c, Location__c, Virtual_Meeting_Info__c From Campaign Where Name =:clm.Campaign_Name__c ];
            List<Campaign> camRecList = [Select Id, Name, StartDate, EndDate, Duration__c, Location__c, Virtual_Meeting_Info__c, Campaign_Version__c From Campaign Where Campaign_Version__c =:vfVersion ];
            if (camRecList.size() > 0){
                this.campaignName = camRecList[0].Name;
                this.startDate = camRecList[0].StartDate;
                this.endDate = camRecList[0].EndDate;
                this.duration = camRecList[0].Duration__c;
                this.eventLocation = camRecList[0].Location__c;
                this.virtualInfo = camRecList[0].Virtual_Meeting_Info__c;            
            
                system.debug('** this.virtualInfo ** '+this.virtualInfo);
                Boolean isVirtualEvent = (virtualInfo != null && virtualInfo != '') ? true : false;
                system.debug('isVirtualEvent:::'+isVirtualEvent);
                
                if (processValidations(camRecList[0], this.emailAddress)){
                    
                    //Get Create Lead in to one method
                    Lead__c ldRecord = createLeadRecord(camRecList[0]);   
                    
                    //Load necesary fields to send the email if Lead creation is successfull 
                    System.debug('====> aLead '+ldRecord);
                    if (ldRecord.Id != null){
                        
                        //Send Versions of the email
                        sendEmailsToLeads(ldRecord, isVirtualEvent);                       
                        clearForm();
                        this.showSuccess = true;
                    
                    }
            	}
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
        List<Lead__c> leads = [Select Id, Name, Email__c, Campaign__c From Lead__c Where Campaign__c =:cmp.Id AND Email__c =:email];
        //List<Lead__c> leads = [Select Id, Name, Email__c, Campaign__c From Lead__c Where Email__c =:email];
        
        if (leads.size() > 0){
            //throw new applicationException('A Lead Student was already created for the same Email');
            this.errorMsg = 'A Student record was already created for this email address. Please use different email or contact us!';
            this.showError = true;            
            return false;
        }
        else
            return true;
    }
    
    //Create the Lead Record
    public Lead__c createLeadRecord(Campaign camRec){       
        
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
        aLead.Controller_email_triggered_for__c = 'Web';
        aLead.Nearest_Branch__c = 'Colombo';
        if (camRec != null)
            aLead.Campaign__c = camRec.Id;
        if (finalPrefCountryString != '')
            aLead.Country_Interested_In__c = finalPrefCountryString;
        aLead.Comments__c = infoTextArea;
        
        insert aLead;
        
        return aLead;
        
    }
    
    
    //Sends the global email to created Emails
    public void sendEmailsToLeads(Lead__c aLead, Boolean isVirtual){        
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'suresh@cduk.lk'];		//Get organization wide address
    	vfVersion = apexpages.currentPage().getParameters().get('vfVersion');        
        
        this.studentName = firstName + ' ' + lastName;  
        String messageBody = '';
        
        String qrCodeLink = 'https://cduk--c.ap4.visual.force.com/apex/processLead?lid='+aLead.Id;
        if(isVirtual){
            //Build the Virtual Message 
            messageBody = '<html><body>Dear '+this.studentName+','+   
            '<br><br>Thank you for registering for '+this.campaignName+
            '<br>Please note the event will be held on <b>'+this.startDate.format('MMMMM dd, yyyy')+ ' & '+this.endDate.format('MMMMM dd, yyyy')+ '</b> from <b>'+this.duration+ '</b> via <b>'+this.eventLocation+
            '</b><br><br><strong>Meeting Links for the Event</strong>'+
             '<br>'+this.virtualInfo+ 
            '<br><br> We look forward to seeing you at the event!'+            
            '<br><br> Best Regards,'+
            '<br> Campus Direct'+
            '<br><br><b>Head Office</b>'+    
            '<br>No: 36B, Gower Street,</b><br><b>Colombo 05</b>'+
            '<br><br><b>Kandy Branch</b>'+    
            '<br>No: 749, B/1 William Gopallawa Mawatha,</b><br><b>Kandy</b>'+
            '<br><br> Hotline: (0094) 77 9005555 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Website:</b> www.cduk.lk '+
            '</body></html>';
        }else{
            
             messageBody = '<html><body>Dear '+this.studentName+','+   
            '<br><br>Thank you for registering for '+this.campaignName+
            '<br>Please note the event will be held on <b>'+this.startDate.format('MMMMM dd, yyyy')+ '</b> from <b>'+this.duration+ '</b> at the <b>'+this.eventLocation+
            '</b><br><br> Entrance is Free! <br><br> Please bring a copy of this email or show this email for fast and easy access to the event. (Registration at the event is not required).'+
            '<br> Please also bring all your Academic Documents for a free Assessment in order to obtain Scholarships and Offers on the Spot from the University Representatives.'+
            '<br><br> We look forward to seeing you at the event:'+
            '<br><br> <img src="http://api.qrserver.com/v1/create-qr-code/?size=75x75&qzone=1&data='+qrCodeLink+ '" alt="Logo"/>'+
            '<br><br> Best Regards,'+
            '<br> Campus Direct'+
            '<br><br><b>Head Office</b>'+    
            '<br>No: 36B, Gower Street,</b><br><b>Colombo 05</b>'+
            '<br><br><b>Kandy Branch</b>'+    
            '<br>No: 749, B/1 William Gopallawa Mawatha,</b><br><b>Kandy</b>'+
            '<br><br> Hotline: (0094) 77 9005555 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Website:</b> www.cduk.lk '+
            '</body></html>';
            
        }
       
        String subject = 'Thank you for registering for '+this.campaignName;
        
        system.debug('====> subject '+subject);        
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new list<string>{emailAddress});
        mail.setSaveAsActivity(false);
        mail.setSubject(subject);
        mail.setHtmlBody(messageBody);
        //mail.setSenderDisplayName = 'Campus Direct';
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
        
        
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
    
    public class leadWrapper {
        
    }
    
    

}