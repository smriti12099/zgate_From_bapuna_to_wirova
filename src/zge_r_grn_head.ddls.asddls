@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cds root view for GRN head'
@Metadata.ignorePropagatedAnnotations: false
define root view entity zge_r_grn_head
  as select from zge_i_head

  --Composition child for header viz Item
  composition [0..*] of zge_r_grn_item as _Items

  --associations - lose coupling to get dependent data
  association [0..1] to I_Plant        as _Plant    on $projection.Plant = _Plant.Plant
  association [0..1] to I_Supplier     as _Supplier on $projection.Supplier = _Supplier.Supplier
  association [0..*] to zge_i_purchase as _PoItem   on $projection.PurchasingDoc = _PoItem.PurchasingDoc
  
  --Added by Uttam for Result Recording Qualuty Deduction Integration
  association [0..1] to I_InspLotUsageDecision as _UsageDecision
  on  $projection.PreGrnQc = _UsageDecision.InspectionLot
  
 // association [0..1] to zge_emal_comment as _email on $projection.GateNumber = _email.gate_number
 //                                                  and $projection.PreGrnQc = _email.pre_grn_qc    
{

  key GateNumber,
      GateType,
      GateStatus,
      VehichleNo,
      BillOfLanding,
      PurchasingDoc,
      Supplier,
      SupplierName,
      Customer,
      Plant,
      CreatedBy,
      CreatedOn,
      GrnDocDate,
      GrnPostDate,
      GrnHeaderText,
      DeliveryNote,
      Grn,
      GrnYear,
      GrnStatus,
      CancelGrn,
      PreGrnQc,
      Remark,
      NetWeight,
      PackingUnit,
      VendorInvoiceNo,
      GateInDate,
       //   Added by Uttam to add New PO Number Fields for Change PO on GRN APP on 13.04.2026
    NewPONumber,
    //      Added by Uttam to change po on grn app
//    _PoItem.ScheduleLineDeliveryDate,
    
      _Items,
      _Plant,
      _Supplier,
      _PoItem,
      
// Added by change by Uttam below condition for Result Record QC Deduction App
      _UsageDecision.InspectionLotUsageDecisionCode
  //    _email.approval_status
      
}

// Added by change by Uttam below condition for Result Record QC Deduction App and GRN App New Requirement and Created not shown

//where
//      zge_i_head.PurchasingDoc is not initial
//  and (
//         GateStatus = 'Gate Out Pending'
//      or GateStatus = 'Close'
//      )
//  and zge_i_head.GrnStatus <> 'Created'
//  and (
//          _UsageDecision.InspectionLotUsageDecisionCode is null
//       or not (
//                 _UsageDecision.InspectionLotUsageDecisionCode = 'R'
//              or (
//                     _UsageDecision.InspectionLotUsageDecisionCode = 'AD'
//                 and zge_i_head.Napr_sta = 'X'
//                 )
//              )
//      )
//


// Added by change by Uttam below condition for Result Record QC Deduction App and GRN App New Requirement and Created not shown
// Remove Copackers from Lists on 09.04.2026
where
      zge_i_head.PurchasingDoc is not initial
  and (
         GateStatus = 'Gate Out Pending'
      or GateStatus = 'Close'
      )
  and zge_i_head.GrnStatus <> 'Created'

//  and zge_i_head.GateType <> 'Bacardi'
//  and zge_i_head.GateType <> 'Radico'
//  and zge_i_head.GateType <> 'Pernod'

and zge_i_head.GateType <> 'Bacardi'
and zge_i_head.GateType <> 'Radico'
and zge_i_head.GateType <> 'Pernod'
and zge_i_head.GateType <> 'Tilaknagar'
and zge_i_head.GateType <> 'Sona Beverages'
and zge_i_head.GateType <> 'Junoon Beverages'
and zge_i_head.GateType <> 'Walhalla Alcobev'
and zge_i_head.GateType <> 'Medusa Beverages'
and zge_i_head.GateType <> 'Grano69 Beverages'

// Added by Uttam to exclude STO with discuss Akash Sir 15.06.2026
and zge_i_head.GateType <> 'STO'
  and (
          _UsageDecision.InspectionLotUsageDecisionCode is null
       or not (
                 _UsageDecision.InspectionLotUsageDecisionCode = 'R'
              or (
                     _UsageDecision.InspectionLotUsageDecisionCode = 'AD'
                 and zge_i_head.Napr_sta = 'X'
                 )
              )
      )
      
