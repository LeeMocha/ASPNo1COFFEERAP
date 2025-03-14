@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '재고 pv'
@Metadata.allowExtensions: true
define root view entity YC_INVENTORY_JH provider contract transactional_query 
as projection on YR_INVENTORY_JH
{
    key Uuid,
    MaterialUuid,
    MaterialName,
    MaterialQuantity,
    InventoryQuantity,
    Qunit,
    Unit,
    Ppq,
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_INVENSTATE_JH'
    virtual inventoryState : abap.char(10),
    @Semantics.quantity.unitOfMeasure: 'Qunit'
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_INVENSTATE_JH'
    virtual usedQuantity : abap.quan(12),
    @Semantics.quantity.unitOfMeasure: 'baseQunit'
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_INVENSTATE_JH'
    virtual baseQuantity : abap.quan(12),
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_INVENSTATE_JH'
    virtual baseQunit : abap.unit(3),
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_INVENSTATE_JH'
    virtual usingRate : abap.dec(4 , 2)
    

}
