CLASS zcl_ge_gate_wt_api DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.
    TYPES : tt_read_import    TYPE TABLE FOR READ IMPORT zge_r_head_wt\\weight,
            tt_read_result    TYPE TABLE FOR READ RESULT zge_r_head_wt\\weight,

            tt_fail_early     TYPE RESPONSE FOR FAILED EARLY zge_r_head_wt,
            tt_fail_late      TYPE RESPONSE FOR FAILED LATE zge_r_head_wt,
            tt_reported_early TYPE RESPONSE FOR REPORTED EARLY zge_r_head_wt,
            tt_mapped_early   TYPE RESPONSE FOR MAPPED EARLY zge_r_head_wt,

            tt_update_head    TYPE TABLE FOR UPDATE zge_r_head_wt\\weight,

            tt_reported_late  TYPE RESPONSE FOR REPORTED LATE zge_r_head_wt,

            tt_delete_head    TYPE TABLE FOR DELETE zge_r_head_wt\\weight,

            tt_mapped_late    TYPE RESPONSE FOR MAPPED LATE zge_r_head_wt
            .
    " Get the instance of Class
    CLASS-METHODS : get_instance RETURNING VALUE(ro_value) TYPE REF TO zcl_ge_gate_wt_api.

    " Instance method for RAP
    METHODS : read IMPORTING keys     TYPE tt_read_import
                   CHANGING  result   TYPE tt_read_result
                             failed   TYPE tt_fail_early
                             reported TYPE  tt_reported_early,

      update_head IMPORTING entities TYPE tt_update_head
                  CHANGING  mapped   TYPE tt_mapped_early
                            failed   TYPE tt_fail_early
                            reported TYPE tt_reported_early,

      delete_head IMPORTING keys     TYPE tt_delete_head
                  CHANGING  mapped   TYPE tt_mapped_early
                            failed   TYPE tt_fail_early
                            reported TYPE tt_reported_early,


      save        CHANGING  reported  TYPE tt_reported_late,

      "Helper methods
*      set_mapped IMPORTING VALUE(it_mapped) TYPE tt_mapped_early,
*      get_mapped RETURNING VALUE(rt_mapped) TYPE tt_mapped_early,

      finalize  CHANGING failed   TYPE tt_fail_late
                         reported TYPE tt_reported_late,

      check_before_save CHANGING failed   TYPE tt_fail_late
                                 reported TYPE tt_reported_late,

      cleanup .


  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA : mo_instance TYPE REF TO zcl_ge_gate_wt_api,
                 gt_header   TYPE STANDARD TABLE OF zge_hdr,
                 gr_gateid   TYPE RANGE OF zge_hdr-gate_number,
                 gt_mapped_e TYPE tt_mapped_early.
ENDCLASS.



CLASS ZCL_GE_GATE_WT_API IMPLEMENTATION.


  METHOD check_before_save.


      "Added by Uttam for Result Record
    DATA(ls_gate_header) = VALUE #( gt_header[ 1 ] OPTIONAL ).

    "Need to be checked : it work only Purchase Case & PRGRNQC make : PP/QM
    IF ls_gate_header-gate_type = 'Purchase' AND ls_gate_header-pre_grn_qc IS NOT INITIAL.

      " it check only when Gate Status is not 'Open' & means this only run after Intitil Weighment Done & doing Final Wighment Activity
      IF ls_gate_header-gate_status NE 'Final Weighment Pending'."IF ls_gate_header-gate_status NE 'Open'.
        " It take only Decision has been taken
        SELECT FROM i_insplotusagedecision WITH PRIVILEGED ACCESS AS a
               FIELDS
                 a~inspectionlotusagedecisioncode,
                 a~inspectionlot
               WHERE a~inspectionlot = @ls_gate_header-pre_grn_qc
                 AND a~inspectionlotusagedecisioncode IN ( 'A', 'AD', 'R' )
               INTO TABLE @DATA(lt_ins_dec).

        "it check result recorded or not, if not it give Error MSG : Result Recording Pending
        IF lt_ins_dec IS INITIAL.
          " FAILED entry
          APPEND VALUE #(
              gatenumber  = ls_gate_header-gate_number
              %fail-cause = if_abap_behv=>cause-conflict
          ) TO failed-weight.

          " REPORTED entry with RAP error message
          APPEND VALUE #(
              gatenumber          = ls_gate_header-gate_number
              %state_area         = 'GRN_NUMBER'
              %msg                = NEW zcx_gate(
                                      textid   = zcx_gate=>result_recording
                                      severity = if_abap_behv_message=>severity-error
                                    )
              %element-gatenumber = if_abap_behv=>mk-on
          ) TO reported-weight.

          "if Decision Recorded : as AD Accept with Deviation
          else.

          read TABLE lt_ins_dec into data(ls_ins_dec_AD) index 1.
