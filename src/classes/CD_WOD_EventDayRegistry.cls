/**************************************************************
* Description       : Controller class for CD_WOD_WebToLead
* @author           : Lahiru Subasinghe
* @since            : February 17, 2018
***************************************************************/

public class CD_WOD_EventDayRegistry  {
    
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
    
    public CD_WOD_EventDayRegistry(){
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
            this.vfVersion = Apexpages.currentPage().getParameters().get('one');
            
            system.debug('current version:::'+this.vfVersion);
            
            //this.vfVersion = 'v1';
                
            Campaign_List__mdt clm = [Select Id, Campaign_Name__c, Page_Version__c From Campaign_List__mdt Where Page_Version__c =:vfVersion];
            Campaign camRec;
            system.debug('====> clm '+clm);
                
            if (clm != null){
                
                camRec = [Select Id, Name, StartDate, EndDate, Duration__c, Location__c From Campaign Where Name =:clm.Campaign_Name__c ];
                this.campaignName = camRec.Name;
                this.startDate = camRec.StartDate;
                this.duration = camRec.Duration__c;
                this.eventLocation = camRec.Location__c;
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
                aLead.Controller_email_triggered_for__c = 'Web';
                if (camRec != null)
                    aLead.Campaign__c = camRec.Id;
                if (finalPrefCountryString != '')
                    aLead.Country_Interested_In__c = finalPrefCountryString;
                aLead.Comments__c = infoTextArea;
                
                //Set Participated__c to true to event date
                aLead.Participated__c = true;
                
                insert aLead;
                
                
                //Load necesary fields to send the email if Lead creation is successfull 
                System.debug('====> aLead '+aLead);
                if (aLead.Id != null){
                    
                    System.debug('vfVersion: ' + vfVersion);
                    vfVersion = apexpages.currentPage().getParameters().get('vfVersion');
                    System.debug('vfVersion: ' + vfVersion);
                    /*
                    this.studentName = firstName + ' ' + lastName;
                
                    String qrCodeLink = 'https://cduk--c.ap4.visual.force.com/apex/processLead?lid='+aLead.Id;
                    String messageBody = '<html><body>Dear '+this.studentName+','+   
                                            '<br><br>Thank you for registering for '+this.campaignName+
                                            '<br>Please note the event will be held on <b>'+this.startDate.format('MMMMM dd, yyyy')+ '</b> from <b>'+this.duration+ '</b> at the <b>'+this.eventLocation+
                                            '</b><br><br> Entrance is Free! <br><br> Please bring a copy of this email or show this email for fast and easy access to the event. (Registration at the event is not required).'+
                                            '<br> Please also bring all your Academic Documents for a free Assessment in order to obtain Scholarships and Offers on the Spot from the University Representatives.'+
                                            '<br><br> We look forward to seeing you at the event:'+
                                            '<br><br> <img src="http://api.qrserver.com/v1/create-qr-code/?size=75x75&qzone=1&data='+qrCodeLink+ '" alt="Logo"/>'+
                                            '<br><br> Best Regards,'+
                                            '<br> Campus Direct'+
                                            '<br><br><b>Level 2,</b><br><b>No: 110, Elvitigala Mawatha,</b><br><b>Colombo 08</b>'+
                                            '<br><br> <b>Tel:</b>  (0094) 114 545055 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b>Fax:</b>  (0094) 112 682727'+
                                            '<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (0094) 114 545056 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Website:</b> www.cduk.lk '+
                                            '</body></html>';
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
                    */
                    
                    clearForm();
                    this.showSuccess = true;
                
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
            throw new applicationException('A Lead Student was already created for the same Email');
            //this.errorMsg = 'A Student record was already created for this email address. Please use different email or contact us!';
            //this.showError = true;
            //return false;
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
    
    public class leadWrapper {
        
    }
    
    

}