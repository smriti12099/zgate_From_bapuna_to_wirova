@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view for Gate enty Weighment'
@Metadata.ignorePropagatedAnnotations: false
define root view entity zge_r_head_wt
  as select from zge_i_head
  association [0..1] to I_Plant                as _Plant    on $projection.Plant = _Plant.Plant
  association [0..1] to I_Supplier             as _Supplier on $projection.Supplier = _Supplier.Supplier
  association [0..1] to zge_i_pohead           as _PoHead   on $projection.PurchasingDoc = _PoHead.PurchasingDoc
  association [0..1] to I_InspLotUsageDecision as _Ud       on $projection.PreGrnQc = _Ud.InspectionLot
{
  key GateNumber,
      GateType,
      GatePassType,
      EntryGate,
      GateStatus,
      VehichleNo,
      LrRrNo,
      BillOfLanding,
      VendorInvoiceNo,
      VendorInvoiceDt,
      GateInDate,
      GateInTime,
      //      GateOutDate,
      //      GateOutTime,
      PurchasingDoc,
      SalesDocument,
      Supplier,
      SupplierName,
      Customer,
//      Add by Uttam to Customer Name on Weight Page on 09.05.2026 with discuss with Prakhar Sir
CustomerName,
      Plant,
      PlantName,
      //      CreatedBy,
      //      CreatedOn,
      //      CreationTime,
      InitWeighBridgeCode,
      FinalWeighBridgeCode,
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
      //      Grn,
      PreGrnQc,
      //      Purpose,
      //      PersonConcerned,
      //      PersonArrived,
      //      ContactNumber,
      //      NumberOfPerson,
      //      ReturnDate,
      //      ReturnTime,
      DriverName,
      DriverNumber,
      Transporter,
      TransporterName,
      VehicleType,
      DriverLic,
      Remark,
      WeighTicketNo,
      IsCancelled,
      CancelRemark,
      
      
      
     
      
      // Added 12 fields related to Multiple Weight Calculate
      GrossWeight1,
      GrossWeight2,
      GrossWeight3,

      NetWeight1,
      NetWeight2,
      NetWeight3,

      TareWeight1,
      TareWeight2,
      TareWeight3,

      WeightRemarks1,
      WeightRemarks2,
      WeightRemarks3,
      
      
      
      
      //      Visitor,
      // Make association public
      _Plant,
      _Supplier,
      _PoHead
}

//where
//  (
//        GateStatus     =  'Open'
//    or  GateStatus     =  'Final Weighment Pending'
//    or  GateStatus     =  'Gate Out Pending'
////    or  GateStatus     =  'Close'
//
//  )
//  and(
//        GateType       =  'Manual'
//    and WeightRequired =  'X'
//  )
//  or(
//        GateType       =  'Purchase'
//    or  GateType       =  'Sales'
//    or  GateType       =  'Gate Pass'
//    //Added by Uttam for Co Packs
////     or  GateType       =  'Bacardi'
////      or  GateType       =  'Pernod'
////       or  GateType       =  'Radico'
//    and WeightRequired <> 'X'
//  )  
//  and GateType       <>  'Gate Pass'



// This apply for Gate Status Close show na ho
where
(
        GateStatus = 'Open'
    or  GateStatus = 'Final Weighment Pending'
    or  GateStatus = 'Gate Out Pending'
  //  or  GateStatus = 'Close'
)
and
(
        (
              GateType = 'Manual'
          and WeightRequired = 'X'
        )
     or (
              (
                     GateType = 'Purchase'
                  or GateType = 'Sales'
                  or GateType = 'Gate Pass'
                  //    //Added by Uttam for Co Packs
                     or GateType = 'Bacardi'
                or GateType = 'Pernod'
                or GateType = 'Radico'
                or GateType = 'Tilaknagar'
                or GateType = 'Sona Beverages'
                or GateType = 'Junoon Beverages'
                or GateType = 'Walhalla Alcobev'
                or GateType = 'Medusa Beverages'
                or GateType = 'Grano69 Beverages'
              )
          and WeightRequired <> 'X'
        )
        //Change by Uttam to add STO
        or (
           GateType = 'STO'
       )
)
and GateType <> 'Gate Pass'
and WeightSkip is initial 
