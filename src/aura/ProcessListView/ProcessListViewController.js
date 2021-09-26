({
    doInit : function(component, event, helper) {
        var pageRef = component.get("v.pageReference");
        var selectedIds = pageRef.state.c__listofAccounts;
        component.set("v.selectedIds",selectedIds);
        helper.populateData(component);
    },
    
    setSection: function(component, event, helper) {
        component.set("v.isCampaign", false);
        component.set("v.isNewsLetter", false);
        component.set("v.isEvent", false);
        
        component.set("v.selectedScheduleTime","");        
        
        if(event.getParam('value') == '1'){
            component.set("v.isCampaign", true);
        }
        else if(event.getParam('value') == '2'){
            component.set("v.isNewsLetter", true);
            helper.disableDiv(component, event, helper);
        }
            else if(event.getParam('value') == '3'){
                component.set("v.isEvent", true);
                 helper.disableDiv(component, event, helper);
            }        
    },
    
    openModal: function(component, event, helper) {
        if(!helper.checkDateValidity(component, event, helper)){
            return;
        }
        component.set("v.showModal", true);
    },
    
    closeModal: function(component, event, helper) {
        component.set("v.showModal", false);
    },
    
    submitSchedule: function(component, event, helper) {
        var selected_camp = !$A.util.isEmpty(component.find("campaignSelect")) ? component.find("campaignSelect").get("v.value") : '';
        var selected_time = component.get("v.selectedScheduleTime");
        var selected_template = !$A.util.isEmpty(component.find("emailSelect")) ? component.find("emailSelect").get("v.value") : '';
        var selected_event = !$A.util.isEmpty(component.find("eventSelect")) ? component.find("eventSelect").get("v.value") : '';
        var selected_template_event = !$A.util.isEmpty(component.find("emailSelect_event")) ? component.find("emailSelect_event").get("v.value") : ''; 
        var selected_document = !$A.util.isEmpty(component.find("fileSelect")) ? component.find("fileSelect").get("v.value") : '';
        
        if(component.get("v.isCampaign")){
            helper.callCampaignReminder(component,selected_time,selected_camp);
        }
        
        if(component.get("v.isNewsLetter")){
            helper.callNewsLetter(component,selected_time,selected_template,selected_document);
            //alert(selected_document);
        }
        
        if(component.get("v.isEvent")){
            helper.callEventReminder(component,selected_time,selected_template_event,selected_event);
        }
        
        component.set("v.showModal", false);
    },
})