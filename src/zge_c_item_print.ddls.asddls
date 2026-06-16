@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: ' '
@Metadata.ignorePropagatedAnnotations: true
define view entity ZGE_C_ITEM_PRINT as projection on ZCDS_GATE_PRINT_ITEM
{
  
  key 
   gatenumber,
   sno,
   material,
   description,
  @Semantics.quantity.unitOfMeasure: 'Unit'
   qtyreceived,
  @Semantics.quantity.unitOfMeasure: 'Unit'
   poopenqty,
   unit,
   _Header : redirected to parent ZGE_C_HDR_PRINT // Make association public  
}
