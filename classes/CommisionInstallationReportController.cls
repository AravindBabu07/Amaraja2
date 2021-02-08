public class CommisionInstallationReportController {
    public String currentRecordId {get;set;}
    public List<workorder> childWOlist{get;set;}
    public List<ProductConsumed> productConsumedList{get;set;}
    public CommisionInstallationReportController(ApexPages.StandardController controller){
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        system.debug('currentRecordId'+currentRecordId);
    }
    public void actionMethod(){
        system.debug('actionMethod'+currentRecordId);
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        childWOlist = new List<workorder>();
        productConsumedList = new List<ProductConsumed>();
        //List<workorder> currentworkorder = [select id, AssetId, ParentWorkOrderId  from workorder where id =:currentRecordId LIMIT 1];
        //system.debug('currentworkorder'+currentworkorder);
        childWOlist = [select id ,LastModifiedDate ,WorkType.Name, ParentWorkOrderId  from workorder where ParentWorkOrderId =:currentRecordId]; 
        system.debug('childWOlist'+childWOlist);
        system.debug('size'+childWOlist.size());
        List<Id> workorderIds = new List<Id>();
        for(workorder wo:childWOlist){
            
            workorderIds.add(wo.Id);
        }
        
         productConsumedList = [select id,ProductConsumedNumber,Description,QuantityConsumed,UnitPrice from ProductConsumed  where WorkOrderId IN:workorderIds];
        system.debug('productConsumedList'+productConsumedList);
        system.debug('size::'+productConsumedList.size());
        
    }

}