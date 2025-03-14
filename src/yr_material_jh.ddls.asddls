@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '재료'
define root view entity YR_MATERIAL_JH as select from ytb_material_jh
{
    key uuid as Uuid,
    material_name as MaterialName,
    price as Price,
    unit as Unit,
    material_quantity as MaterialQuantity,
    qunit as Qunit,
    price_per_quan as Ppq,
    @Semantics.user.createdBy: true
    createby      as Createby,
    @Semantics.systemDateTime.createdAt: true
    createdat     as Createdat,
    @Semantics.user.lastChangedBy: true
    lastchangedby as Lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true
    lastchangedat as Lastchangedat
}
