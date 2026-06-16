@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Gate report'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zge_i_ge_report
  as select from zge_i_item
  association [0..1] to zge_i_head       as _Head  on  $projection.GateNumber = _Head.GateNumber
 //   association to I_BusinessUserVH as _User on _Head.CreatedBy = _User.UserID
{
  key GateNumber,
  key ItemNumber,
      _Head.PurchasingDoc,
      PurchaseOrderItem,
      Matnr,
      Maktx,
      StorageLocation,
      Batch,
      QtyOrdered,
      QtyReceived,
      TotalGeQty,
      Meins,
      Uom,
      Tolerance,
      Werks,
      QtyOut,
      QtyIn,
      ItemRemark,
      _Head.InvoiceNumber        as InvoiceNumber,
      _Head.GateType             as GateType,
      _Head.GateStatus           as GateStatus,
      _Head.GatePassType         as GatePassType,
      _Head.GatePassCode         as GatePassCode,
      _Head.EntryGate            as EntryGate,
      _Head.IsCancelled          as IsCancelled,
      _Head.VehichleNo           as VehichleNo,
      _Head.LrRrNo               as LrRrNo,
      _Head.BillOfLanding        as BillOfLanding,
      _Head.VendorInvoiceNo      as VendorInvoiceNo,
      _Head.VendorInvoiceDt      as VendorInvoiceDt,
      _Head.GateInDate           as GateInDate,
      _Head.GateInTime           as GateInTime,
      _Head.GateOutDate          as GateOutDate,
      _Head.GateOutTime          as GateOutTime,
      _Head.SalesDocument        as SalesDocument,
      _Head.Supplier             as Supplier,
      _Head.SupplierName         as SupplierName,
      _Head.Customer             as Customer,
      _Head.CustomerName         as CustomerName,
      _Head.Plant                as Plant,
      _Head.PlantName            as PlantName,
      _Head.CreatedBy            as CreatedBy,
     _Head.UserName              as Username,
      _Head.CreatedOn            as CreatedOn,
      _Head.CreationTime         as CreationTime,
      _Head.ReportingDate        as ReportingDate,
      _Head.ReportingTime        as ReportingTime,
      _Head.GrossWeight         as GrossWeight,
      _Head.TareWeight          as TareWeight,
      _Head.PackingUnit          as PackingUnit,
      _Head.NetWeight           as NetWeight,
      _Head.WeightRequired       as WeightRequired,
      _Head.WeightSkip           as WeightSkip,
      _Head.InitWtDate           as InitWtDate,
      _Head.InitWtTime           as InitWtTime,
      _Head.FinalWtDate          as FinalWtDate,
      _Head.FinalWtTime          as FinalWtTime,
      _Head.VendorSlip           as VendorSlip,
      _Head.VendorGrossWeight   as VendorGrossWeight,
      _Head.VendorTareWeight    as VendorTareWeight,
      _Head.Grn                  as Grn,
      _Head.GrnYear              as GrnYear,
      _Head.PreGrnQc             as PreGrnQc,
      _Head.Purpose              as Purpose,
      _Head.PersonConcerned      as PersonConcerned,
      _Head.PersonArrived        as PersonArrived,
      _Head.ContactNumber        as ContactNumber,
      _Head.NumberOfPerson       as NumberOfPerson,
      _Head.ReturnDate           as ReturnDate,
      _Head.ReturnTime           as ReturnTime,
      _Head.DriverName           as DriverName,
      _Head.DriverNumber         as DriverNumber,
      _Head.Transporter          as Transporter,
      _Head.TransporterName      as TransporterName,
      _Head.VehicleType          as VehicleType,
      _Head.DriverLic            as DriverLic,
      _Head.Remark               as Remark,
      _Head.CancelRemark         as CancelRemark,
      _Head.Visitor              as Visitor,
      _Head.RefDocNumber         as RefDocNumber,
      _Head.WeighTicketNo        as WeighTicketNo,
      _Head.InitWeighBridgeCode  as InitWeighBridgeCode,
      _Head.FinalWeighBridgeCode as FinalWeighBridgeCode,
//      Added by Uttam for QC with Discuss Sagar Kore Sir

      _Head.Email_Sent,
      _Head.Apr_sta,
      _Head.Napr_sta,
      
      
      
      //   Added by Uttam to add 12 Fields related to Multiple Weight Calculate
      _Head.GrossWeight1    as GrossWeight1,
      _Head.GrossWeight2    as GrossWeight2,
      _Head.GrossWeight3    as GrossWeight3,

      _Head.NetWeight1      as NetWeight1,
      _Head.NetWeight2      as NetWeight2,
      _Head.NetWeight3      as NetWeight3,

      _Head.TareWeight1     as TareWeight1,
      _Head.TareWeight2     as TareWeight2,
      _Head.TareWeight3     as TareWeight3,

      _Head.WeightRemarks1  as WeightRemarks1,
      _Head.WeightRemarks2  as WeightRemarks2,
      _Head.WeightRemarks3  as WeightRemarks3,
      
      
          //   Added by Uttam to add New PO Number Fields for Change PO on GRN APP on 14.04.2026
    _Head.NewPONumber
      
}
where
  GateNumber is not initial
