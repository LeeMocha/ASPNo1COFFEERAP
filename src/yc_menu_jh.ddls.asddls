@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '메뉴 pv'
@Metadata.allowExtensions: true
define root view entity YC_MENU_JH provider contract transactional_query 
as projection on YR_MENU_JH
{
    key Uuid,
    CategoryUuid,
    Category,
    MenuName,
    MenuPrice,
    Unit,
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_MENUSTATE_JH'
    virtual MenuState : abap.char(1),
    _Bom : redirected to composition child YC_BOM_JH
}
