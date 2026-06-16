@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: ' '
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZGE_C_HDR_PRINT 
provider contract transactional_query
as projection on ZCDS_GATE_PRINT_HEAD
{
    key
   
   gateentryno,  
   vehicleno,
   lrrrno,
   billoflanding,
   gateno,
   vendorinvoice  ,
 // vendor_invoice_dt     : abap.dats;
 // reporting_date        : abap.dats;
   ponumber,
 
//  vehichle_no as vehicleno,             
   suppliername,   
   plantname,
   createdby,
  @Semantics.quantity.unitOfMeasure : 'packingunit'
   grossweight,
  @Semantics.quantity.unitOfMeasure : 'packingunit'
  tareweight,
  @Semantics.quantity.unitOfMeasure : 'packingunit'
  netweight,
  drivername , 
   transporter,
   packingunit,
   vehicletype,
    
    _ge_item : redirected to composition child ZGE_C_ITEM_PRINT
}
