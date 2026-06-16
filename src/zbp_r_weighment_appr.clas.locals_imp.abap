CLASS lhc_zr_weighment_appr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR zr_weighment_appr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_weighment_appr RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zr_weighment_appr RESULT result.

    METHODS setapprove FOR MODIFY
      IMPORTING keys FOR ACTION zr_weighment_appr~setapprove RESULT result.

    METHODS calculatetimedate FOR DETERMINE ON SAVE
      IMPORTING keys FOR zr_weighment_appr~calculatetimedate.

ENDCLASS.

CLASS lhc_zr_weighment_appr IMPLEMENTATION.

  METHOD get_global_features.



DATA lv_user        TYPE syuname.
DATA lv_has_auth    TYPE abap_bool.

lv_user = cl_abap_context_info=>get_user_technical_name( ).

SELECT SINGLE a~userid
  FROM ztmg_weight_appr AS a

  WHERE a~userid = @lv_user
  and a~purpose = 'WEIGHMENT'
   INTO @DATA(lv_user_auth).



IF sy-subrc eq 0.
  lv_has_auth = abap_true.
ELSE.
  lv_has_auth = abap_false.
ENDIF.


    result-%action-SetApprove =  COND #( WHEN  lv_has_auth = 'X'
                    THEN if_abap_behv=>fc-o-enabled
                    ELSE if_abap_behv=>fc-o-disabled ).



  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD setapprove.
  MODIFY ENTITIES OF Zr_Weighment_Appr IN LOCAL MODE
           ENTITY Zr_Weighment_Appr
              UPDATE FROM VALUE #( FOR key IN keys
              ( %tky = key-%tky
                Approval = abap_true " Booked
                %control-Approval = if_abap_behv=>mk-on ) )
              FAILED failed
              REPORTED reported.

    "Read changed data for action result
    READ ENTITIES OF Zr_Weighment_Appr IN LOCAL MODE
      ENTITY Zr_Weighment_Appr
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT DATA(lt_data).

    result = VALUE #( FOR ls_data IN lt_data
             ( %tky   = ls_data-%tky
               %param = ls_data ) ).
  ENDMETHOD.

  METHOD calculatetimedate.


    READ ENTITIES OF Zr_Weighment_Appr IN LOCAL MODE
        ENTITY Zr_Weighment_Appr

        FIELDS ( GateNumber InitWtDate InitWtTime GateType  )
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_weighment).

        LOOP AT lt_weighment into data(ls_weighment).
             SELECT SINGLE gatetype,
             InitWtDate,
             InitWtTime
              FROM zge_i_head WHERE GateNumber = @( ls_weighment-GateNumber )

        INTO  @DATA(ls_gate).

            "update involved instances
    MODIFY ENTITIES OF Zr_Weighment_Appr IN LOCAL MODE
      ENTITY Zr_Weighment_Appr
    UPDATE FIELDS ( GateType  InitWtDate InitWtTime  ) WITH VALUE #(
                                                            ( %tky = ls_weighment-%tky

                                                                InitWtDate = ls_gate-InitWtDate
                                                                InitWtTime = ls_gate-InitWtTime
                                                                GateType = ls_gate-GateType

                                                             )

                                                             ).

        ENDLOOP.






  ENDMETHOD.

ENDCLASS.
