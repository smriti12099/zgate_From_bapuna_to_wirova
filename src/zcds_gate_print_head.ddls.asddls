@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GE Header print '
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType:{ serviceQuality: #X, 
sizeCategory: #S, 
dataClass: #MIXED } 
@Metadata.allowExtensions: true
define root view entity ZCDS_GATE_PRINT_HEAD as select from zge_hdr
composition [0..*] of ZCDS_GATE_PRINT_ITEM as _ge_item

{

key
   
  gate_number      as gateentryno,  
  vehichle_no      as vehicleno,
  lr_rr_no         as lrrrno,
  bill_of_landing  as billoflanding,
  entry_gate       as gateno,
  vendor_invoice_no   as vendorinvoice  ,
 // vendor_invoice_dt     : abap.dats;
 // reporting_date        : abap.dats;
  ebeln            as ponumber,
 
//  vehichle_no as vehicleno,             
  supplier_name    as suppliername,   
  plantname        as plantname,
  created_by       as createdby,
  @Semantics.quantity.unitOfMeasure : 'packingunit'
  gross_weight     as grossweight,
  @Semantics.quantity.unitOfMeasure : 'packingunit'
  tare_weight      as tareweight,
  @Semantics.quantity.unitOfMeasure : 'packingunit'
  net_weight       as netweight,
  driver_name       as drivername , 
  transporter       as transporter,
  packing_unit      as packingunit,
  vehicle_type     as vehicletype,
    
    _ge_item // Make association public
}
