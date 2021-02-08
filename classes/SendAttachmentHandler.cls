public class SendAttachmentHandler{
    @AuraEnabled
    public static void sendDoc(String conId, String recId, Boolean sendEmail){
        SendAttachment(conId, recId, sendEmail);
    }
    @future(callout=true)
    public static void SendAttachment(String conId, String recId, Boolean sendEmail){
        String sMessage='';
            system.debug('in send attachment' + conId + '***'+recId+'***'+sendEmail);
            contact con = [select id,name, email from contact where id=:conId limit 1];
            // Replace Visualforce(AccountDetails) page with your visualforce page
            PageReference pref = page.CommissionInstallationReport;
            pref.getParameters().put('id',recId);

            Blob b = pref.getContentaspdf();
        	ContentVersion cont = new ContentVersion();
                
                cont.Title = 'Installation Commission Report';
                cont.PathOnClient = 'InstallationCommissionReport.pdf';
                cont.VersionData = b;
                cont.Origin = 'H';
                
                insert cont;   
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cont.Id].ContentDocumentId;
                cdl.LinkedEntityId = recId;
                cdl.ShareType = 'V';
                insert cdl;
            if(sendEmail){
                Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                attach.setFileName('InstallationCommissionReport.pdf');
                attach.setBody(b);
                semail.setSubject('Installation Commission Report');
                semail.setTargetObjectId(con.Id);
                semail.setSaveAsActivity(true);
                //semail.setToAddresses(new List<String>{'snune@salesforce.com',con.email});
                semail.setHTMLBody('Hi ' + con.name + ',<br><p>Please find the attached contains Commission Installation Report.</p><br/><br/> Thanks!');
                semail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{semail});
                sMessage='SUCCESS';
            }
    }
}