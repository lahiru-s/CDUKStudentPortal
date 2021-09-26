@isTest
public class InvoiceHeaderPDFGeneratorCtrlr_Test {
    /* To get University Invoice Record Type */
    public Static Id universityRecordTypeId = Schema.SObjectType.Invoice_Header__c.getRecordTypeInfosByName().get('University Invoice').getRecordTypeId();
    testMethod
    public static void saveAsPDF_test() {
        University__c univ = new University__c(
            Name                    = 'University',
            DoPaymentAfterVisa__c   = TRUE,
            IsReady__c              = TRUE,
            Currency_Type__c	    = 'AED'
        );       
        INSERT univ;
        
        Invoice_Header__c header = new Invoice_Header__c();
        header.University__c     = univ.Id;
        header.Subject__c        = 'Test Subject';
        header.Start_Date__c 	 = date.parse('09/07/2018');
        header.End_Date__c		 = date.parse('09/07/2018');
        header.RecordTypeId		 = universityRecordTypeId;
        INSERT header;
        
        String result = InvoiceHeaderPDFGeneratorCtrlr.saveAsPDF( header.Id );
        
        System.assertEquals( TRUE, result.contains( 'success' ) );
    }
    
    testMethod
    public static void saveAsPDF_error_test() {
        String result = InvoiceHeaderPDFGeneratorCtrlr.saveAsPDF( NULL );
        
        System.assertEquals( TRUE, !result.contains( 'success' ) );
    }
}