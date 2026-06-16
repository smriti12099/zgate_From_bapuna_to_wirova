@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Custom Entity CDS for GRN Qty Unit Conversion'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zcds_Ce_Mg_Conversion_Grn as select from zge_mg_convert
{
    key materialgroup as Materialgroup,
    key unit as Unit,
    value as Value
}
