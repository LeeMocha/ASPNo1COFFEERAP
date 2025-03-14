@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM'
define view entity YR_BOM_JH as select from ytb_bom_jh as BOM
left outer join YR_MATERIAL_JH as Material on BOM.material_uuid = Material.Uuid
association to parent YR_MENU_JH as _Menu on $projection.MenuUuid = _Menu.Uuid
{
    key BOM.uuid as Uuid,
    @Consumption.valueHelpDefinition: [{ 
      entity: { name: 'YR_MENU_JH', element: 'Uuid'}
    }]
    key BOM.menu_uuid as MenuUuid,
    @Consumption.valueHelpDefinition: [{ 
      entity: { name: 'YR_MATERIAL_JH', element: 'Uuid'}
    }]
    BOM.material_uuid as MaterialUuid,
    Material.MaterialName as MaterialName,
    BOM.bom_quantity as BomQuantity,
    BOM.qunit as Qunit,
    Material.Ppq as Ppq,
    @Semantics.user.createdBy: true
    BOM.createby      as Createby,
    @Semantics.systemDateTime.createdAt: true
    BOM.createdat     as Createdat,
    @Semantics.user.lastChangedBy: true
    BOM.lastchangedby as Lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true
    BOM.lastchangedat as Lastchangedat,
    _Menu

}
