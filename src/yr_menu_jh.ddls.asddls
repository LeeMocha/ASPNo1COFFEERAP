@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '메뉴'
define root view entity YR_MENU_JH as select from ytb_menu_jh as Menu
left outer join ytb_category_jh as Category on Menu.category_uuid = Category.uuid
composition [1..*] of YR_BOM_JH as _Bom
{

    key Menu.uuid as Uuid,
    @Consumption.valueHelpDefinition: [{ 
      entity: { name: 'YR_CATEGORY_JH', element: 'Uuid'}
    }]
    Menu.category_uuid as CategoryUuid,
    Category.category as Category,
    Menu.menu_name as MenuName,
    Menu.menu_price as MenuPrice,
    Menu.unit as Unit,
    @Semantics.user.createdBy: true
    Menu.createby      as Createby,
    @Semantics.systemDateTime.createdAt: true
    Menu.createdat     as Createdat,
    @Semantics.user.lastChangedBy: true
    Menu.lastchangedby as Lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true
    Menu.lastchangedat as Lastchangedat,
    _Bom

    
}
