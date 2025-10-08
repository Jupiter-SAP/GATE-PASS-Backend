@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for rgp vaue help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_RGP_VH as select from I_Supplier as VEN
join I_Address_2 as Address on VEN.AddressID = Address.AddressID
{
    key cast(VEN.Supplier as abap.char(15)) as PartnerCode,
    key cast('Vendor' as abap.char(30)) as EntityType,
    key cast(VEN.SupplierName as abap.char(50)) as PartnerName,
    Address.AddresseeFullName  as Address1,
    VEN.Region as StateCode,
    VEN.PostalCode as Pin,
    
    
    cast('' as abap.char(15)) as itemCode,
    cast('' as abap.char(50)) as ItemName,
    cast(0 as abap.dec(15,3)) as Rate
    
}



union

select from I_Customer as CUS
join I_Address_2 as Address on CUS.AddressID = Address.AddressID
{

key cast(CUS.Customer as abap.char(15)) as PartnerCode,
key cast('Customer' as abap.char(30)) as EntityType,
    key cast(CUS.CustomerFullName as abap.char(50)) as PartnerName,
    Address.AddresseeFullName  as Address1,
    CUS.Region as StateCode,
    CUS.PostalCode as Pin,
    
    
    cast('' as abap.char(15)) as itemCode,
    cast('' as abap.char(50)) as ItemName,
    cast(0 as abap.dec(15,3)) as Rate

}



union

select from I_Product as PROD
{
    key cast(PROD.Product as abap.char(15)) as PartnerCode,
    key cast('Product' as abap.char(30)) as EntityType,
    key cast(PROD.ProductExternalID as abap.char(50)) as PartnerName,
    cast('' as abap.char(100)) as Address1,
    cast('' as abap.char(10)) as StateCode,
    cast('' as abap.char(10)) as Pin,

    cast(PROD.Product as abap.char(15)) as itemCode,
    cast(PROD.ProductExternalID as abap.char(50)) as ItemName,
    PROD.NetWeight as Rate
}
;
