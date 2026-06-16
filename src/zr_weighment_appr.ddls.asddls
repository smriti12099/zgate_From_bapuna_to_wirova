@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root View for Weighment Approval'
@Metadata.ignorePropagatedAnnotations: true
define root view entity Zr_Weighment_Appr as select from Zi_Weighment_Appr
//composition of target_data_source_name as _association_name
{
   key GateNumber,
   GateType,
   InitWtDate,
   InitWtTime,
   Approval
}
