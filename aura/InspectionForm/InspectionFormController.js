({
	handleSuccess : function(component, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": "Success!",
        "message": "The property's info has been updated.",
        "type": "success"
    });
    toastEvent.fire();
    //helper.showHide(component);
},
    handlequickAction:function(component, event, helper) {
        console.log('closequickAction');
        var recId = component.get("v.recordId");
        /*setTimeout(function(){
            var closequickAction = $A.get("e.force:closeQuickAction");
            closequickAction.fire();
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": recId,
            });
            navEvt.fire();
        },2000);*/
    }
})