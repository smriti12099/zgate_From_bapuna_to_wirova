@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS composition for GRN item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #M,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity zge_c_grn_item 
as projection on zge_r_grn_item
{
    key GateNumber,
    key ItemNumber,
    PurchasingDoc,
    PurchaseOrderItem,
    Material,
    MaterialDescription,
    StorageLocation,
    Batch,
    @Semantics.quantity.unitOfMeasure: 'Meins'
    
    QtyOrdered,
    
    @Semantics.quantity.unitOfMeasure: 'Meins'
    QtyReceived,
    
    
//    Added by Uttam

    MaterialGroup,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    NetPriceAmount,
    DocumentCurrency,
    NetPriceQuantity,
    
          //Added by Uttam for PO Change on GRN App on 17.04.2026
  ScheduleLineDeliveryDate,
    
    @Semantics.quantity.unitOfMeasure: 'Meins'
    TotalGeQty,
    Meins,
    Uom,
    Tolerance,
    Werks,
    /* Associations */
    _Head : redirected to parent zge_c_grn_head,
    _Mat
}
