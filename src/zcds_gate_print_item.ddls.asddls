@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GE Item Print '
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType:{ 
 serviceQuality: #X, 
 sizeCategory: #S,
 dataClass: #MIXED 
 }
  @Metadata.allowExtensions: true
define view entity ZCDS_GATE_PRINT_ITEM as select from zge_itm
association to parent ZCDS_GATE_PRINT_HEAD as _Header
on $projection.gatenumber = _Header.gateentryno
{
  
  key 
  gate_number  as gatenumber,
  item_number  as sno,
  matnr        as material,
  maktx        as description,
  @Semantics.quantity.unitOfMeasure: 'Unit'
  qty_received as qtyreceived,
  @Semantics.quantity.unitOfMeasure: 'Unit'
  total_ge_qty   as poopenqty,
  uom             as unit,
   _Header // Make association public
}