*
*       "   if Decision Recorded : as AD Accept with Deviation
          if ls_ins_dec_AD-InspectionLotUsageDecisionCode = 'AD'.
                     SELECT FROM zge_hdr WITH PRIVILEGED ACCESS AS a
               FIELDS
                 a~gate_number,
                 a~napr,
                 a~apr
               WHERE a~gate_number = @ls_gate_header-gate_number
               and a~pre_grn_qc = @ls_gate_header-pre_grn_qc

               INTO TABLE @DATA(lt_approval).
*
            if sy-subrc eq 0.
            "It ensure User take Accepted or Rejected Approval
             READ TABLE lt_approval into data(ls_approval) INDEX 1.
            "User approved
            if ls_approval-napr ne 'X' and  ls_approval-apr ne 'X' .


                 APPEND VALUE #(
              gatenumber  = ls_gate_header-gate_number
              %fail-cause = if_abap_behv=>cause-conflict
          ) TO failed-weight.

          " REPORTED entry with RAP error message
          APPEND VALUE #(
              gatenumber          = ls_gate_header-gate_number
              %state_area         = 'GRN_NUMBER'
              %msg                = NEW zcx_gate(
                                      textid   = zcx_gate=>vendor_appr_pending
                                      severity = if_abap_behv_message=>severity-error
                                    )
              %element-gatenumber = if_abap_behv=>mk-on
          ) TO reported-weight.
*
*
*
*
              ENDIF.


        ENDIF.       "if User take Accepted or Rejected Approval

          Endif.


        ENDIF.




      ENDIF.



    ENDIF.


    "End by Uttam for Result Record













    " Start Added by Uttam for Error msg : InitialWTtime > FinalWTtime


