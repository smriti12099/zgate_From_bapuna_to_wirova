CLASS zcl_cpi_get_weight DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    TYPES: BEGIN OF ty_request,
             location TYPE string,
           END OF ty_request.

    METHODS get_weight
      IMPORTING iv_location        TYPE string
      RETURNING VALUE(rv_response) TYPE string
      RAISING   cx_web_http_client_error
                cx_http_dest_provider_error.
ENDCLASS.



CLASS ZCL_CPI_GET_WEIGHT IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    TRY.
        out->write( get_weight( iv_location = '2' ) ).
      CATCH cx_root INTO DATA(lx_error).
        out->write( lx_error->get_text( ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD get_weight.
    " 1. Resolve destination via Communication Arrangement
    DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
        comm_scenario  = 'ZCS_CPI_GET_WEIGHT'
        service_id     = 'ZCPI_GET_WEIGHT_REST'
        comm_system_id = 'ZCPI_BAPUNA'  ).

    " 2. Create web HTTP client
    DATA(lo_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

    " 3. Build request
    " ===== STEP 1: Fetch CSRF token (HEAD request) =====
    DATA(lo_request) = lo_client->get_http_request( ).
    lo_request->set_header_fields( VALUE #(
      ( name = 'Content-Type' value = 'application/json' )
      ( name = 'Accept'       value = 'application/json' ) ) ).
    " JSON body — for a single field, inline templating is cleanest
    lo_request->set_text( |\{ "location": "{ iv_location }" \}| ).

    " 4. Execute POST
    DATA(lo_response) = lo_client->execute( i_method = if_web_http_client=>post ).

    DATA(ls_status) = lo_response->get_status( ).
    rv_response     = lo_response->get_text( ).

    lo_client->close( ).

    " 5. Surface non-2xx as exception (optional but recommended)
    IF ls_status-code >= 400.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
