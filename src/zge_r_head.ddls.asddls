@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header Root Entiry'
@Metadata.ignorePropagatedAnnotations: false
define root view entity zge_r_head
  as select from zge_i_head
  --Composition child for header viz Item
  composition [0..*] of zge_r_item     as _Items

  --associations - lose coupling to get dependent data
  association [0..1] to I_Plant        as _Plant    on $projection.Plant = _Plant.Plant
  association [0..1] to I_Supplier     as _Supplier on $projection.Supplier = _Supplier.Supplier
  association [0..*] to zge_i_purchase as _PoItem   on $projection.PurchasingDoc = _PoItem.PurchasingDoc


{
  key GateNumber,
      GateType,
      GatePassType,
      GatePassCode,
      EntryGate,
      GateStatus,
      IsCancelled,
      VehichleNo,
      LrRrNo,
      BillOfLanding,
      VendorInvoiceNo,
      VendorInvoiceDt,
      GateInDate,
      GateInTime,
      GateOutDate,
      GateOutTime,
      PurchasingDoc,
      SalesDocument,
      InvoiceNumber,
      Supplier,
      SupplierName,
      Customer,
      CustomerName,
      Plant,
      PlantName,
      CreatedBy,
      CreatedOn,
      CreationTime,
      ReportingDate,
      ReportingTime,
      GrossWeight,
      TareWeight,
      PackingUnit,
      NetWeight,
      WeightRequired,
      WeightSkip,
      InitWtDate,
      InitWtTime,
      FinalWtDate,
      FinalWtTime,
      VendorSlip,
      VendorGrossWeight,
      VendorTareWeight,
      Grn,
      GrnYear,
      PreGrnQc,
      Purpose,
      PersonConcerned,
      PersonArrived,
      ContactNumber,
      NumberOfPerson,
      ReturnDate,
      ReturnTime,
      DriverName,
      DriverNumber,
      Transporter,
      TransporterName,
      VehicleType,
      DriverLic,
      Remark,
      CancelRemark,
      Visitor,
      RefDocNumber,
      WeighTicketNo,
      DelFlag,
      DelRemark,
////      Added on Date 31.02.2026 by RB
     Email_Sent,     //Email Sent status will update from qc email interface
     Apr_sta,       //Approve Status will  update from qc email interface
     Napr_sta ,    // Not Approve Status will update from qc email interface
      // Make association public
      _Items,
      _Plant,
      _Supplier,
      _PoItem
      

}
//where DelFlag is initial 

// This apply for Gate Status Close show na ho
where DelFlag is initial
and GateStatus <> 'Close'

