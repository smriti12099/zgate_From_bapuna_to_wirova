class ZCL_HTTP_WEIGHT_CALL definition
  public
  create public .

public section.
*    meTHODS get_weight importING
*                    iv_location type String.

*              RAISING
*                cx_http_dest_provider_error.

                        METHODS get_weight
      IMPORTING
        io_request  TYPE REF TO if_web_http_request
        io_response TYPE REF TO if_web_http_response.


  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_HTTP_WEIGHT_CALL IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.

        DATA(lv_uri_path) = request->get_header_field( '~path' ).


        IF lv_uri_path CP '*/GetWeight'.
      me->get_weight( io_request = request io_response = response ).
 enDIF.

  endmethod.


  METHOD get_weight.


      DATA(lt_form_fields) = io_request->get_form_fields(  ).

            IF line_exists(  lt_form_fields[ name = 'location' ] ).
       data(location) =  lt_form_fields[ name = 'location' ]-value.


    " 1. Resolve destination via Communication Arrangement
    TRY.
        data(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
            comm_scenario  = 'ZCS_CPI_GET_WEIGHT'
            service_id     = 'ZCPI_GET_WEIGHT_REST'
            comm_system_id = 'ZCPI_BAPUNA'  ).
*      CATCH cx_http_dest_provider_error.
*change by Uttam for TR Movement
CATCH cx_http_dest_provider_error INTO DATA(lx_dest).
        DATA(lv_dummy1) = lx_dest->get_text( ).
        "handle exception
    ENDTRY.

    " 2. Create web HTTP client
    TRY.
        data(lo_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
*      CATCH cx_web_http_client_error.
*change by Uttam for TR Movement
 CATCH cx_web_http_client_error INTO DATA(lx_client).
    DATA(lv_dummy2) = lx_client->get_text( ).
        "handle exception
    ENDTRY.

    " 3. Build request
    " ===== STEP 1: Fetch CSRF token (HEAD request) =====
    DATA(lo_request) = lo_client->get_http_request( ).
    lo_request->set_header_fields( VALUE #(
      ( name = 'Content-Type' value = 'application/json' )
      ( name = 'Accept'       value = 'application/json' ) ) ).
    " JSON body — for a single field, inline templating is cleanest
    lo_request->set_text( |\{ "location": "{ location }" \}| ).


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    Get Current TimeStamps
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    data(lv_current_time) type ti

    " 4. Execute POST
    TRY.
        data(lo_response) = lo_client->execute( i_method = if_web_http_client=>post ).
*      CATCH cx_web_http_client_error.
*change by Uttam for TR Movement
CATCH cx_web_http_client_error INTO DATA(lx_execute).
    DATA(lv_dummy3) = lx_execute->get_text( ).
        "handle exception
    ENDTRY.

    DATA(ls_status) = lo_response->get_status( ).
    data(rv_response)     = lo_response->get_text( ).


    " 5. Surface non-2xx as exception (optional but recommended)
       if sy-subrc eq 0.
        io_response->set_status( i_code = 200 i_reason = 'Data fetched.' ).
        io_response->set_text( rv_response ).

    else.
        io_response->set_status( i_code = 400 i_reason = 'No Data Found.' ).
    endif.

else.

          io_response->set_status( i_code = 500 i_reason = 'No Location Found.' ).

ENDIF.



  ENDMETHOD.
ENDCLASS.
