@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS composition root Grn head'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define root view entity zge_c_grn_head
  provider contract transactional_query
  as projection on zge_r_grn_head
{

  key GateNumber,
      GateType,
      @Consumption.valueHelpDefinition: [{ entity.name: 'zge_ce_statusvh', entity.element: 'status' } ]
      GateStatus,
      VehichleNo,
      BillOfLanding,
      PurchasingDoc,
      Supplier,
      @ObjectModel.text.element: [ 'SupplierName' ]
      @Consumption.valueHelpDefinition: [{ entity.name: 'I_Supplier', entity.element: 'Supplier'  }]
      SupplierName,
      Customer,
      @Consumption.valueHelpDefinition: [{ entity.name: 'I_Plant', entity.element: 'Plant'  }]
      Plant,
      CreatedBy,
      CreatedOn,
      GrnDocDate,
      GrnPostDate,
      GrnHeaderText,
      DeliveryNote,
      VendorInvoiceNo,
      Grn,
      GrnYear,
      GrnStatus,
      CancelGrn,      
      PreGrnQc,
      Remark,
      NetWeight,
      PackingUnit,
      GateInDate,
      
       //   Added by Uttam to add New PO Number Fields for Change PO on GRN APP on 13.04.2026
    NewPONumber,
    
    //      Added by Uttam to change po on grn app
//    ScheduleLineDeliveryDate,
      /* Associations */
      _Items : redirected to composition child zge_c_grn_item,
      _Plant,
      _PoItem,
      _Supplier
}
