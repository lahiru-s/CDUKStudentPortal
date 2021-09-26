global class CD_WOD_SendCampaignReminder implements Schedulable {
    public String campaignId{get;set;}
    
    global void execute(SchedulableContext SC) {
        this.sendMassEmail();
    }
    
    global void sendMassEmail()
    {
        //prepare list
        
        List<Lead__c> leadList = [Select Id, Name, Campaign__c, Migrated_FB_Lead__c, Email__c, First_Name__c, Last_Name__c From Lead__c Where Campaign_Email_Triggered__c = true AND Campaign__c= :campaignId];

        //prepare camp related record
        
        Map<Id, Campaign> campMap = new Map<Id, Campaign>([Select Id, Name, StartDate, EndDate, Duration__c, Location__c From Campaign Where Id = :campaignId]);

        //prepare camp to Lead records
        
        Map<Id, List<Lead__c>> campToLeadMap = new Map<Id, List<Lead__c>>();
        
        campToLeadMap.put(campaignId, leadList);
        
        List<Mass_Email_Addresses__c> emailAddresses = [SELECT Name,Email_Value__c FROM Mass_Email_Addresses__c WHERE Name = :CD_WOD_MassEmail_Util.CD_FROM_EMAIL_HELLO];        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :emailAddresses.get(0).Email_Value__c];
        id OrgWideId = owea.size() > 0 ? owea.get(0).Id : '';

        //Calling util classes
        
        CD_WOD_WebToLeadServiceController ctrl = new CD_WOD_WebToLeadServiceController();
        
        CD_EmailServicesUtil utilClass = new CD_EmailServicesUtil();

        List<EmailServiceDTO> esList = ctrl.prepareEmailServiceWrapper(campMap, campToLeadMap);

        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

        for (EmailServiceDTO es: esList){
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              
            String qrCodeLink = 'https://cduk--c.ap4.visual.force.com/apex/processLead?lid='+es.leadRecord.Id;
            
            String messageBody = '<html><body>Dear '+es.leadRecord.Name+','+  
                
                '<br><br>Thank you for Pre-registering for '+es.campaignName+
                
                '<br>We look forward to meeting you tomorrow <b>'+es.campaignStartDate.format('MMMMM dd, yyyy')+ '</b> from <b>'+es.campaignDuration+ '</b> at the <b>'+es.campaignLocation+
                
                '</b><br><br> Please bring a copy of this email or show this email for fast and easy access to the event. (Registration at the event is not required).'+
                
                '<br> Please also bring all your Academic Documents for a free Assessment in order to obtain Scholarships and Offers on the Spot from the University Representatives.'+
                
                '<br><br> All of our services including the Application Process & Visa Process is Free of Charge!'+
                
                '<br><br> We look forward to seeing you at the event tomorrow! '+
                
                '<br><br> <img src="http://api.qrserver.com/v1/create-qr-code/?size=75x75&qzone=1&data='+qrCodeLink+ '" alt="Logo"/>'+
                
                '<br><br> Best Regards,'+
                
                '<br> Campus Direct'+
                
                '<br><br><b>Level 2,</b><br><b>No: 110, Elvitigala Mawatha,</b><br><b>Colombo 08</b>'+
                
                '<br><br> <b>Tel:</b>  (0094) 114 545055 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b>Fax:</b>  (0094) 112 682727'+
                
                '<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (0094) 114 545056 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Website:</b> www.cduk.lk '+
                
                '</body></html>';
            
            String subject = 'Thank you for Pre-registering for '+es.campaignName;

            mail.setToAddresses(es.emailTo);
            
            mail.setSaveAsActivity(false);
            
            mail.setSubject(subject);
            
            mail.setHtmlBody(messageBody);
            
            mail.setOrgWideEmailAddressId(OrgWideId);      
            
            emailList.add(mail);
        }
        
        
        if (!emailList.isEmpty()){            
           Messaging.sendEmail(emailList);       
        }
    }
}