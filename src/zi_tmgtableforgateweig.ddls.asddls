@EndUserText.label: 'TMG Table for Gate & Weighment Approval'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgTableForGateWeig
  as select from ZTMG_WEIGHT_APPR
  association to parent ZI_TmgTableForGateWeig_S as _TmgTableForGateWAll on $projection.SingletonID = _TmgTableForGateWAll.SingletonID
{
  key USERID as Userid,
  key PURPOSE as Purpose,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgTableForGateWAll
}
