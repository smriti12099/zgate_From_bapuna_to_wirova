@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Weighment Approval'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zi_Weighment_Appr as select from ztab_weight_apr
{
    key gate_number as GateNumber,
    gate_type as GateType,
    init_wt_date as InitWtDate,
    init_wt_time as InitWtTime,
    approval as Approval
}
