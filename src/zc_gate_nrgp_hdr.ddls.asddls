@Metadata.allowExtensions: true
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DATA DEFINITION FOR GATE NRGP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_GATE_NRGP_HDR as select from zgate_nrgp_hdr
{
    key document_no as DocumentNo,
    plant as Plant,
    partner_type as PartnerType,
    partner_code as PartnerCode,
    document_date as DocumentDate,
    partner_name as PartnerName,
    from_storage_loc as FromStorageLoc,
    addr1 as Addr1,
    addr2 as Addr2,
    state_code as StateCode,
    pin as Pin,
    status as Status,
    description1 as Description1,
    description2 as Description2,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt,
    local_last_changed_at as LocalLastChangedAt
}
