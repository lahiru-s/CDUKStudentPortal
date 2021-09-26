/**************************************************************
* Description       : DTO for email wrapper
* @author           : Lahiru Subasinghe
* @since            : February 28, 2019
***************************************************************/

public class EmailServiceDTO {
    
    public String campaignName { get; set; }
    public String campaignLocation { get; set; }
    public String campaignDuration { get; set; }
    public DateTime campaignStartDate { get; set; }
    public DateTime campaignEndDate { get; set; }
    public String campaignVirtualInfo { get; set; }
    public Lead__c leadRecord { get; set; }
    public Id emailFromId { get; set; }    
    public List<String> emailTo { get; set; }
    public List<String> emailToCC { get; set; }

}