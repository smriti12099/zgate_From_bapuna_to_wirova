@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cds view for GRN item'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #M,
    dataClass: #MIXED
}
define view entity zge_r_grn_item
  as select from zge_i_item

  association to parent zge_r_grn_head as _Head
    on $projection.GateNumber = _Head.GateNumber

  association [0..1] to ZGE_I_Product as _Mat
    on $projection.Material = _Mat.Material

  association [0..1] to I_PurchaseOrderItemAPI01 as _POItem
    on  $projection.PurchasingDoc     = _POItem.PurchaseOrder
    and $projection.PurchaseOrderItem = _POItem.PurchaseOrderItem
    
    
      association [0..1] to I_PurOrdScheduleLineAPI01 as _Schedule
    on  $projection.PurchasingDoc     = _Schedule.PurchaseOrder
    and $projection.PurchaseOrderItem = _Schedule.PurchaseOrderItem

{
  /* Keys */
  key GateNumber,
  key ItemNumber,

  /* Item data */
  PurchasingDoc,
  PurchaseOrderItem,
  Matnr        as Material,
  Maktx        as MaterialDescription,
  StorageLocation,
  Batch,
  QtyOrdered,
  QtyReceived,
  TotalGeQty,
  Meins,
  Uom,
  Tolerance,
  Werks,
  
  //Added by Uttam for PO Change on GRN App on 17.04.2026
  _Schedule.ScheduleLineDeliveryDate,

  /* >>> Fetched from Purchase Order Item <<< */
  _POItem.MaterialGroup      as MaterialGroup,
  _POItem.NetPriceAmount      as NetPriceAmount,
  _POItem.DocumentCurrency   as DocumentCurrency,
_POItem.NetPriceQuantity   as NetPriceQuantity,
_POItem.PurchaseOrderQuantityUnit   as PurchaseOrderQuantityUnit,
  /* Associations */
  _Head,
  _Mat,
  _POItem
}
