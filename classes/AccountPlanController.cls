public class AccountPlanController {
    @auraEnabled
    public static List< Account_Plan_Activity__c > getPlannedActivities( String accId ){
        return [SELECT Id, Name, Planned_Date__c, Actual_Date__c, Status__c, Account__c, InEditMode__c  FROM Account_Plan_Activity__c WHERE Account__c =: accId];
    }
    
    @auraEnabled
    public static List< Account_Plan_Activity__c > savePlannedActivities( List< Account_Plan_Activity__c > plannedActivities, String accId ){
        List< Account_Plan_Activity__c > plannedActivitiesInsert = new List< Account_Plan_Activity__c >();
        for(Account_Plan_Activity__c pa: plannedActivities){
            System.debug('pa-->'+pa);
            //if(pa.Id == null || pa.Id == ''){
            	pa.InEditMode__c = false; 
                plannedActivitiesInsert.add(pa);
            //}
        }
        System.debug('plannedActivitiesInsert-->'+plannedActivitiesInsert);
        upsert plannedActivitiesInsert;
        return [SELECT Id, Name, Planned_Date__c, Actual_Date__c, Status__c, Account__c, InEditMode__c  FROM Account_Plan_Activity__c WHERE Account__c =: accId];
    }
}