@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Tax Code'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TAXCODE_VH as select from I_TaxCodeText as a
    join I_TaxCodeRate as b on a.TaxCode = b.TaxCode
{
    key cast(a.TaxCode as abap.char(2)) as TaxCode,
    b.ConditionRateRatio,
    b.AccountKeyForGLAccount
}
where b.AccountKeyForGLAccount = 'JII'
   or b.AccountKeyForGLAccount = 'JIS'
   and b.Country = 'IN'
   and b.CndnRecordValidityEndDate = '99991231'
   and (
        a.TaxCode = 'I0' or a.TaxCode = 'I1' or a.TaxCode = 'I2' or a.TaxCode = 'I3' or a.TaxCode = 'I4' 
     or a.TaxCode = 'I5' or a.TaxCode = 'I6' or a.TaxCode = 'I7' or a.TaxCode = 'I8' or a.TaxCode = 'I9'
     or a.TaxCode = 'F5' or a.TaxCode = 'H3' or a.TaxCode = 'H4' or a.TaxCode = 'H5' or a.TaxCode = 'H6' 
     or a.TaxCode = 'J3' or a.TaxCode = 'G6' or a.TaxCode = 'G7'
     or a.TaxCode = 'MA' or a.TaxCode = 'MB' or a.TaxCode = 'MC' or a.TaxCode = 'MD'
     or a.TaxCode = 'N0' or a.TaxCode = 'N1' or a.TaxCode = 'N2' or a.TaxCode = 'N3' or a.TaxCode = 'N4'
     or a.TaxCode = 'N5' or a.TaxCode = 'N6' or a.TaxCode = 'N7' or a.TaxCode = 'N8' or a.TaxCode = 'N9'
   );
