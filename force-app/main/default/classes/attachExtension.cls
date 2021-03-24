public class attachExtension {
    private final InvoiceC__c invoiceRecord;
    public attachExtension(ApexPages.StandardController stdController) {
        this.invoiceRecord = (InvoiceC__c)stdController.getRecord();
    }
    public PageReference attachPDF(){
        List<InvoiceC__c> invoices = [Select RecordType.Name, Invoice_ID__c, Course__r.Id from InvoiceC__c WHERE Id = :invoiceRecord.Id];
        InvoiceC__c invoice = invoices[0];
        String partialURL = '/apex/'+invoice.RecordType.Name+'InvoicePDF?id='+invoice.Id;  
        PageReference pdf = new PageReference(partialURL);
        Attachment attachment = new Attachment();
        Blob body;
        body = pdf.getContent();
        attachment.Body = body;
        attachment.Name = 'Invoice: '+invoice.Invoice_ID__c;
        attachment.isPrivate = false;
        attachment.ParentId = invoice.Course__r.Id;
        List<Attachment> oldAttachments = [SELECT Name FROM Attachment WHERE Name = :attachment.Name];
        if(oldAttachments.size() == 0){
            insert attachment;
        }else{
            delete oldAttachments;
            insert attachment;
        }
        return pdf;
    }
}