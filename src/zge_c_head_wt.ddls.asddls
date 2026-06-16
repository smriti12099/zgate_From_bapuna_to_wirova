@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Compostiton view for Gate Weighment'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define root view entity zge_c_head_wt
  provider contract transactional_query
  as projection on zge_r_head_wt
{
  key GateNumber,
      GateType,
      GatePassType,
      EntryGate,
      @Consumption.valueHelpDefinition: [{ entity.name: 'zge_ce_statusvh', entity.element: 'status' } ]
      GateStatus,
      VehichleNo,
      LrRrNo,
      BillOfLanding,
      VendorInvoiceNo,
      VendorInvoiceDt,
      GateInDate,
      GateInTime,
      PurchasingDoc,
      SalesDocument,
      @ObjectModel.text.element: [ 'SupplierName' ]
      @Consumption.valueHelpDefinition: [{ entity.name: 'I_Supplier', entity.element: 'Supplier' }]
      Supplier,
      SupplierName,
      Customer,
      //      Add by Uttam to Customer Name on Weight Page on 09.05.2026 with discuss with Prakhar Sir
CustomerName,
      @Consumption.valueHelpDefinition: [{ entity.name: 'I_Plant', entity.element: 'Plant'  }]
      Plant,
      PlantName,
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
      PreGrnQc,
      VehicleType,
      DriverName,
      DriverNumber,
      Transporter,
      TransporterName,
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
      
      
      /* Associations */
      _Plant,
      _PoHead,
      _Supplier
}
