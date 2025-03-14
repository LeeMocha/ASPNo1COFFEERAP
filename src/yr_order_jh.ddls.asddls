@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '주문'
define root view entity YR_ORDER_JH as select from ytb_order_jh
    composition [1..*] of YR_ORDERITEM_JH as _OrderItem
{

    key uuid as Uuid,
    order_code as OrderCode,
    @Semantics.systemDateTime.createdAt: true
    order_date as OrderDate,
    @Semantics.user.createdBy: true
    createby      as Createby,
    @Semantics.systemDateTime.createdAt: true
    createdat     as Createdat,
    @Semantics.user.lastChangedBy: true
    lastchangedby as Lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true
    lastchangedat as Lastchangedat,
    _OrderItem
    
}
