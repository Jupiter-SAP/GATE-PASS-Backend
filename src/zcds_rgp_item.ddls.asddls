@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for RGP ITEM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZCDS_RGP_ITEM
  as select from zgate_rgp_item
{
  key document_no           as Documentnumber,
  key line_no               as Linenumber,
  key rgp_no                as Rgpno,
  key rgp_line_no           as Rgp_line_no,
  key reference_document    as Referencedocument,
  key reference_doc_item    as Reference_documentitem,
  key reference_doc_year    as Reference_docyear,
      rgp_date              as Rgpdate,
      reference_doc_date    as Reference_docdate,
      item_code             as ItemCode,
      item_name             as ItemName,
      description           as Description,
      qty                   as Qty,
      unit                  as Unit,
      rate                  as Rate,
      item_amount           as ItemAmount,
      tax_code              as TaxCode,
      tax_percent           as TaxPercent,
      tax_amount            as TaxAmount,
      net_amount            as NetAmount,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt
}
