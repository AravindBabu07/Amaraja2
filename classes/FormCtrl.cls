public with sharing class FormCtrl {
    
    @AuraEnabled(cacheable=true)
    public static Map<String, List<String>> getFormSettings(String typeName){
        List<Form_Settings__mdt> formSettings =  new List<Form_Settings__mdt>([SELECT MasterLabel, Field_Set_API_Name__c,
                                                                        QualifiedApiName FROM Form_Settings__mdt]);
        Map<String, List<String>> sectionFieldsMap = new Map<String, List<String>>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(typeName);
        for(Form_Settings__mdt formsetting : formSettings){
            sectionFieldsMap.put(formsetting.MasterLabel, getFields(targetType, formsetting.Field_Set_API_Name__c));
        }
        
        return sectionFieldsMap;
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
                }
            }
        return fields;
       // return null;
    }
    @AuraEnabled
    public static void generatePDF(String recId,Boolean sendEmail){
        String conId;
        List<Opportunity> oppty = [select id,name, Primary_Contact__c  from Opportunity where id =:recId];
        if(oppty.size() > 0){
            conId = oppty[0].Primary_Contact__c;
        }
        else{
            conId = '';
        }
        //Boolean sendEmail = false;
        FormCtrl.SendAttachment(conId, recId, sendEmail);
    }
    @future(callout=true)
    public static void SendAttachment(String conId, String recId, Boolean sendEmail){
        String sMessage='';
            system.debug('in send attachment' + conId + '***'+recId+'***'+sendEmail);
            contact con = [select id,name, email from contact where id=:conId limit 1];
            
            PageReference pref = page.InspectionGeneratePDF;
            pref.getParameters().put('id',recId);
            Blob b = pref.getContentaspdf();
        	
        	ContentVersion cont = new ContentVersion();
                
                cont.Title = 'Pre-Dispatch Inspection';
                cont.PathOnClient = 'PreDispatch Inspection.pdf';
                cont.VersionData = b;
                cont.Origin = 'H';
                
                insert cont;   
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cont.Id].ContentDocumentId;
                cdl.LinkedEntityId = recId;
                cdl.ShareType = 'V';
        		cdl.Visibility  = 'AllUsers';
                insert cdl;
            if(sendEmail){
                Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                attach.setFileName('PreDispatchInspection.pdf');
                attach.setBody(b);
                semail.setSaveAsActivity(true);
                semail.setWhatId(recId);    
                semail.setSubject('Pre-Dispatch Inspection');
                semail.setTargetObjectId(con.Id);
                //semail.setToAddresses(new List<String>{'mthotahil@salesforce.com',con.email});
                semail.setHTMLBody('Hi ' + con.name + ',<br><p>Please find the attached Pre Dispatch Inspection Report for your reference.</p><br/><br/> Thanks!');
                semail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{semail});
                sMessage='SUCCESS';
            }
    }
}