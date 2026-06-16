@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Gate Header'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #M,
    dataClass: #MIXED
}

define view entity zge_i_head
  as select from zge_hdr
  association [0..1] to I_BusinessUserVH as _User on $projection.CreatedBy = _User.UserID
{
  key gate_number           as GateNumber,
      gate_type             as GateType,
      gate_pass_type        as GatePassType,
      gatepasscode          as GatePassCode,
      entry_gate            as EntryGate,
      gate_status           as GateStatus,
      is_cancelled          as IsCancelled,
      @EndUserText.label: 'Vehicle No'
      vehichle_no           as VehichleNo,
      lr_rr_no              as LrRrNo,
      bill_of_landing       as BillOfLanding,
      vendor_invoice_no     as VendorInvoiceNo,
      vendor_invoice_dt     as VendorInvoiceDt,
      gate_in_date          as GateInDate,
      gate_in_time          as GateInTime,
      gate_out_date         as GateOutDate,
      gate_out_time         as GateOutTime,
      ebeln                 as PurchasingDoc,
      vbeln                 as SalesDocument,
      invoicenumber         as InvoiceNumber,
      lifnr                 as Supplier,
      supplier_name         as SupplierName,
      kunnr                 as Customer,
      customer_name         as CustomerName,
      werks                 as Plant,
      plantname             as PlantName,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      created_on            as CreatedOn,
      creation_time         as CreationTime,
      gross_weight          as GrossWeight,
      tare_weight           as TareWeight,
      packing_unit          as PackingUnit,
      net_weight            as NetWeight,
      weight_required       as WeightRequired,
      weight_skip           as WeightSkip,
      init_weighbridgecode  as InitWeighBridgeCode,
      final_weighbridgecode as FinalWeighBridgeCode,
      init_wt_date          as InitWtDate,
      init_wt_time          as InitWtTime,
      final_wt_date         as FinalWtDate,
      final_wt_time         as FinalWtTime,
      vendor_slip           as VendorSlip,
      vendor_gross_weight   as VendorGrossWeight,
      vendor_tare_weight    as VendorTareWeight,
      reporting_date        as ReportingDate,
      reporting_time        as ReportingTime,
      grn_doc_date          as GrnDocDate,
      grn_post_date         as GrnPostDate,
      grn_header_text       as GrnHeaderText,
      delivery_note         as DeliveryNote,
      grn                   as Grn,
      grn_year              as GrnYear,
      grnstatus             as GrnStatus,
      cancelgrn             as CancelGrn,
      pre_grn_qc            as PreGrnQc,
      purpose               as Purpose,
      person_concerned      as PersonConcerned,
      person_arrived        as PersonArrived,
      contact_number        as ContactNumber,
      number_of_person      as NumberOfPerson,
      return_date           as ReturnDate,
      return_time           as ReturnTime,
      driver_name           as DriverName,
      driver_number         as DriverNumber,
      transporter           as Transporter,
      transporter_name      as TransporterName,
      vehicle_type          as VehicleType,
      driver_lic            as DriverLic,
      remark                as Remark,
      cancel_remark         as CancelRemark,
      visitor               as Visitor,
      ref_doc_number        as RefDocNumber,
      wtticketno            as WeighTicketNo,
      del_flag              as DelFlag,
      del_remark            as DelRemark,
      
      _User.PersonFullName as UserName,
      _User,
////      Added BY RB on date 31.02.1026
      em_sent               as Email_Sent,     //Email Sent status will update from qc email interface
      apr                   as Apr_sta,       // Approve Status will  update from qc email interface
      napr                  as Napr_sta,      // Not Approve Status will  update from qc email interface
//      email_del_flag          //Added skipped BY RB on Date 22.01.2026 as an email sent status for qc email interface here D denoted that email has been sent  
   
//   Added by Uttam to add 12 Fields related to Multiple Weight Calculate
    gross_weight1 as GrossWeight1,
    gross_weight2 as GrossWeight2,
    gross_weight3 as GrossWeight3,
    
    net_weight1 as NetWeight1,
    net_weight2 as NetWeight2,
    net_weight3 as NetWeight3,
    
    tare_weight1 as TareWeight1,
    tare_weight2 as TareWeight2,
    tare_weight3 as TareWeight3,
    
    weight_remark1 as WeightRemarks1,
    weight_remark2 as WeightRemarks2,
    weight_remark3 as WeightRemarks3,
    
    
    //   Added by Uttam to add New PO Number Fields for Change PO on GRN APP on 13.04.2026
    new_po_num as NewPONumber,
//    changes by smriti 
amount_deduction_qc as AmountDeuctionQc
    
}
