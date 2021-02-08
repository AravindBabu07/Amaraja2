public class GeneratePDFController {
    public static Map<String, List<String>> sectionFieldsMap{get;set;}
    public static Map<String,String> fieldLabels{get;set;}
    public GeneratePDFController(ApexPages.StandardController sc){
        fieldLabels = new Map<String,String>();
        getFormSettings('Opportunity');
        for(List<String> fieldnames :sectionFieldsMap.values()){
            sc.addFields(fieldnames);
        }
        
    }
    
    
    public static void getFormSettings(String typeName){
        List<Form_Settings__mdt> formSettings =  new List<Form_Settings__mdt>([SELECT MasterLabel, Field_Set_API_Name__c,
                                                                        QualifiedApiName FROM Form_Settings__mdt]);
        sectionFieldsMap = new Map<String, List<String>>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Opportunity');
        for(Form_Settings__mdt formsetting : formSettings){
            sectionFieldsMap.put(formsetting.MasterLabel, getFields(targetType, formsetting.Field_Set_API_Name__c));
            
        }
        system.debug('sectionFieldsMap'+sectionFieldsMap);
        
        
    }
    
    public static List<String> getFields(Schema.SObjectType targetType, String fieldSetName) {
        //case caseObj = [select Fieldset_API_Name__c  from case where id=:recId];
        List<String> fields = new List<String>();
        //Schema.SObjectType targetType = Schema.getGlobalDescribe().get(typeName);
            if(String.isNotBlank(fieldSetName)){
                Schema.DescribeSObjectResult describe = targetType.getDescribe();
                Map<String, Schema.FieldSet> fsMap = describe.fieldSets.getMap();
                Schema.FieldSet fs = fsMap.get(fieldSetName);
                List<Schema.FieldSetMember> fieldSet = fs.getFields();
                for (Schema.FieldSetMember f: fieldSet) {
                    fields.add(f.getFieldPath());
                     
                    fieldLabels.put(f.getFieldPath(),f.getLabel());
                    
                }
            }
        system.debug('fieldLabels'+fieldLabels);
        return fields;
       // return null;
    }
}