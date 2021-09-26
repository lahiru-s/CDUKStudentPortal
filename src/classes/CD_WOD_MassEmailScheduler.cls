global class CD_WOD_MassEmailScheduler implements Schedulable 
{
    global List<String> idList{get;set;}
    global String objType{get;set;}
    global String templateId{get;set;}
    global String campaignId{get;set;}
    global String attachmentId{get;set;}
    
    global void execute(SchedulableContext SC) {
        CD_WOD_MassEmailBatch emailBatch = new CD_WOD_MassEmailBatch(); 
        emailBatch.attachmentId = this.attachmentId;
        emailBatch.campaignId = this.campaignId;
        emailBatch.templateId = this.templateId;
        emailBatch.objType = this.objType;
        emailBatch.idList = this.idList;
        Id batchId = Database.executeBatch(emailBatch,50);
    }
    
}