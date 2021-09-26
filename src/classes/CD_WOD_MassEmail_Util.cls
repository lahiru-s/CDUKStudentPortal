public class CD_WOD_MassEmail_Util 
{
    public static final String CD_FROM_EMAIL_HELLO = 'default_Hello';
        
    public static String getCronTrigger(String scheduleDate)
    {
        Datetime scheduleTime = (DateTime)JSON.deserialize('"' + scheduleDate + '"', DateTime.class);
        Integer s_day = scheduleTime.day();
        Integer s_hour = scheduleTime.hour();
        Integer s_min = scheduleTime.minute();
        Integer s_month = scheduleTime.month();
        Integer s_year = scheduleTime.year();
        
        String cron_trigger = '0 ' + ' ' + s_min + ' ' + s_hour + ' ' + s_day + ' ' + s_month + ' ? ' + ' ' + s_year ;
        
        return cron_trigger;
    }
    
    public static String checkObjectType(Id objectId)
    {
        String objectType = '';        
        if(objectId != null){
            objectType = String.valueOf(objectId.getSobjectType());
        }        
        return objectType;
    }
    
    public static List<MassEmailWrapper> CreateMassEmailWrapper_Account(String templateId, String campaignId, List<Account> accounts)
    {
        List<MassEmailWrapper> returnList = new List<MassEmailWrapper>();
        
        List<Mass_Email_Addresses__c> emailAddresses = [SELECT Name,Email_Value__c FROM Mass_Email_Addresses__c WHERE Name = :CD_FROM_EMAIL_HELLO];
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :emailAddresses.get(0).Email_Value__c];
        
        List<EmailTemplate> selectedTemplate = [SELECT Id,Name,Body,HtmlValue,Subject FROM EmailTemplate WHERE id = :templateId];
        
        String emailBody = selectedTemplate.get(0).HtmlValue;
        String emailSubject = selectedTemplate.get(0).Subject;
        
        if(campaignId != null){
            List<Campaign> campaign = new List<Campaign>();
            campaign = getDataBaseQuery(new List<String>{campaignId});    
            List<String> campaignFields = getAllFields(campaign.get(0).Id);
            emailBody = replaceEmailBody(campaign.get(0),'Campaign',emailBody, campaignFields);
            //Replace subject merge fields
            emailSubject = replaceEmailBody(campaign.get(0),'Campaign',emailSubject, campaignFields);
        }
        
        List<String> accountFields = getAllFields(accounts.get(0).Id);
        
        for(Account acc : accounts){
            if(!acc.Opt_out__c){
                MassEmailWrapper mewrap = new MassEmailWrapper();
                mewrap.toAddress = acc.Email__c;
               	mewrap.fromAddress = owea.size() > 0 ? owea.get(0).Id : 'suresh@cduk.lk';
                mewrap.recipientName = acc.Name;
                mewrap.emailSubject = replaceEmailBody(acc,'Account',emailSubject, accountFields).replace(' 00:00:00', ''); 
                mewrap.htmlBody = replaceEmailBody(acc,'Account',emailBody, accountFields).replace(' 00:00:00', '');            
                returnList.add(mewrap); 
            }            
        }
        
        return returnList;
    }
    
    public static List<MassEmailWrapper> CreateMassEmailWrapper_Lead(String templateId, String campaignId, List<Lead__c> leads)
    {
        List<MassEmailWrapper> returnList = new List<MassEmailWrapper>();
        
        List<Mass_Email_Addresses__c> emailAddresses = [SELECT Name,Email_Value__c FROM Mass_Email_Addresses__c WHERE Name = :CD_FROM_EMAIL_HELLO];
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :emailAddresses.get(0).Email_Value__c];
        
        List<EmailTemplate> selectedTemplate = [SELECT Id,Name,Body,HtmlValue,Subject FROM EmailTemplate WHERE id = :templateId];
        
        String emailBody = selectedTemplate.get(0).HtmlValue;
        String emailSubject = selectedTemplate.get(0).Subject;
        
        if(campaignId != null){
            List<Campaign> campaign = new List<Campaign>();
            campaign = getDataBaseQuery(new List<String>{campaignId});    
            List<String> campaignFields = getAllFields(campaign.get(0).Id);
            emailBody = replaceEmailBody(campaign.get(0),'Campaign',emailBody, campaignFields);
            //Replace subject merge fields
            emailSubject = replaceEmailBody(campaign.get(0),'Campaign',emailSubject, campaignFields);
        }
        
        List<String> leadFields = getAllFields(leads.get(0).Id);
        
        for(Lead__c led : leads){
            if(!led.Opt_out__c){
                MassEmailWrapper mewrap = new MassEmailWrapper();
                mewrap.toAddress = led.Email__c;
                mewrap.fromAddress = owea.size() > 0 ? owea.get(0).Id : 'suresh@cduk.lk';
                mewrap.recipientName = led.Name;
                mewrap.emailSubject = replaceEmailBody(led,'Lead__c',emailSubject, leadFields).replace(' 00:00:00', '');
                mewrap.htmlBody = replaceEmailBody(led,'Lead__c',emailBody, leadFields).replace(' 00:00:00', '');            
                returnList.add(mewrap); 
            }            
        }        
        return returnList;
    }
    
    public static List<sObject> getDataBaseQuery(List<String> idList)
    {
        Id rId = idList.get(0);
        
        DescribeSObjectResult describeResult = rId.getSObjectType().getDescribe();      
        Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
        
        // Get all of the fields on the object
        List<String> fieldNames = new List<String>();
        fieldNames.addAll(fieldMap.keySet());
        
        // Build a Dynamic Query String.
        String soqlQuery = ' SELECT ' + string.join(fieldNames, ',') + ' FROM ' + describeResult.getName() + ' Where Id IN: idList';
        
        List<sObject> returnList = Database.query(soqlQuery);
        
        return returnList;
    }
    
    public static String getDataBaseQueryString(List<String> idList)
    {
        Id rId = idList.get(0);
        
        DescribeSObjectResult describeResult = rId.getSObjectType().getDescribe();      
        Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
        
        // Get all of the fields on the object
        List<String> fieldNames = new List<String>();
        fieldNames.addAll(fieldMap.keySet());
        
        // Build a Dynamic Query String.
        String soqlQuery = ' SELECT ' + string.join(fieldNames, ',') + ' FROM ' + describeResult.getName() + ' Where Id IN: idList ';
        
        return soqlQuery;
    }
    
    public static String replaceEmailBody(sObject obj, String objName, String template, List<String> fields)
    {      
        system.debug(' :: template :: '+template);
        for(String field : fields){
            String key = '{!' + objName + '.' + field + '}';           
            
            while (template.containsIgnoreCase(key)) {
                try {
                    Integer foundPosition = template.indexOfIgnoreCase(key, 0);
                    template = template.left(foundPosition) +
                        String.valueOf(obj.get(field)) +
                        template.substring(foundPosition + key.length());
                } catch (Exception e) {
                    System.debug('Error Creating Template ' + e.getMessage());
                }
            }
        }      
        return Template;
    }
    
    public static List<String> getAllFields(Id objectId)
    {
        DescribeSObjectResult describeResult = objectId.getSObjectType().getDescribe();      
        Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
        
        // Get all of the fields on the object
        List<String> fieldNames = new List<String>();
        fieldNames.addAll(fieldMap.keySet());
        
        return fieldNames;
    }
    
    public class MassEmailWrapper
    {
        public String toAddress{get;set;}
        public String targetObjectId{get;set;}
        public String fromAddress{get;set;}
        public String whatId{get;set;}
        public String templateId{get;set;}
        public String recipientName{get;set;}
        public String emailSubject{get;set;}
        public String htmlBody{get;set;}
    }    
}