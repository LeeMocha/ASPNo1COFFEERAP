@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '재료 pv'
@Metadata.allowExtensions: true
define root view entity YC_MATERIAL_JH provider contract transactional_query 
as projection on YR_MATERIAL_JH
{
    key Uuid as Uuid,
    MaterialName,
    Price,
    Unit,
    MaterialQuantity,
    Qunit,
    Ppq

}