*****    DATA(ls_header123) = VALUE #( gt_header[ 1 ] OPTIONAL ).
*****if ( ls_header123-gate_status ne 'Final Weighment Pending' ) and ( ls_header123-gate_status eq 'Gate Out Pending' and ls_header123-final_wt_date is nOT iNITIAL ) .
*****
*****DATA: lv_ts_init   TYPE timestampl,
*****      lv_ts_final  TYPE timestampl,
*****      lv_diff_sec  TYPE i.
*****
*****"------------------------------------------------------------
*****" Convert INITIAL Date + Time → Timestamp
*****"------------------------------------------------------------
*****CONVERT DATE ls_header123-init_wt_date
*****        TIME ls_header123-init_wt_time
*****        INTO TIME STAMP lv_ts_init
*****        TIME ZONE 'UTC'.
*****
*****"------------------------------------------------------------
*****" Convert FINAL Date + Time → Timestamp
*****"------------------------------------------------------------
*****CONVERT DATE ls_header123-FINAL_wt_date
*****        TIME ls_header123-final_wt_time
*****        INTO TIME STAMP lv_ts_final
*****        TIME ZONE 'UTC'.
*****
*****"------------------------------------------------------------
*****" Calculate difference in seconds (Final - Initial)
*****"------------------------------------------------------------
*****
*****DATA: lv_ts_init_plus_24 TYPE timestampl.
*****
*****"lv_ts_init_plus_24 = cl_abap_tstmp=>compare
*****
*****lv_diff_sec = cl_abap_tstmp=>subtract(
*****                tstmp1 = lv_ts_final
*****                tstmp2 = lv_ts_init ).
*****
*****"lv_diff_sec = cl_abap_tstmp=>s
*****
*****
*****"------------------------------------------------------------
*****" Validation: If difference > 24 hours → Error
*****"------------------------------------------------------------
*****
*****
*****SELECT SINGLE approval
*****  FROM ztab_weight_apr
*****  WHERE gate_number = @ls_header123-gate_number
*****    AND approval    = @abap_true
*****  INTO @DATA(lv_approved).
*****
*****
*****
******IF lv_ts_init + 24 * 3600  < lv_ts_final and ls_header123-final_wt_time is NOT INITIAL
******             and ls_header123-gate_type = 'Purchase' and lv_approved ne 'X' .
*****
*****""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*****"Change by Uttam on 09.04.2026
*****""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*****IF lv_diff_sec > 24 * 3600
*****   AND ls_header123-final_wt_time IS NOT INITIAL
*****   AND ls_header123-gate_type = 'Purchase'
*****   AND lv_approved <> 'X'.
*****
*****
*****  " FAILED entry
*****  APPEND VALUE #(
*****      gatenumber  = ls_header123-gate_number
*****      %fail-cause = if_abap_behv=>cause-conflict
*****  ) TO failed-weight.
*****
*****  " REPORTED entry with RAP error message
*****  APPEND VALUE #(
*****      gatenumber          = ls_header123-gate_number
*****      %state_area         = 'GRN_NUMBER'
*****      %msg                = NEW zcx_gate(
*****                              textid   = zcx_gate=>weight_appr
*****                              severity = if_abap_behv_message=>severity-error
*****                            )
*****      %element-gatenumber = if_abap_behv=>mk-on
*****  ) TO reported-weight.
*****
*****ENDIF.
*****
*****
*****endif.



  " End Added bu Uttam for Error msg : InitialWTtime > FinalWTtime

    DATA(ls_header) = VALUE #( gt_header[ 1 ] OPTIONAL ).
    IF ls_header-grn IS NOT INITIAL.
      SELECT SINGLE @abap_true
       FROM i_materialdocumentitem_2
       WHERE  reversedmaterialdocumentyear = @ls_header-grn_year
         AND reversedmaterialdocument = @ls_header-grn
         INTO @DATA(lv_grn_cancel) PRIVILEGED ACCESS.
      IF lv_grn_cancel = abap_false.
        CLEAR : lv_grn_cancel.

        SELECT SINGLE @abap_true
         FROM i_materialdocumentitem_2 AS a
         WHERE  a~referencedocumentfiscalyear = @ls_header-grn_year
           AND a~invtrymgmtreferencedocument = @ls_header-grn
           AND a~invtrymgmtreferencedocument <> a~materialdocument
           INTO @DATA(lv_grn_invtry_cancel) PRIVILEGED ACCESS.
        IF lv_grn_invtry_cancel = abap_false.
          CLEAR : lv_grn_invtry_cancel.
          APPEND VALUE #( gatenumber = ls_header-gate_number
                          %fail-cause = if_abap_behv=>cause-conflict
                           ) TO failed-weight.
          APPEND VALUE #( gatenumber = ls_header-gate_number
                          %state_area = 'GRN_NUMBER'
                           %msg = NEW zcx_gate(
            textid          = zcx_gate=>grn_exists
            severity        = if_abap_behv_message=>severity-error
            grn_num         = CONV string( ls_header-grn )
            gate_number     = ls_header-gate_number
          )
            %element-gatenumber = if_abap_behv=>mk-on
                         ) TO reported-weight.
        ENDIF.
      ENDIF.
      CLEAR : lv_grn_cancel,lv_grn_invtry_cancel.
    ENDIF.
  ENDMETHOD.


  METHOD cleanup.
    CLEAR : gt_header,gt_mapped_e.
  ENDMETHOD.


  METHOD delete_head.

