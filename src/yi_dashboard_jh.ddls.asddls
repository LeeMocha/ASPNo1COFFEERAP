@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '데시보드 인터페이스뷰'
define view entity YI_DASHBOARD_JH as select from YR_ORDERITEM_JH as OrderItem
{
    key MenuName,
    sum(MenuCnt) as Sales
    
} group by MenuName
