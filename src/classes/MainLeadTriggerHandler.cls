public  class MainLeadTriggerHandler {
    
    List<String> emailList = new List<String>();
    List<User> usList = [Select id, name, email, username From user where username='suresh@cduk.lk'];
    
    //public void OnAfterInsert(List<Lead__c> newList, Map<Id, Lead__c> oldMap, Map<Id, Lead__c> newMap){
    public void OnAfterInsert(List<Lead__c> newList, Map<Id, Lead__c> newMap){
    
        for (Lead__c ld: newList){
            emailList.add(ld.Email__c);
           // ld.addError('test error');
        }       
        
        Map<ID, Lead__c> leadWithSameEmailMap = new Map<ID, Lead__c>([Select Id, Email__c, Lead_Status__c, Lead_Initiated_Sources__c, Campaign_Name__c, Lead_Source__c, CreatedDate, OwnerId From Lead__c Where Email__c IN: emailList order by createddate ASC]);
        
        Map<String, List<Lead__c>> emailToLeadMap = new Map<String, List<Lead__c>>();
        List<Lead__c> leadList = new List<Lead__c>();
        
        for (Lead__c ld: leadWithSameEmailMap.values()){
            
            List<Lead__c> emailToLeadList = emailToLeadMap.get(ld.Email__c);
            if (emailToLeadList == null){
                emailToLeadList = new List<Lead__c>();
            }
            
            emailToLeadList.add(ld);            
            emailToLeadMap.put(ld.Email__c, emailToLeadList);
        }
        
        system.debug('emailToLeadMap keyset::::'+emailToLeadMap.keySet());
        system.debug('emailToLeadMap values::::'+emailToLeadMap.values());
        List<Lead__c> leadRecordsToUpdate = new List<Lead__c>();
        List<Lead__c> leadRecordsToDelete = new List<Lead__c>();
        Set<String> leadSourceSet;
        List<String> finalLeadSourceList;
        List<String> leadSourceList = new List<String>();
        Lead__c preferredLead;
       
        
        for (String eml: emailToLeadMap.keySet()){  
            
            leadSourceSet = new Set<String>();
            finalLeadSourceList = new List<String>();
            //preferredLead = new Lead__c();
            integer ldCount=0;
           
            
            if (emailToLeadMap.get(eml).size() > 1){
                for (Lead__c ld: emailToLeadMap.get(eml)){
                    
                    ldCount++;
                    
                    if (ld.Lead_Initiated_Sources__c != '' && ld.Lead_Initiated_Sources__c != null){
                        leadSourceSet.addAll(ld.Lead_Initiated_Sources__c.split(' ::: '));
                    }
                    
                    system.debug('leadSourceSet1::'+leadSourceSet);
                    
                    if (ld.Campaign_Name__c != '' && ld.Campaign_Name__c != null){
                        leadSourceSet.add(ld.Campaign_Name__c);
                        //finalLeadSourceList.add(ld.Campaign_Name__c);
                    }else if (ld.Lead_Source__c != '' && ld.Lead_Source__c != null){
                        leadSourceSet.add(ld.Lead_Source__c);
                        //finalLeadSourceList.add(ld.Lead_Source__c);
                    }
                    
                    if (ld.Lead_Status__c != 'New' && preferredLead == null){                        
                        preferredLead = ld;
                        
                    }else{
                        if (emailToLeadMap.get(eml).size() == ldCount && preferredLead == null){
                            preferredLead = ld;
                            
                        }else{
                        	leadRecordsToDelete.add(ld);
                        }
                    }
                }
            }    
            
            system.debug('leadSourceList:::'+leadSourceSet);
            system.debug('leadSourceSet:::'+leadSourceSet);
            
            if (!leadSourceSet.isEmpty()){
                
                leadSourceList.addAll(leadSourceSet);
                preferredLead.Lead_Initiated_Sources__c = string.join(leadSourceList,' ::: ');
                preferredLead.OwnerId = usList[0].Id;
                leadRecordsToUpdate.add(preferredLead);
            }
			
            
            system.debug('leadRecordsToUpdate:::'+leadRecordsToUpdate);
            system.debug('leadRecordsToDelete:::'+leadRecordsToDelete+':::count::'+leadRecordsToDelete.size());
        }
        
        if (!leadRecordsToDelete.isEmpty()){            
            for (Lead__c dLd: leadRecordsToDelete){ 
                dLd.OwnerId = usList[0].Id;
                dLd.Lead_Status__c = 'Deactivated';                
                leadRecordsToUpdate.add(dLd);
            }
            //delete leadRecordsToDelete;   
        }
        
        if (!leadRecordsToUpdate.isEmpty()){
            upsert leadRecordsToUpdate;
        }
        	
        
        
        	  	
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    

}