*    IF gr_gateid IS NOT INITIAL.
*      DELETE FROM zge_hdr WHERE gate_number IN @gr_gateid.
*    ENDIF.

    " Populate the range parameter for deletion
    gr_gateid = VALUE #( FOR ls_key IN keys
                           sign = 'I'
                           option = 'EQ'
                          (  low = ls_key-gatenumber ) ).

  ENDMETHOD.


  METHOD finalize.
    "Added by Uttam for Result Record


    " Start Prepare or code Here for GATE ENTRY to Integrate QC Deduction
    DATA(ls_header) = VALUE #( gt_header[ 1 ] OPTIONAL ).
    READ TABLE gt_header ASSIGNING FIELD-SYMBOL(<fs_header>) INDEX 1.
    IF sy-subrc = 0 AND <fs_header> IS ASSIGNED.
      "           <fs_header>-gate_status = 'Gate Out Pending'.
      UNASSIGN <fs_header>.
    ENDIF.

    " End Prepare or code Here for GATE ENTRY to Integrate QC Deduction


    "Need to check just Below IF Condition
    IF ls_header-gate_type = 'Purchase' AND ls_header-pre_grn_qc IS NOT INITIAL.

      " Start To change Gate Status for Initital Weighment

      SELECT FROM i_insplotusagedecision WITH PRIVILEGED ACCESS  AS a
             FIELDS
               a~inspectionlotusagedecisioncode,
               a~inspectionlot
             WHERE a~inspectionlot = @ls_header-pre_grn_qc
             INTO TABLE @DATA(lt_ins_dec).


      " If result recorded & It work only when Initial Weighment Button Click Only
      IF lt_ins_dec IS NOT INITIAL AND ls_header-gate_status = 'Final Weighment Pending'.
        READ TABLE lt_ins_dec INTO DATA(wa_ins_dec) INDEX 1.

        " if rejected - Decision
        IF wa_ins_dec-inspectionlotusagedecisioncode EQ 'R'.

          READ TABLE gt_header ASSIGNING <fs_header> INDEX 1.
          IF sy-subrc = 0 AND <fs_header> IS ASSIGNED.
            <fs_header>-gate_status = 'Gate Out Pending'.
            UNASSIGN <fs_header>.
          ENDIF.

          "If Accepted - A
        ELSEIF wa_ins_dec-inspectionlotusagedecisioncode EQ 'A'.

          READ TABLE gt_header ASSIGNING <fs_header> INDEX 1.
          IF sy-subrc = 0 AND <fs_header> IS ASSIGNED.
            <fs_header>-gate_status = 'Final Weighment Pending'.
            UNASSIGN <fs_header>.
          ENDIF.
          " If still not record Data
        ELSEIF wa_ins_dec-inspectionlotusagedecisioncode EQ ' '. " or     elseif wa_ins_dec-InspectionLotUsageDecisionCode eq ''.

          READ TABLE gt_header ASSIGNING <fs_header> INDEX 1.
          IF sy-subrc = 0 AND <fs_header> IS ASSIGNED.
            <fs_header>-gate_status = 'Final Weighment Pending'.
            UNASSIGN <fs_header>.
          ENDIF.

          " if Accept Under Deviation - Decision
        ELSEIF wa_ins_dec-inspectionlotusagedecisioncode EQ 'AD'.

"Start Comment By Uttam to remove Email Pending.

