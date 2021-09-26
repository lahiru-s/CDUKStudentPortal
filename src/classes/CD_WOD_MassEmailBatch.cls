global class CD_WOD_MassEmailBatch implements Database.Batchable<sObject> {
    
    global List<String> idList{get;set;}
    global String objType{get;set;}
    global String templateId{get;set;}
    global String campaignId{get;set;}
    global String attachmentId{get;set;}
    global List<CD_WOD_MassEmail_Util.MassEmailWrapper> massEmailWrappers{get;set;}
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String dbQuery = CD_WOD_MassEmail_Util.getDataBaseQueryString(idList);
        return Database.getQueryLocator(dbQuery);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope)
    {
        if(this.objType == 'Account')
        {
            this.massEmailWrappers = CD_WOD_MassEmail_Util.CreateMassEmailWrapper_Account(this.templateId, this.campaignId, scope);
            sendMassEmail();
        }
        else
        {
            this.massEmailWrappers = CD_WOD_MassEmail_Util.CreateMassEmailWrapper_Lead(this.templateId, this.campaignId, scope);
            sendMassEmail();
        }
    }
    
    global void sendMassEmail()
    {        
        List<Messaging.SingleEmailMessage> readyToSend = new List<Messaging.SingleEmailMessage>();
        
        for(CD_WOD_MassEmail_Util.MassEmailWrapper wrap : massEmailWrappers){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            if(attachmentId != null && attachmentId != ''){
                email.setEntityAttachments(new list<String>{attachmentId});
            }
            
            System.debug('body ' + wrap.htmlBody);
            
            email.setToAddresses(new String[] { wrap.toAddress });            
            email.setSaveAsActivity(false);            
            email.setSubject(wrap.emailSubject);            
            email.setHtmlBody(wrap.htmlBody);            
            email.setOrgWideEmailAddressId(wrap.fromAddress);    
            readyToSend.add(email);
        }
        
        if (!readyToSend.isEmpty()){            
            Messaging.sendEmail(readyToSend);       
        }
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id =
                          :BC.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'sankavimukthi@gmail.com','lahirus@outlook.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Mass Email Batch Processing ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
       // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }    
}