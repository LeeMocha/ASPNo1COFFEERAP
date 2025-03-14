@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '재고'
define root view entity YR_INVENTORY_JH as select from ytb_inventory_jh as Inventory
left outer join ytb_material_jh as Material on Inventory.material_uuid = Material.uuid
{

   key Inventory.uuid as Uuid,
    @Consumption.valueHelpDefinition: [{ 
      entity: { name: 'YR_MATERIAL_JH', element: 'Uuid'}
    }]
    Inventory.material_uuid as MaterialUuid,
    Material.material_name as MaterialName,
    Material.material_quantity as MaterialQuantity,
    @Semantics.quantity.unitOfMeasure : 'Qunit'
    Inventory.inventory_quantity as InventoryQuantity,
    Inventory.qunit as Qunit,
    Material.price_per_quan as Ppq,
    Material.unit as Unit,
    @Semantics.user.createdBy: true
    Inventory.createby      as Createby,
    @Semantics.systemDateTime.createdAt: true
    Inventory.createdat     as Createdat,
    @Semantics.user.lastChangedBy: true
    Inventory.lastchangedby as Lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true
    Inventory.lastchangedat as Lastchangedat
    
}
