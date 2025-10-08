@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for ZCDS_RGP_HDR'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_RGP_HDR
  provider contract transactional_query
  as projection on ZCDS_RGP_HDR
{
  key Documentnumber,
      Documentdate,
      ToStorageLocation,
      Status,
      Description1,
      Description2,
      PartnerCode,
      PartnerName,
      PartnerType,
      Address1,
      Address2,
      StateCode,
      Pin,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
