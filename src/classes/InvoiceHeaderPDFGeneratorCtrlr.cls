/*

Created By :- Arulmozhi.R
Description:- This Class is to  Generate PDF

*/

public class InvoiceHeaderPDFGeneratorCtrlr {
    public InvoiceHeaderPDFGeneratorCtrlr( ApexPages.StandardController ctrlr ) {}
    
    /**
     * Use the getContentAsPDF() method on the
     * InvoiceHeaderPDF page to generate the
     * PDF and associate the same with the
     * Invoice Header record.
     * 
     * @param       invoiceHeaderId     Invoice Header Id
     * 
     * @return      {String}            Result of the operation
     */
    @RemoteAction
    public static String saveAsPDF( String invoiceHeaderId ) {
        try {
            PageReference pdf = Page.InvoiceHeaderPDF;
            pdf.getParameters().put( 'id', invoiceHeaderId );
            
            Invoice_Header__c header = [
                SELECT  Name
                        ,PDF_File_Version_Number__c
                FROM    Invoice_Header__c
                WHERE   Id = :invoiceHeaderId
            ];
            
            header.PDF_File_Version_Number__c = header.PDF_File_Version_Number__c == NULL ? 1 : header.PDF_File_Version_Number__c + 1;
            UPDATE header;
                
            Attachment att = new Attachment();
            att.Name        = 'Invoice - ' + header.Name + '_v' + header.PDF_File_Version_Number__c + '.pdf';
            att.Contenttype = 'application/pdf';
            att.Body        = Test.isRunningTest() ? Blob.valueOf( 'Test Data' ) : pdf.getContentAsPDF();
            att.ParentId    = invoiceHeaderId;
            INSERT att;
            
            return 'Invoice have been saved successfully.';
        }
        catch( Exception ex ) { return 'Sorry! Couldn\'t save the Invoice due to an error. Error:' + ex.getMessage(); }
    }
}