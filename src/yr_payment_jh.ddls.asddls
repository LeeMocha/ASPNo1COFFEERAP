@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '지출'
define root view entity YR_PAYMENT_JH as select from ytb_payment_jh
{
    key uuid as Uuid,
    @Semantics.systemDateTime.createdAt: true
    payment_date as PaymentDate,
    payment_description as PaymentDescription,
    payment_amount as PaymentAmount,
    unit as Unit,
    @Semantics.user.createdBy: true
    createby      as Createby,
    @Semantics.systemDateTime.createdAt: true
    createdat     as Createdat,
    @Semantics.user.lastChangedBy: true
    lastchangedby as Lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true
    lastchangedat as Lastchangedat
}
