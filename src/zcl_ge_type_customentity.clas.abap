CLASS zcl_ge_type_customentity DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GE_TYPE_CUSTOMENTITY IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
   DATA : lt_type_data TYPE STANDARD TABLE OF zge_ce_typevh.



     lt_type_data = VALUE #(
                              ( gate_type = 'Purchase' )
                              ( gate_type = 'Sales' )
                              ( gate_type = 'Manual' )
                              ( gate_type = 'Gate Pass' )
                              "Change by Uttam to add STO
                              ( gate_type = 'STO' )
                              """"""""""""""""""""""""""""""""""""""""
                              "Added by Uttam for adding Co Pack on Searchbar Gate Type , effect on Gate Entry & Weighment
                              ( gate_type = 'Bacardi' )
                              ( gate_type = 'Radico' )
                              ( gate_type = 'Pernod' )
                              ( gate_type = 'Tilaknagar' )
                              ( gate_type = 'Sona Beverages' )
                              ( gate_type = 'Junoon Beverages' )
                              ( gate_type = 'Walhalla Alcobev' )
                              ( gate_type = 'Medusa Beverages' )
                              ( gate_type = 'Grano69 Beverages' )

                              """"""""""""""""""""""""""""""""""""""""
                              ).
*
data(lt_temp) = lt_type_data[].
clear : lt_type_data[].

LOOP AT lt_temp INTO data(wa_temp).
     AUTHORITY-CHECK OBJECT 'ZAO_GETYPE'
         ID 'ZAF_GETYPE' FIELD wa_temp-gate_type
         ID 'ACTVT' FIELD '02'.

         if sy-subrc eq 0.
            APPEND wa_temp TO lt_type_data.
            clear: wa_temp.
         ENDIF.
ENDLOOP.


     DATA(lt_sort_element) = io_request->get_sort_elements( ).
     DATA(lt_paging) = io_request->get_paging( ).
    " Set the response data
    io_response->set_data( it_data = lt_type_data  ).
*    CATCH cx_rap_query_response_set_twic.

    " Set the total no of records
    io_response->set_total_number_of_records( iv_total_number_of_records = lines( lt_type_data ) ).
*    CATCH cx_rap_query_response_set_twic.
  ENDMETHOD.
ENDCLASS.
