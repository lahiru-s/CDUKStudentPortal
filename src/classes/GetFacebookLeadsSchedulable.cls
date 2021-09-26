global class GetFacebookLeadsSchedulable implements Schedulable {
    global void execute( SchedulableContext sc ) {
        FacebookAPI.getLeads();
    }
}