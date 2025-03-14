@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '주문 pv'
@Metadata.allowExtensions: true
define root view entity YC_ORDER_JH  provider contract transactional_query 
as projection on YR_ORDER_JH
{
    key Uuid,
    OrderCode,
    OrderDate,
    @Semantics.amount.currencyCode: 'Tunit'
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_CALCULATE_JH'
    virtual TotalAmount : abap.curr(10,2),
    @Semantics.amount.currencyCode: 'Tunit'
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_CALCULATE_JH'
    virtual BomAmount : abap.curr(10,2),
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_CALCULATE_JH'
    virtual Tunit : abap.cuky,
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_CALCULATE_JH'
    virtual TotalMenu : abap.int4,
    _OrderItem : redirected to composition child YC_ORDERITEM_JH
}
