/**************************************************************
* Description       : Controller class for process Lead
* @author           : Lahiru Subasinghe
* @since            : February 24, 2018
***************************************************************/

public class CD_ProcessLeadController {
    
    public Boolean showError { get; set; }
    public Boolean showSuccess { get; set; }
    public String errorMsg { get; set; }
    public String email { get; set; }
    public String phoneNumber { get; set; }
    
    
    public CD_ProcessLeadController(){}
    
    public void updateLeadRecord(){
        
        try{
            String leadId = System.currentPageReference().getParameters().get('lid');
            system.debug('===> leadId'+leadId);
            if (leadId != null && leadId != ''){
                Lead__c leadToUpdate = [Select Id, Name, Participated__c From Lead__c Where Id = :leadId];
            
                system.debug('===> lead'+leadToUpdate.Id);
                
                if (leadToUpdate != null){
                    leadToUpdate.Participated__c = true;
                    
                    upsert leadToUpdate;
                }
                
                this.showSuccess = true;
            }        
        }catch(exception ex){
            System.debug('Error connecting to the Lead: '+ex.getMessage());
            this.errorMsg = 'There are some issues updating the Lead. Please use the form instead!';
            this.showError = true;
        }
        
    }
    
    
    public void saveLead(){
        
        try{
            List<Lead__c> leadToUpdte = new List<Lead__c>();
            String phoneToquery = '%' + this.phoneNumber + '%';
            
            if (this.email != ''){
                leadToUpdte = [Select Id, Name, Participated__c, Email__c, Mobile__c From Lead__c Where Email__c =:this.email.trim()];
                System.debug('leadToUpdte::'+leadToUpdte);
            }
            
            System.debug('==> leadToUpdte ::'+leadToUpdte);
            
            if (this.phoneNumber != '' && leadToUpdte.isEmpty()){
                
                leadToUpdte = [Select Id, Name, Participated__c, Email__c, Mobile__c From Lead__c Where Mobile__c LIKE :phoneToquery];
            }
            
            if (!leadToUpdte.isEmpty()){
                
                leadToUpdte[0].Participated__c = true;
                
                upsert leadToUpdte;
                this.showSuccess = true;
            }else{
                this.errorMsg = 'There is no matching records for the given Email and Mobile!';
                this.showError = true;
            }    
            
            
        }catch(Exception e2){
            
            System.debug('Error updating the Lead : '+e2.getMessage());
            this.errorMsg = 'There are some issues updating the Lead. Please manually update the Lead!';
            this.showError = true;
        }
    }
    
    public void clearForm(){
        
        this.email = '';
        this.phoneNumber = '';
    }
    
    public void closeNotification(){
        
        this.showSuccess = false;
        this.showError = false;
        
        clearForm();
    }
    
    
    

}