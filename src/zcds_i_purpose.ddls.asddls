@EndUserText.label: 'Custom Entity C View Purpose on WT TMG'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_FILL_PURPOSE'
@ObjectModel : { resultSet.sizeCategory: #XS }
define custom entity Zcds_I_Purpose
// with parameters parameter_name : parameter_type
{
  key purpose : abap.char( 20 );
//  element_name : element_type;
  
}
