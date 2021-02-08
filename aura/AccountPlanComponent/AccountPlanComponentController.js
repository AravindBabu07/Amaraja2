({
    doInit: function(component, event, helper) {
        var action = component.get("c.getPlannedActivities");
        action.setParams({
            accId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               component.set("v.AccPlanAct", response.getReturnValue()); 
            }
        });
        $A.enqueueAction(action);
    },
    
    handleAddAccPlan : function(component, event, helper) {
        var accId = component.get("v.recordId");
        var addAccPlanRec = {  'sobjectType' : 'Account_Plan_Activity__c',
                             'Name' : '' ,
                             'Actual_Date__c' : '',
                             'Planned_Date__c' : '',
                             'Status__c' : '',
                             'Account__c' : accId};
        var AccPlanActList = component.get("v.AccPlanAct");
        AccPlanActList.push(addAccPlanRec);
        component.set("v.AccPlanAct", AccPlanActList);
    },
    
    handleSaveAccPlan : function(component, event, helper) {
        var action = component.get("c.savePlannedActivities");
        action.setParams({
            plannedActivities : component.get("v.AccPlanAct"),
            accId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               component.set("v.AccPlanAct", response.getReturnValue()); 
            }
        });
        $A.enqueueAction(action);
    },
    
    handleEditAccPlan : function(component, event, helper) {
        console.log(event.getSource().get("v.value"));
        var acPlan = event.getSource().get("v.value");
        acPlan.InEditMode__c = true;
        var acPlanList = component.get("v.AccPlanAct");
        for (var i = 0; i < acPlanList.length; i++){
            if(acPlan.Id == acPlanList[i].Id){
                acPlanList[i] = acPlan;
            }
        }
        component.set("v.AccPlanAct", acPlanList);
    }
})