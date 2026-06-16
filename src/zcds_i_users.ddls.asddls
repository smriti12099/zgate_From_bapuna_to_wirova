@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I View for Business User VH'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zcds_I_Users as select from I_BusinessUserVH
{
    key BusinessPartner,
    BPIdentificationNumber,
    UserID,
    FirstName,
    LastName,
    DefaultEmailAddress,
    PersonFullName
}
