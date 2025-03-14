@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '카테고리 pv'
@Metadata.allowExtensions: true
define root view entity YC_CATEGORY_JH provider contract transactional_query
as projection on YR_CATEGORY_JH
{
    key Uuid as Uuid,
    Category as Category,
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_CATEGORY_JH'
    virtual categoryCnt : abap.int4
}
