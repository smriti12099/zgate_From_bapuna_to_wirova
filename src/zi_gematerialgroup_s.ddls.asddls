@EndUserText.label: 'GE Material Group Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'GeMaterialGroupAll'
  }
}
define root view entity ZI_GeMaterialGroup_S
  as select from I_Language
    left outer join ZGE_MAT_GRP on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_GeMaterialGroup as _GeMaterialGroup
{
  @UI.facet: [ {
    id: 'ZI_GeMaterialGroup', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'GE Material Group', 
    position: 1 , 
    targetElement: '_GeMaterialGroup'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _GeMaterialGroup,
  @UI.hidden: true
  max( ZGE_MAT_GRP.LAST_CHANGED_AT ) as LastChangedAtMax,
  @ObjectModel.text.association: '_ABAPTransportRequestText'
  @UI.identification: [ {
    position: 1 , 
    type: #WITH_INTENT_BASED_NAVIGATION, 
    semanticObjectAction: 'manage'
  } ]
  @Consumption.semanticObject: 'CustomizingTransport'
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  _ABAPTransportRequestText
}
where I_Language.Language = $session.system_language
