@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCDS_RGP_ITEM EXTENDED'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_RGP_ITEM_EXTEND as select from zgate_rgp_item
{
key document_no as document_no,
line_no as line_no,
rgp_no as rgp_no,
rgp_line_no as rgp_line_no,
reference_document as reference_document,
reference_doc_item as reference_doc_item,
reference_doc_year as reference_doc_year,
rgp_date as rgp_date,
reference_doc_date as reference_doc_date,
batch as batch,
weight as weight,
item_code as item_code,
item_name as item_name,
description as description,
qty as qty,
unit as unit,
rate as rate,
item_amount as item_amount,
tax_code as tax_code,
tax_percent as tax_percent,
tax_amount as tax_amount,
net_amount as net_amount,
created_by as created_by,
created_at as created_at,
last_changed_by as last_changed_by,
last_changed_at as last_changed_at,
local_last_changed_at as local_last_changed_at   
}
