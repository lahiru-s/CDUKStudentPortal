/**************************************************************
* Description       : Email util class
* @author           : Lahiru Subasinghe
* @since            : February 28, 2019
***************************************************************/

global class CD_EmailServicesUtil {
    
    
    public CD_EmailServicesUtil(){}
    
    //Process Email message based on the EmailServiceDTO
    public void CD_sendEmails(List<EmailServiceDTO> esWrapperList){
        
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        
        for (EmailServiceDTO es: esWrapperList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String messageBody='';
            Boolean isVirtualEvent = (es.campaignVirtualInfo != null && es.campaignVirtualInfo != '') ? true : false;           
            
            if (isVirtualEvent){                
                //Build the Virtual Message 
                messageBody = '<html><body>Dear '+es.leadRecord.Name+','+   
                '<br><br>Thank you for registering for '+es.campaignName+
                '<br>Please note the event will be held on <b>'+es.campaignStartDate.format('MMMMM dd, yyyy')+ ' & '+es.campaignEndDate.format('MMMMM dd, yyyy')+ '</b> from <b>'+es.campaignDuration+ '</b> via <b>'+es.campaignLocation+
                '</b><br><br><strong>Meeting Links for the Event</strong>'+
                '<br>'+es.campaignVirtualInfo+                     
                
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
                
                String qrCodeLink = 'https://cduk--c.ap4.visual.force.com/apex/processLead?lid='+es.leadRecord.Id;
                messageBody = '<html><body>Dear '+es.leadRecord.Name+','+   
                    '<br><br>Thank you for registering for '+es.campaignName+
                    '<br>Please note the event will be held on <b>'+es.campaignStartDate.format('MMMMM dd, yyyy')+ '</b> from <b>'+es.campaignDuration+ '</b> at the <b>'+es.campaignLocation+
                    '</b><br><br> Entrance is Free! <br><br> Please bring a copy of this email or show this email for fast and easy access to the event. (Registration at the event is not required).'+
                    '<br> Please also bring all your Academic Documents for a free Assessment in order to obtain Scholarships and Offers on the Spot from the University Representatives.'+
                    '<br><br> We look forward to seeing you at the event!'+            
                    '<br><br> Best Regards,'+
                    '<br> Campus Direct'+
                    '<br><br><b>Head Office</b>'+    
                    '<br>No: 36B, Gower Street,</b><br><b>Colombo 05</b>'+
                    '<br><br><b>Kandy Branch</b>'+    
                    '<br>No: 749, B/1 William Gopallawa Mawatha,</b><br><b>Kandy</b>'+
                    '<br><br> Hotline: (0094) 77 9005555 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Website:</b> www.cduk.lk '+
                    '</body></html>';
                
            }
            

            String subject = 'Thank you for registering for '+es.campaignName;
            
            
            mail.setToAddresses(es.emailTo);
            mail.setSaveAsActivity(false);
            mail.setSubject(subject);
            mail.setHtmlBody(messageBody);
            //mail.setSenderDisplayName = 'Campus Direct';
            mail.setOrgWideEmailAddressId(es.emailFromId);
            
            emailList.add(mail);
        }
        
        if (!emailList.isEmpty()){
            Messaging.sendEmail(emailList);
        }
        
    }

}