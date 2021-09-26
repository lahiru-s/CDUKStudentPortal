public class InvoiceItemsExt {
    
    
    @AuraEnabled
    public static List<Invoice_Item__c> getInvoiceItems(Id recordId){
        List<Invoice_Item__c> itemsList =   [SELECT Id,Invoice_Header__c,Description__c FROM Invoice_Item__c Where Invoice_Header__c =: recordId];        
        return itemsList;
    }
    
    
}