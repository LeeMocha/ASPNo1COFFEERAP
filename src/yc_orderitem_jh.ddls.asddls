@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '주문상세품목 pv'
@Metadata.allowExtensions: true
define view entity YC_ORDERITEM_JH
as projection on YR_ORDERITEM_JH
{
    key Uuid,
    key OrderUuid,
    MenuUuid,
    MenuName,
    MenuPrice,
    MenuUnit,
    MenuCnt,
    forBom,
    _Bom,
    _Menu,
    _Order : redirected to parent YC_ORDER_JH
    
}
