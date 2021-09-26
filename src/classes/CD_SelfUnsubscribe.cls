/**************************************************************
* Description       : Controller class for Self Unsubscribe
* @author           : Lahiru Subasinghe
* @since            : May 31, 2020
***************************************************************/

public class CD_SelfUnsubscribe {
    
    public Boolean showError { get; set; }
    public Boolean showSuccess { get; set; }
    public String errorMsg { get; set; }
        
    public CD_SelfUnsubscribe(){}  
    
    public void saveRecord(){
        
        try{
            List<sObject> recsToUpdate = new List<sObject>();
            string emailAdrs = System.currentPageReference().getParameters().get('email');           
            
            String searchQuery = 'FIND \'' + emailAdrs + '\' IN ALL FIELDS RETURNING  Account(Id, Opt_out__c), Lead__c(Id, Opt_out__c)';            
            List<List<sObject>> searchList = search.query(searchQuery);
            
            List<Account> accList = ((List<Account>)searchList[0]); 
            List<Lead__c> leadList = ((List<Lead__c>)searchList[1]);               
           
            
            if (accList.size() > 0){
                Account accRec = new Account(id=accList[0].Id, Opt_out__c=true);
                recsToUpdate.add(accRec);
            }
                
            if (leadList.size() > 0){
                Lead__c leadRec = new Lead__c(id=leadList[0].id, Opt_out__c=true);
                recsToUpdate.add(leadRec);
            }
            
            if (recsToUpdate.size() > 0)
                update recsToUpdate;
            
            /*
            if (emailType.contains('Lead')){
                Lead__c leadRec = new Lead__c(id=recId, Opt_out__c=true);
                upsert leadRec;
            }else{
                 Account accRec = new Account(id=recId, Opt_out__c=true);
                 upsert accRec;
            }
            */
            this.showSuccess = true;           
            
            
        }catch(Exception e2){
            
            System.debug('Error updating the Lead : '+e2.getMessage());
            this.errorMsg = 'There are some issues updating the Lead. Please manually update the Lead!';
            this.showError = true;
        }
    }   
    
    
    public void closeNotification(){
        
        this.showSuccess = false;
        this.showError = false;
        
        
    }
    

    

}