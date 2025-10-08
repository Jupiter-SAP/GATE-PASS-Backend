@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zc_nrgp_item2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zc_nrgp_item2
  as select from ZC_GATE_NRGP_ITEM
{
            key DocumentNo,
            LineNum,
            NrgpDate,
            ReferenceDocDate,
            ItemCode,
            ItemName,
            Description,
            Qty,
            Unit,
            StorageLocation,
            Plant,
            Rate,
            ItemAmount,
            TaxCode,
            TaxPercent,
            TaxAmount,
            NetAmount,
            NetWeight,
            Batch,
            CostCenter
      //      CreatedBy,
      //      CreatedAt,
      //      LastChangedBy,
      //      LastChangedAt,
      //      LocalLastChangedAt
}
