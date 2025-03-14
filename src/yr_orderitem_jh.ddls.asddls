@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '주문상세품목'
define view entity YR_ORDERITEM_JH as select from ytb_orderitem_jh as OrderItem
//left outer join YR_MENU_JH as Menu on OrderItem.menu_uuid = Menu.Uuid
association to parent YR_ORDER_JH as _Order on $projection.OrderUuid = _Order.Uuid
association [1..1] to YR_MENU_JH as _Menu on $projection.MenuUuid = _Menu.Uuid
{
    key OrderItem.uuid as Uuid,
    key OrderItem.order_uuid as OrderUuid,
    @Consumption.valueHelpDefinition: [{ 
      entity: { name: 'YR_MENU_JH', element: 'Uuid'}
    }]
    OrderItem.menu_uuid as MenuUuid,
    _Menu.MenuName as MenuName,
    @Semantics.amount.currencyCode : 'MenuUnit'
    _Menu.MenuPrice as MenuPrice,
    _Menu.Unit as MenuUnit,
    OrderItem.menu_cnt as MenuCnt,
    _Order.OrderCode as OrderCode,
    @Semantics.user.createdBy: true
    OrderItem.createby      as Createby,
    @Semantics.systemDateTime.createdAt: true
    OrderItem.createdat     as Createdat,
    @Semantics.user.lastChangedBy: true
    OrderItem.lastchangedby as Lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true
    OrderItem.lastchangedat as Lastchangedat,
    _Menu.Uuid as forBom,
    _Menu._Bom as _Bom,
    _Menu,
    _Order
}