* READ TABLE gt_header ASSIGNING <fs_header> INDEX 1.
*          IF sy-subrc = 0 AND <fs_header> IS ASSIGNED.
*            <fs_header>-gate_status = 'Email Pending'.
*            UNASSIGN <fs_header>.
*          ENDIF.
"End Comment By Uttam o remove Email Pending.


        ENDIF.


      ENDIF.


      " End To change Gate Status for Initital Weighment





      " Start To change Gate Status for Final Weighment





      IF ls_header-gate_status NE 'Final Weighment Pending'. "or  ls_header-gate_status EQ 'Gate Out Pending'
        " It take only Decision has been taken
        SELECT FROM i_insplotusagedecision WITH PRIVILEGED ACCESS AS a
               FIELDS
                 a~inspectionlotusagedecisioncode,
                 a~inspectionlot
               WHERE a~inspectionlot = @ls_header-pre_grn_qc
                 AND a~inspectionlotusagedecisioncode IN ( 'A', 'AD', 'R' )
               INTO TABLE @DATA(lt_ins_dec_final).

        "it check result recorded or not, if not it give Error MSG : Result Recording Pending
        IF lt_ins_dec_final IS NOT INITIAL.


          CLEAR : wa_ins_dec.
          READ TABLE lt_ins_dec_final INTO wa_ins_dec INDEX 1.

          " if rejected - Decision
          IF wa_ins_dec-inspectionlotusagedecisioncode EQ 'R'.

            READ TABLE gt_header ASSIGNING <fs_header> INDEX 1.
            IF sy-subrc = 0 AND <fs_header> IS ASSIGNED.
              <fs_header>-gate_status = 'Gate Out Pending'.
              UNASSIGN <fs_header>.
            ENDIF.

            "If Accepted - A
          ELSEIF wa_ins_dec-inspectionlotusagedecisioncode EQ 'A'.

            READ TABLE gt_header ASSIGNING <fs_header> INDEX 1.
            IF sy-subrc = 0 AND <fs_header> IS ASSIGNED.
              <fs_header>-gate_status = 'Gate Out Pending'.
              UNASSIGN <fs_header>.
            ENDIF.
            " If still not record Data
          ELSEIF wa_ins_dec-inspectionlotusagedecisioncode EQ ' '. " or     elseif wa_ins_dec-InspectionLotUsageDecisionCode eq ''.

            READ TABLE gt_header ASSIGNING <fs_header> INDEX 1.
            IF sy-subrc = 0 AND <fs_header> IS ASSIGNED.
              <fs_header>-gate_status = 'Final Weighment Pending'.
              UNASSIGN <fs_header>.
            ENDIF.

            " if Accept Under Deviation - Decision
          ELSEIF wa_ins_dec-inspectionlotusagedecisioncode EQ 'AD'.

"Start Comment By Uttam to remove Email Pending.
*            READ TABLE gt_header ASSIGNING <fs_header> INDEX 1.
*            IF sy-subrc = 0 AND <fs_header> IS ASSIGNED.
*              <fs_header>-gate_status = 'Email Pending'.
*              UNASSIGN <fs_header>.
*            ENDIF.
"End Comment By Uttam to remove Email Pending.

            SELECT FROM zge_hdr WITH PRIVILEGED ACCESS AS a
               FIELDS
                 a~gate_number,
                 a~apr,
                 a~napr
               WHERE a~gate_number = @ls_header-gate_number
               and a~pre_grn_qc = @ls_header-pre_grn_qc

               INTO TABLE @DATA(lt_approval).

            if sy-subrc eq 0.
            "It ensure User take Accepted or Rejected Approval
             READ TABLE lt_approval into data(ls_approval) INDEX 1.
            "User approved
            if ls_approval-napr eq 'X' or ls_approval-napr eq 'X' .

              READ TABLE gt_header ASSIGNING <fs_header> INDEX 1.
              IF sy-subrc = 0 AND <fs_header> IS ASSIGNED.
                <fs_header>-gate_status = 'Gate Out Pending'.
                UNASSIGN <fs_header>.
              ENDIF.
                ENDIF.


        ENDIF.       "if User take Accepted or Rejected Approval

          ENDIF.







        ENDIF.



      ENDIF.








      " End To change Gate Status for Final Weighment






      "End by Uttam for Result Record
    ENDIF.

  ENDMETHOD.


  METHOD get_instance.
    mo_instance = ro_value = COND #( WHEN mo_instance IS BOUND THEN mo_instance
                                     ELSE NEW #(  ) ).
  ENDMETHOD.


  METHOD read.

    IF keys[] IS NOT INITIAL.
      SELECT *
      FROM zge_hdr
      FOR ALL ENTRIES IN @keys
      WHERE gate_number = @keys-gatenumber
        AND gate_status IN ( 'Open', 'Weighment Pending' )
      INTO TABLE @DATA(lt_header).

