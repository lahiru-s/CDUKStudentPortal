public class LeadHelper{

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
                es.campaignVirtualInfo = cmpMap.get(cmpId).Virtual_Meeting_Info__c;
                es.campaignEndDate = cmpMap.get(cmpId).EndDate;
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