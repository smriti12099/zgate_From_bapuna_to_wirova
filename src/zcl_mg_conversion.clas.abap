CLASS zcl_mg_conversion DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MG_CONVERSION IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF io_request->is_data_requested( ).

      DATA: lt_response    TYPE TABLE OF ZCDS_I_PurchaseRegister,
            lt_result      TYPE TABLE OF ZCDS_I_PurchaseRegister,
            lt_result1      TYPE TABLE OF ZCDS_I_PurchaseRegister,
            wa_result      type ZCDS_I_PurchaseRegister,
            ls_response    LIKE LINE OF lt_response,
            lt_responseout LIKE lt_response,
            ls_responseout LIKE LINE OF lt_responseout.

      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lv_max_rows) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE lv_top ).

    "  DATA(lt_clause)        = io_request->get_filter( )->get_as_ranges( ).
      DATA(lt_parameter)     = io_request->get_parameters( ).
      DATA(lt_fields)        = io_request->get_requested_elements( ).
      DATA(lt_sort)          = io_request->get_sort_elements( ).

TRY.
    DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
  CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
    CLEAR lt_filter_cond. " Fallback to empty filter list if no ranges are provided
ENDTRY.
   LOOP AT lt_filter_cond INTO DATA(ls_filter_cond).
  IF ls_filter_cond-name = 'COMPANYCODE'.
    DATA(lt_company_code) = ls_filter_cond-range[].
  ELSEIF ls_filter_cond-name = 'SUPPLIERINVOICE'.
    DATA(lt_supplier_invoice) = ls_filter_cond-range[].
  ELSEIF ls_filter_cond-name = 'INVOICINGPARTY'.
    DATA(lt_vendor) = ls_filter_cond-range[].
  ELSEIF ls_filter_cond-name = 'POSTINGDATE'.
    DATA(lt_posting_date) = ls_filter_cond-range[].
  ENDIF.
ENDLOOP.

   DATA : lt_status_data TYPE STANDARD TABLE OF zcds_ce_mg_conversion_grn.

    "Fill the status value
     lt_status_data = VALUE #(
                              ( materialgroup = 'M008' unit = 'TO' value = 1000 )
                               ( materialgroup = 'M008' unit = 'KG' value = 2000 )
                              ).

     DATA(lt_sort_element) = io_request->get_sort_elements( ).
     DATA(lt_paging) = io_request->get_paging( ).
    " Set the response data
    io_response->set_data( it_data = lt_status_data  ).
*    CATCH cx_rap_query_response_set_twic.

    " Set the total no of records
    io_response->set_total_number_of_records( iv_total_number_of_records = lines( lt_status_data ) ).
*    CATCH cx_rap_query_response_set_twic.

ENDIF.
  ENDMETHOD.
ENDCLASS.
