public class VCF_ProcessLeadRecords 
{
    public List<Lead__c> selectedLeads;
    public String leadIds;
    
    // Constructor
    public VCF_ProcessLeadRecords(ApexPages.StandardSetController cntlr){
        selectedLeads = cntlr.getSelected(); //get selected records from account list view
        leadIds = '';  
        for(Lead__c lead : selectedLeads){
            leadIds += lead.Id + ','; //build list of ids string concatenated with comma                         
        }
        leadIds = leadIds.removeEnd(','); 
    } 
    
    public PageReference redirectToLC(){
        String returnUrl = '/lightning/cmp/c__ProcessListView?c__listofAccounts='+leadIds;
        PageReference pgReturnPage = new PageReference(returnUrl);
        pgReturnPage.setRedirect(true);
        return pgReturnPage;
    }
}