*    Populate data to result
      result = CORRESPONDING #( lt_header MAPPING TO ENTITY ).

    ENDIF.
  ENDMETHOD.


  METHOD save.

    " Store the record into DB
    IF gt_header IS NOT INITIAL.

    "change by Uttam for QC Deduction on 1.2.2026
    LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_gate>).


    SELECT SINGLE from zge_i_head WITH PRIVILEGED ACCESS as a
    FIELDS Email_Sent, Apr_sta, Napr_sta
    WHERE PreGrnQc = @<fs_gate>-pre_grn_qc
    into @data(ls_gate_update).

        <fs_gate>-em_sent = ls_gate_update-Email_Sent.
        <fs_gate>-apr = ls_gate_update-Apr_sta.
        <fs_gate>-napr = ls_gate_update-Napr_sta.

    endloop.
      MODIFY zge_hdr FROM TABLE @gt_header.

    ENDIF.


    IF gr_gateid[] IS NOT INITIAL.
      "Delete Header
      "   DELETE FROM zge_hdr WHERE gate_number IN @gr_gateid.
    ENDIF.

  ENDMETHOD.


  METHOD update_head.
    DATA : lt_head_x  TYPE STANDARD TABLE OF zge_s_hdr_x.

    " Fill Buffer data
    gt_header = CORRESPONDING #( entities MAPPING FROM ENTITY ).

    lt_head_x = CORRESPONDING #( entities MAPPING FROM ENTITY USING CONTROL ).
    DATA(ls_data_u) = VALUE #( gt_header[ 1 ] OPTIONAL ).
    DATA(ls_data_x) = VALUE #( lt_head_x[ 1 ] OPTIONAL ).

    SELECT SINGLE FROM zge_hdr
     FIELDS *
    WHERE gate_number = @ls_data_u-gate_number
    INTO @DATA(ls_head_old).

    gt_header = VALUE #(
                     (
                           gate_number = ls_head_old-gate_number
                           created_by = ls_head_old-created_by
                           created_on = ls_head_old-created_on
                           creation_time = ls_head_old-creation_time
*                           is_cancelled = ls_head_old-is_cancelled
                           grn = ls_head_old-grn
                           grn_year = ls_head_old-grn_year
                           gate_out_date = ls_head_old-gate_out_date
                           gate_out_time = ls_head_old-gate_out_time
                           driver_name = ls_head_old-driver_name
                           driver_lic = ls_head_old-driver_lic
                           driver_number = ls_head_old-driver_number
                           transporter = ls_head_old-transporter
                           transporter_name = ls_head_old-transporter_name
                           ebeln = ls_head_old-ebeln
                           vbeln = ls_head_old-vbeln
                           lifnr = ls_head_old-lifnr
                           supplier_name = ls_head_old-supplier_name "#EC CI_VALPAR
                           kunnr = ls_head_old-kunnr
                           customer_name = ls_head_old-customer_name
                           werks = ls_head_old-werks
                           plantname = ls_head_old-plantname
                           pre_grn_qc = ls_head_old-pre_grn_qc
*                           vehicle_type = ls_head_old-vehicle_type
                           vehichle_no = ls_head_old-vehichle_no
                           gate_type = ls_head_old-gate_type
                           lr_rr_no = ls_head_old-lr_rr_no
                           bill_of_landing = ls_head_old-bill_of_landing
                           gate_in_date = ls_head_old-gate_in_date
                           gate_in_time = ls_head_old-gate_in_time
                           vendor_invoice_no = ls_head_old-vendor_invoice_no
                           vendor_invoice_dt = ls_head_old-vendor_invoice_dt
*                           cancel_remark = ls_head_old-cancel_remark
                           reporting_date = ls_head_old-reporting_date
                           reporting_time = ls_head_old-reporting_time
                           vehicle_type = ls_head_old-vehicle_type
                           remark = ls_head_old-remark
                           gatepasscode = ls_head_old-gatepasscode
                           entry_gate = ls_head_old-entry_gate
                           gate_pass_type = ls_head_old-gate_pass_type
                           invoicenumber = ls_head_old-invoicenumber
                           cancel_remark = COND #( WHEN ls_data_x-cancel_remark IS NOT INITIAL THEN ls_data_u-cancel_remark ELSE ls_head_old-cancel_remark  )
                           is_cancelled = COND #( WHEN ls_data_x-is_cancelled IS NOT INITIAL THEN ls_data_u-is_cancelled ELSE ls_head_old-is_cancelled  )
                           gate_status = COND #( WHEN ls_data_x-gate_status IS NOT INITIAL THEN ls_data_u-gate_status ELSE ls_head_old-gate_status  )
                           gross_weight = COND #( WHEN ls_data_x-gross_weight IS NOT INITIAL THEN ls_data_u-gross_weight ELSE ls_head_old-gross_weight  )
                           tare_weight = COND #( WHEN ls_data_x-tare_weight IS NOT INITIAL THEN ls_data_u-tare_weight ELSE ls_head_old-tare_weight  )
                           packing_unit = COND #( WHEN ls_data_x-packing_unit IS NOT INITIAL THEN ls_data_u-packing_unit ELSE ls_head_old-packing_unit  )
                           net_weight = COND #( WHEN ls_data_x-net_weight IS NOT INITIAL THEN ls_data_u-net_weight ELSE ls_head_old-net_weight  )
                           weight_required = COND #( WHEN ls_data_x-weight_required IS NOT INITIAL THEN ls_data_u-weight_required ELSE ls_head_old-weight_required  )
                           weight_skip = COND #( WHEN ls_data_x-weight_skip IS NOT INITIAL THEN ls_data_u-weight_skip ELSE ls_head_old-weight_skip  )
                           init_wt_date = COND #( WHEN ls_data_x-init_wt_date IS NOT INITIAL THEN ls_data_u-init_wt_date ELSE ls_head_old-init_wt_date  )
                           init_wt_time = COND #( WHEN ls_data_x-init_wt_time IS NOT INITIAL THEN ls_data_u-init_wt_time ELSE ls_head_old-init_wt_time  )
                           final_wt_date = COND #( WHEN ls_data_x-final_wt_date IS NOT INITIAL THEN ls_data_u-final_wt_date ELSE ls_head_old-final_wt_date  )
                           final_wt_time = COND #( WHEN ls_data_x-final_wt_time IS NOT INITIAL THEN ls_data_u-final_wt_time ELSE ls_head_old-final_wt_time  )
                           vendor_slip = COND #( WHEN ls_data_x-vendor_slip IS NOT INITIAL THEN ls_data_u-vendor_slip ELSE ls_head_old-vendor_slip  )
                           vendor_gross_weight = COND #( WHEN ls_data_x-vendor_gross_weight IS NOT INITIAL THEN ls_data_u-vendor_gross_weight ELSE ls_head_old-vendor_gross_weight  )
                           vendor_tare_weight = COND #( WHEN ls_data_x-vendor_tare_weight IS NOT INITIAL THEN ls_data_u-vendor_tare_weight ELSE ls_head_old-vendor_tare_weight  )
*                           gate_pass_type = COND #( WHEN ls_data_x-gate_pass_type IS NOT INITIAL THEN ls_data_u-gate_pass_type ELSE ls_head_old-gate_pass_type  )
*                           gatepasscode = COND #( WHEN ls_data_x-gatepasscode IS NOT INITIAL THEN ls_data_u-gatepasscode ELSE ls_head_old-gatepasscode  )
*                           entry_gate = COND #( WHEN ls_data_x-entry_gate IS NOT INITIAL THEN ls_data_u-entry_gate ELSE ls_head_old-entry_gate  )
                           init_weighbridgecode = COND #( WHEN ls_data_x-init_weighbridgecode IS NOT INITIAL THEN ls_data_u-init_weighbridgecode ELSE ls_head_old-init_weighbridgecode  )
                           wtticketno = COND #( WHEN ls_data_x-wtticketno IS NOT INITIAL THEN ls_data_u-wtticketno ELSE ls_head_old-wtticketno  )
                           final_weighbridgecode = COND #( WHEN ls_data_x-final_weighbridgecode IS NOT INITIAL THEN ls_data_u-final_weighbridgecode ELSE ls_head_old-final_weighbridgecode  )
*                           visitor = COND #( WHEN ls_data_x-visitor IS NOT INITIAL THEN ls_data_u-visitor ELSE ls_head_old-visitor  )


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*Commented Code Start
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*
*                     gross_weight1 = COND #(
*    WHEN ls_data_x-gross_weight1 IS NOT INITIAL
*    THEN ls_data_u-gross_weight1
*    ELSE ls_head_old-gross_weight1
*)
*
*tare_weight1 = COND #(
*    WHEN ls_data_x-tare_weight1 IS NOT INITIAL
*    THEN ls_data_u-tare_weight1
*    ELSE ls_head_old-tare_weight1
*)
*
*net_weight1 = COND #(
*    WHEN ls_data_x-net_weight1 IS NOT INITIAL
*    THEN ls_data_u-net_weight1
*    ELSE ls_head_old-net_weight1
*)
*
*weight_remark1 = COND #(
*    WHEN ls_data_x-weight_remark1 IS NOT INITIAL
*    THEN ls_data_u-weight_remark1
*    ELSE ls_head_old-weight_remark1
*)
*
*gross_weight2 = COND #(
*    WHEN ls_data_x-gross_weight2 IS NOT INITIAL
*    THEN ls_data_u-gross_weight2
*    ELSE ls_head_old-gross_weight2
*)
*
*tare_weight2 = COND #(
*    WHEN ls_data_x-tare_weight2 IS NOT INITIAL
*    THEN ls_data_u-tare_weight2
*    ELSE ls_head_old-tare_weight2
*)
*
*net_weight2 = COND #(
*    WHEN ls_data_x-net_weight2 IS NOT INITIAL
*    THEN ls_data_u-net_weight2
*    ELSE ls_head_old-net_weight2
*)
*
*weight_remark2 = COND #(
*    WHEN ls_data_x-weight_remark2 IS NOT INITIAL
*    THEN ls_data_u-weight_remark2
*    ELSE ls_head_old-weight_remark2
*)
*
*gross_weight3 = COND #(
*    WHEN ls_data_x-gross_weight3 IS NOT INITIAL
*    THEN ls_data_u-gross_weight3
*    ELSE ls_head_old-gross_weight3
*)
*
*tare_weight3 = COND #(
*    WHEN ls_data_x-tare_weight3 IS NOT INITIAL
*    THEN ls_data_u-tare_weight3
*    ELSE ls_head_old-tare_weight3
*)
*
*net_weight3 = COND #(
*    WHEN ls_data_x-net_weight3 IS NOT INITIAL
*    THEN ls_data_u-net_weight3
*    ELSE ls_head_old-net_weight3
*)
*
*weight_remark3 = COND #(
*    WHEN ls_data_x-weight_remark3 IS NOT INITIAL
*    THEN ls_data_u-weight_remark3
*    ELSE ls_head_old-weight_remark3
*)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*Commented Code End
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

gross_weight1   = ls_data_u-gross_weight1
tare_weight1    = ls_data_u-tare_weight1
net_weight1     = ls_data_u-net_weight1
weight_remark1  = ls_data_u-weight_remark1

gross_weight2   = ls_data_u-gross_weight2
tare_weight2    = ls_data_u-tare_weight2
net_weight2     = ls_data_u-net_weight2
weight_remark2  = ls_data_u-weight_remark2

gross_weight3   = ls_data_u-gross_weight3
tare_weight3    = ls_data_u-tare_weight3
net_weight3     = ls_data_u-net_weight3
weight_remark3  = ls_data_u-weight_remark3

                     )

    ).



  ENDMETHOD.
ENDCLASS.
