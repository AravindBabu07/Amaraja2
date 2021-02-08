({
	handleRecordUpdated  : function(cmp, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
		 var action = cmp.get("c.sendDoc");
        var record = cmp.get('v.woRecord');
        action.setParams({ conId : record.ContactId, recId:record.Id, sendEmail:false });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.showSpinner', false);
                cmp.set('v.Message', 'Installation Commission Report has been generated succesfully.');
                /*setTimeout(function(){
                    	var closequickAction = $A.get("e.force:closeQuickAction");
                        closequickAction.fire();
                        var navEvt = $A.get("e.force:navigateToSObject");
                    	navEvt.setParams({
                  			"recordId": record.Id,
                        });
                    navEvt.fire();
                },2000);*/
               
            }
        });
       $A.enqueueAction(action);  
        }
    },
    
    
    
})