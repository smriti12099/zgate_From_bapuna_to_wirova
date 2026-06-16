CLASS zcl_fill_mg_convert DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
      INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FILL_MG_CONVERT IMPLEMENTATION.


    METHOD IF_OO_ADT_CLASSRUN~MAIN.
    " Write initial message
   DATA gt_employees TYPE STANDARD TABLE OF zge_mg_convert.
gt_employees = VALUE #(
      ( client = sy-mandt materialgroup = 'M008' unit = 'KG' value = 2000 )
      ( client = sy-mandt materialgroup = 'M008' unit = 'TO' value = 1000 )
    ).
INSERT zge_mg_convert FROM TABLE @gt_employees.

 ENDMETHOD.
ENDCLASS.
