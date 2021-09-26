public class CD_WOD_MassEmailController 
{
    @AuraEnabled
    public static List<CampaignWrapper> getCampaignList()
    {
        List<CampaignWrapper> returnList = new List<CampaignWrapper>();        
        try{
            for(Campaign cmp : [SELECT id,Name,StartDate FROM Campaign WHERE StartDate > TODAY ORDER BY StartDate]){
                CampaignWrapper c_wrap = new CampaignWrapper();
                c_wrap.CampaignId = cmp.id;
                Datetime dt = (Datetime)cmp.StartDate; 
                c_wrap.CampaignName = cmp.Name + ' - ' + dt.format('MMMMM dd, yyyy');
                
                returnList.add(c_wrap);
            }  
        }
        catch(Exception e){
            System.debug('ERROR :: ' + e.getLineNumber());
        }        
        return returnList;
    }
    
    @AuraEnabled
    public static List<EmailTemplate> getEmailTemplates()
    {
        try{
            return [SELECT Id,Name,Folder.Name FROM EmailTemplate WHERE IsActive = true AND Folder.Name = 'CD Email Templates'];    
        }
        catch(Exception e){
            return new List<EmailTemplate>();
        }        
    }
    
    @AuraEnabled
    public static List<ContentVersion> getExistingFiles()
    {
        try{
            return [SELECT Id,Title FROM ContentVersion WHERE FileExtension = 'pdf']; 
        }
        catch(Exception e)
        {
            System.debug('getExistingFiles ' + e.getLineNumber());
            return new List<ContentVersion>();
        }        
    }
    
    @AuraEnabled
    public static JobFeedback sendCampaignReminders(String campaignId, String scheduleDate)
    {
        JobFeedback feedback = new JobFeedback();
        String returnString = '';
        try{            
            String cron_trigger =  CD_WOD_MassEmail_Util.getCronTrigger(scheduleDate);           
            CD_WOD_SendCampaignReminder massEmail = new CD_WOD_SendCampaignReminder();   
            massEmail.campaignId = campaignId;
            returnString = system.schedule('Mass Email Reminder - ' + String.valueOf(System.now()), cron_trigger, massEmail);
            feedback.jobId = returnString;
            feedback.success = true;
        }
        catch(Exception e){
            returnString = e.getMessage();
            feedback.jobId = returnString;
            feedback.success = false;
        }        
        return feedback;
    }
    
    @AuraEnabled
    public static JobFeedback sendNewsLetters(String templateId, String scheduleDate, String RecordIds, String documentId)
    {
        JobFeedback feedback = new JobFeedback();
        String returnString = '';
        try{
            List<id> selectedRecords = RecordIds.split(',');
            documentId = documentId != '0' ? documentId : null;
            if(selectedRecords != null && selectedRecords.size() > 0){
                String objectType = CD_WOD_MassEmail_Util.checkObjectType(selectedRecords.get(0));
                returnString = String.valueOf(selectedRecords.size()) ;
                if(!String.isEmpty(objectType) && objectType == 'Account'){
                    String cron_trigger =  CD_WOD_MassEmail_Util.getCronTrigger(scheduleDate);           
                    CD_WOD_MassEmailScheduler massEmail = new CD_WOD_MassEmailScheduler();   
                    massEmail.campaignId = null;
                    massEmail.attachmentId = documentId;
                    massEmail.idList = selectedRecords;
                    massEmail.templateId = templateId;
                    massEmail.objType = 'Account';
                    returnString = system.schedule('Mass Email - News Letter - Account '+ System.now(), cron_trigger, massEmail);
                    feedback.jobId = returnString;
                    feedback.success = true;
                }else if(!String.isEmpty(objectType) && objectType == 'Lead__c'){
                    String cron_trigger =  CD_WOD_MassEmail_Util.getCronTrigger(scheduleDate);           
                    CD_WOD_MassEmailScheduler massEmail = new CD_WOD_MassEmailScheduler();   
                    massEmail.campaignId = null;
                    massEmail.attachmentId = documentId;
                    massEmail.idList = selectedRecords;
                    massEmail.templateId = templateId;
                    massEmail.objType = 'Lead__c';
                    returnString = system.schedule('Mass Email - News Letter - Lead '+ System.now(), cron_trigger, massEmail);
                    feedback.jobId = returnString;
                    feedback.success = true;
                }
            }  
        }
        catch(Exception e){
            returnString = e.getMessage(); 
            feedback.jobId = returnString;
            feedback.success = false;
        }        
        return feedback;
    }
    
    @AuraEnabled
    public static JobFeedback sendEventReminders(String templateId, String scheduleDate, String RecordIds, String campaignId)
    {
        JobFeedback feedback = new JobFeedback();
        String returnString = '';
        try{
            campaignId = campaignId != '0' ? campaignId : null;
            List<id> selectedRecords = RecordIds.split(',');
            System.debug('Recode List Size :: ' + selectedRecords.size());
            if(selectedRecords != null && selectedRecords.size() > 0){
                String objectType = CD_WOD_MassEmail_Util.checkObjectType(selectedRecords.get(0));
                if(!String.isEmpty(objectType) && objectType == 'Account'){
                    String cron_trigger =  CD_WOD_MassEmail_Util.getCronTrigger(scheduleDate);           
                    CD_WOD_MassEmailScheduler massEmail = new CD_WOD_MassEmailScheduler();   
                    massEmail.campaignId = campaignId;
                    massEmail.attachmentId = null;
                    massEmail.idList = selectedRecords;
                    massEmail.templateId = templateId;
                    massEmail.objType = 'Account';
                    returnString = system.schedule('Mass Email - Event Details - Account '+ System.now(), cron_trigger, massEmail);
                    feedback.jobId = returnString;
                    feedback.success = true;
                }else if(!String.isEmpty(objectType) && objectType == 'Lead__c'){
                    String cron_trigger =  CD_WOD_MassEmail_Util.getCronTrigger(scheduleDate);           
                    CD_WOD_MassEmailScheduler massEmail = new CD_WOD_MassEmailScheduler();   
                    massEmail.campaignId = campaignId;
                    massEmail.attachmentId = null;
                    massEmail.idList = selectedRecords;
                    massEmail.templateId = templateId;
                    massEmail.objType = 'Lead__c';
                    returnString = system.schedule('Mass Email - Event Details - Lead '+ System.now(), cron_trigger, massEmail);
                    feedback.jobId = returnString;
                    feedback.success = true;
                }
            }   
        }
        catch(Exception e){
            returnString = e.getMessage() + e.getLineNumber();
            feedback.jobId = returnString;
            feedback.success = false;
        }
        return feedback;
    }
    
    public class CampaignWrapper
    {
        @AuraEnabled
        public String CampaignId;
        @AuraEnabled
        public String CampaignName;
    }
    
    public class JobFeedback
    {
        @AuraEnabled
        public String jobId;
        @AuraEnabled
        public Boolean success;
    }
}