({
    populateData : function(cmp) {
        var action_camp = cmp.get("c.getCampaignList");
        var action_email = cmp.get("c.getEmailTemplates");
        var action_file = cmp.get("c.getExistingFiles");
        
        action_camp.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.availableCampaigns",response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        action_email.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.availableTemplates",response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        action_file.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.availableFiles",response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action_camp);
        $A.enqueueAction(action_email);
        $A.enqueueAction(action_file);
    },
    
    callCampaignReminder: function(cmp, scheduleDate, campaignId) {
        var action = cmp.get("c.sendCampaignReminders");
        action.setParams({ campaignId : campaignId,
                          scheduleDate : scheduleDate});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().success == true){
                    this.showToast(cmp, 'success', 'Keep this Job Id with you - ' + response.getReturnValue().jobId);
                }else{
                    this.showToast(cmp, 'error', response.getReturnValue().jobId);
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    callNewsLetter: function(cmp, scheduleDate, emailTemplateId, slectedFileId) {        
        var action = cmp.get("c.sendNewsLetters");
        action.setParams({ templateId : emailTemplateId,
                          scheduleDate : scheduleDate,
                          RecordIds : cmp.get("v.selectedIds"),
                          documentId : slectedFileId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().success == true){
                    this.showToast(cmp, 'success', 'Keep this Job Id with you - ' + response.getReturnValue().jobId);
                }else{
                    this.showToast(cmp, 'error', response.getReturnValue().jobId);
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    callEventReminder: function(cmp, scheduleDate, emailTemplateId, selectedEvent) {
        var action = cmp.get("c.sendEventReminders");
        action.setParams({ templateId : emailTemplateId,
                          scheduleDate : scheduleDate,
                          RecordIds : cmp.get("v.selectedIds"),
                          campaignId : selectedEvent});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().success == true){
                    this.showToast(cmp, 'success', 'Keep this Job Id with you - ' + response.getReturnValue().jobId);
                }else{
                    this.showToast(cmp, 'error', response.getReturnValue().jobId);
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    showToast : function(component, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": type == 'error' ? 'Error!' : 'Success!',
            "message": message,
            "mode" : "sticky",
            "type" : type
        });
        toastEvent.fire();
    },
    
    checkDateValidity : function(component, event, helper){
        var selected_time = component.get("v.selectedScheduleTime");
        if($A.util.isEmpty(selected_time)){
            helper.showToast(component, 'error', 'Please select a valid date and time');
            return false;
        }else{
            var selectedTime = new Date(selected_time);
            if(selectedTime <= Date.now()){
                helper.showToast(component, 'error', 'Please select a valid date and time');
                return false;
            }else{
                return true;
            }
        }
    },
    
    disableDiv : function(component,event, helper){
        
        //alert(component.get("v.selectedIds"));
        if(component.get("v.selectedIds") == ''){
            var newsdiv = component.find('newsletterDiv');
            var eventdiv = component.find('eventsDiv');
            $A.util.addClass(newsdiv, 'disabledDiv');
            $A.util.addClass(eventdiv, 'disabledDiv');
            helper.showToast(component, 'error', 'No Leads or Students selected');
        }
    }
})