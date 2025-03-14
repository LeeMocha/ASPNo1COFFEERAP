@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '카테고리'
define root view entity YR_CATEGORY_JH as select from ytb_category_jh
{
    key uuid as Uuid,
    category as Category,
    @Semantics.user.createdBy: true
    createby      as Createby,
    @Semantics.systemDateTime.createdAt: true
    createdat     as Createdat,
    @Semantics.user.lastChangedBy: true
    lastchangedby as Lastchangedby,
    @Semantics.systemDateTime.lastChangedAt: true
    lastchangedat as Lastchangedat
}
