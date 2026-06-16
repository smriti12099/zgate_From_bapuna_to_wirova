@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GRN Number of GE QA32 Enh.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zcds_I_Grn_Num_Ge as select from zgrnnum_ge
{
    key gate_number as GateNumber,
    vehichle_no as VehichleNo,
    grn as Grn,
    pre_grn_qc as PreGrnQc   
}
