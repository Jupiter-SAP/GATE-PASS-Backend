@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for RGP header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZCDS_RGP_HDR
  as select from zgate_rgp_hdr
{
      @EndUserText.label: 'Document Number'
      @UI.selectionField: [{ position: 10 }]
      @UI.lineItem: [{ position: 10 , label: 'Document Number'}]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZCDS_RGP_HDR', element: 'Documentnumber' } }]
      key document_no           as Documentnumber,
      @EndUserText.label: 'Document Date'
      document_date         as Documentdate,
      @EndUserText.label: 'Plant'
      @UI.selectionField: [{ position: 20 }]
      @UI.lineItem: [{ position: 20 , label: 'Plant'}]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZCDS_RGP_HDR', element: 'Plant' } }]
      plant                 as Plant,
      @EndUserText.label: 'From Storage Location'
      from_storage_location as FromStorageLocation,
      @EndUserText.label: 'To Storage Location'
      to_storage_location   as ToStorageLocation,
      @EndUserText.label: 'Status'
      status                as Status,
      @EndUserText.label: 'Description 1'
      description1          as Description1,
      @EndUserText.label: 'Description 2'
      description2          as Description2,
      @EndUserText.label: 'Partner Code'
      partner_code          as PartnerCode,
      @EndUserText.label: 'Partner Name'
      partner_name          as PartnerName,
      @EndUserText.label: 'Partner Type'
      partner_type          as PartnerType,
      @EndUserText.label: 'Address 1'
      address1              as Address1,
      @EndUserText.label: 'Address 2'
      address2              as Address2,
      @EndUserText.label: 'State Code'
      state_code            as StateCode,
      @EndUserText.label: 'Pin'
      pin                   as Pin,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt

}
