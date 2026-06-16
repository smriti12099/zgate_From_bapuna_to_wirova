@EndUserText.label: 'GE Material Group'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_GeMaterialGroup
  as select from ZGE_MAT_GRP
  association to parent ZI_GeMaterialGroup_S as _GeMaterialGroupAll on $projection.SingletonID = _GeMaterialGroupAll.SingletonID
{
  key MATERIAL_GROUP as MaterialGroup,
  MATERIALGROUPTEXT as Materialgrouptext,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _GeMaterialGroupAll
}
