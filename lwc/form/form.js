import { LightningElement, api, track } from "lwc";
import getFormSettings from "@salesforce/apex/FormCtrl.getFormSettings";
import generatePDF from "@salesforce/apex/FormCtrl.generatePDF";
import { NavigationMixin } from 'lightning/navigation';

import { loadStyle } from "lightning/platformResourceLoader";
import customcss from "@salesforce/resourceUrl/observations";
export default class Form extends LightningElement {
  @track sections = [];
  fields = [];
  fieldSetNames = [];
  accountName = "";
  showSpinner = "slds-show";
  inspectionDate;
  deliveryDate;
  machineSr;
  message;
  @api recordId;
  @api typeName;
  renderedCallback() {
    loadStyle(this, customcss);
  }
  connectedCallback() {
    getFormSettings({ typeName: this.typeName })
      .then((result) => {
        // this.sections = result;
        this.error = undefined;
        for (var key in result) {
          this.sections.push({ value: result[key], key: key }); //Here we are creating the array to show on UI.
        }
        console.log(JSON.stringify(this.sections));
      })
      .catch((error) => {
        this.error = error;
        this.sections = undefined;
      });
  }
  handleOnLoad(event) {
    let record = event.detail.records[this.recordId].fields;
    console.log(JSON.stringify(record));
    this.inspectionDate = record.Inspection_Date__c.displayValue;
    this.deliveryDate = record.Expected_Delivery_Date__c.displayValue;
    this.machineSr = record.Machine_Serial_Number__c.displayValue;
    this.accountName = record.Account.value.fields.Name.value;
    this.showSpinner = "slds-hide";
  }
  handleUploadFinished(event) {
    // Get the list of uploaded files
    const uploadedFiles = event.detail.files;
    this.message = "Uploaded " + uploadedFiles.length + " files successfully";
    this.template.querySelector("c-toast-message").showCustomNotice();
  }
  handleSave() {
    this.showSpinner = "slds-show";
    this.template.querySelector("lightning-record-edit-form").submit();
    const redirecttoRecordPage = new CustomEvent('pdfGenerated');
    this.dispatchEvent(redirecttoRecordPage);
  }
  handleSuccess() {
    this.showSpinner = "slds-hide";
    this.message = "Saved successfully.";
    this.template.querySelector("c-toast-message").showCustomNotice();
  }

  handleGeneratePDF(){
    let recordId = this.recordId; 
    let message = "Generated PDF Successfully";  
    this.GeneratePDF(recordId,false,message);
   
  }
  handleGeneratePDFSendEmail(){
    let recordId = this.recordId;
    let message = "Generated PDF and Sent Email Successfully";  
    this.GeneratePDF(recordId,true,message);
    
  }

  GeneratePDF(recordId,sendmail,msg){
    generatePDF({ recId: recordId,sendEmail: sendmail})
    .then((result) => {
      
      console.log(JSON.stringify(result));
      this.message = msg;
      this.template.querySelector("c-toast-message").showCustomNotice();
      
        const pdfgeneratedEvent = new CustomEvent('pdfGenerated');
        this.dispatchEvent(pdfgeneratedEvent);
      
    })
    .catch((error) => {
      this.error = error;
      console.log('error'+JSON.stringify(error));
    });
    
  
  }
  errorCallback(error, stack) {
    throw error;
  }
}