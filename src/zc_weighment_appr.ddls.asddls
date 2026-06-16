@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'C View for Weighment Approval'
@Metadata.ignorePropagatedAnnotations: true
//@Metadata.allowExtensions: true


@UI.headerInfo: {
  typeName: 'Gate Entry',
  typeNamePlural: 'Gate Entry',
  title: {
    type: #STANDARD,
    value: 'GateNumber'
  },
  description: {
    value: 'GateType'
  }
}
define root view entity Zc_Weighment_Appr
provider contract transactional_query
 as projection on Zr_Weighment_Appr
 
 
 {

  @UI.facet: [{
      id       : 'idWeighment',
      label    : 'Weighment Approval',
      position : 10,
      type     : #IDENTIFICATION_REFERENCE,
      purpose  : #STANDARD    
  }]
//  /* --- Line Item & Identification Fields --- */
  @EndUserText.label: 'Gate Number'
  @UI.selectionField: [{ position: 10 }]
  @UI.lineItem: [{ position: 10, label: 'Gate Number' },
  { type: #FOR_ACTION, dataAction: 'SetApprove', label: 'Set to Approve'}
  ]
  @UI.identification: [{ position: 10, label: 'Gate Number'} ,
    { type: #FOR_ACTION, dataAction: 'SetApprove', label: 'Set to Approve'
   }]
   @Consumption.valueHelpDefinition: [{ entity.name: 'ZGE_I_HEAD', entity.element: 'GateNumber' }]
  key GateNumber,

  @UI.lineItem: [{ position: 20, label: 'Gate Type' }]
  @UI.identification: [{ position: 20, label: 'Gate Type' }]
  GateType,



  @UI.lineItem: [{ position: 40, label: 'Initial Weight Date' }]
  @UI.identification: [{ position: 40, label: 'Initial Weight Date' }]
  InitWtDate,

  @UI.lineItem: [{ position: 50, label: 'Initial Weight Time' }]
  @UI.identification: [{ position: 50, label: 'Initial Weight Time' }]
  InitWtTime,



  @UI.lineItem: [{ position: 70, label: 'Approval' }]
  @UI.identification: [{ position: 70, label: 'Approval' }]
  Approval
}


