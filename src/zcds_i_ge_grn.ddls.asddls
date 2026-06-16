@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I View for GRN Num GE'
@Metadata.ignorePropagatedAnnotations: true
define root view entity Zcds_i_GE_GRN as select from zge_i_head
{
    
   key GateNumber,
   
   Grn,
   GrnYear,
   GrnStatus
}
