import { LightningElement, api } from "lwc";
import { loadStyle } from "lightning/platformResourceLoader";
import observationcss from "@salesforce/resourceUrl/iobservation";
export default class InstallationCommissionReport extends LightningElement {
  @api recordId;
  showSpinner = "slds-show";
  handleSave() {
    this.showSpinner = "slds-show";
    this.template.querySelector("lightning-record-edit-form").submit();
    const reportGeneratedEvt = new CustomEvent('reportGeneratedEvt');
    this.dispatchEvent(reportGeneratedEvt);
  }
  renderedCallback() {
    loadStyle(this, observationcss);
  }
  handleSuccess() {
    this.showSpinner = "slds-hide";
    this.template.querySelector("c-toast-message").showCustomNotice();
  }
  handleOnLoad(event) {
    this.showSpinner = "slds-hide";
  }
}