@EndUserText.label: 'Material Group Conversion'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_MaterialGroupConver
  as select from ZGE_MG_CONVERT
  association to parent ZI_MaterialGroupConver_S as _MaterialGroupConAll on $projection.SingletonID = _MaterialGroupConAll.SingletonID
{
  key MATERIALGROUP as Materialgroup,
  key UNIT as Unit,
  VALUE as Value,
  @Consumption.hidden: true
  1 as SingletonID,
  _MaterialGroupConAll
}
