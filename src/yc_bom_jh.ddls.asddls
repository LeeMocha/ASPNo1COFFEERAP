@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM pv'
@Metadata.allowExtensions: true
define view entity YC_BOM_JH 
as projection on YR_BOM_JH
{
    key Uuid,
    key MenuUuid,
    MaterialUuid,
    MaterialName,
    BomQuantity,
    Qunit,
    Ppq,
    _Menu : redirected to parent YC_MENU_JH

}
