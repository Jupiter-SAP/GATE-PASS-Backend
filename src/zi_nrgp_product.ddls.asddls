@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_NRGP_PRODUCT
  as select from    I_Product     as a
    left outer join I_ProductText as b on  b.Product  = a.Product
                                       and b.Language = 'E'
{
  key cast(a.Product as abap.char(40))     as ItemCode,
  key cast(b.ProductName as abap.char(50)) as ItemName,
      a.BaseUnit                           as Unit,
      cast(a.NetWeight as abap.dec(15,3))  as NetWeight
}
