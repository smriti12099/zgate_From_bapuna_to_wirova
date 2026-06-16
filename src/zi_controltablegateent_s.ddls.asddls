@EndUserText.label: 'Control Table Gate Entry Weighment Apppr'
@AccessControl.authorizationCheck: #NOT_REQUIRED
//@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'ControlTableGateAll'
  }
}
define root view entity ZI_ControlTableGateEnt_S
  as select from I_Language
//    left outer join I_CstmBizConfignLastChgd on I_CstmBizConfignLastChgd.ViewEntityName = 'ZI_CONTROLTABLEGATEENT'
//  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
 // composition [0..*] of ZI_ControlTableGateEnt as _ControlTableGateEnt
{
//  @UI.facet: [ {
//    id: 'ZI_ControlTableGateEnt', 
//    purpose: #STANDARD, 
//    type: #LINEITEM_REFERENCE, 
//    label: 'Control Table Gate Entry Weighment Apppr', 
//    position: 1 , 
//    targetElement: '_ControlTableGateEnt'
//  } ]
//  @UI.lineItem: [ {
//    position: 1 
//  } ]
//  key 1 as SingletonID
//  _ControlTableGateEnt,
 // @UI.hidden: true
//  I_CstmBizConfignLastChgd.LastChangedDateTime as LastChangedAtMax,
 // @ObjectModel.text.association: '_ABAPTransportRequestText'
 // @UI.identification: [ {
 //   position: 1 , 
  //  type: #WITH_INTENT_BASED_NAVIGATION, 
  //  semanticObjectAction: 'manage'
 // } ]
 // @Consumption.semanticObject: 'CustomizingTransport'
 // cast( '' as SXCO_TRANSPORT) as TransportRequestID,
//  _ABAPTransportRequestText


key Language

}
where I_Language.Language = $session.system_language
