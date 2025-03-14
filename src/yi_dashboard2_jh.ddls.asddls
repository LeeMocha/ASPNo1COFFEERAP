@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '데시보드 인터페이스뷰'
define view entity YI_DASHBOARD2_JH as select from YR_ORDER_JH as Order1
{
    key substring(Order1.OrderCode, 1, 8) as OrderDate

} group by Order1.OrderCode
