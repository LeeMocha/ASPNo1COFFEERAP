CLASS ycl_invenstate_jh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YCL_INVENSTATE_JH IMPLEMENTATION.


METHOD if_sadl_exit_calc_element_read~calculate.
  DATA: lt_inventory_data TYPE TABLE OF YC_INVENTORY_JH WITH DEFAULT KEY,
        lt_order_items TYPE TABLE OF yc_orderitem_jh,
        lt_bom TYPE TABLE OF yc_bom_jh,
        lt_materials TYPE TABLE OF yc_material_jh, " 재료 테이블 추가
        lv_state TYPE string,
        lv_total_used TYPE p DECIMALS 2,
        lv_used_quantity TYPE p DECIMALS 2,
        lv_baseQuan TYPE i.

  " 원본 데이터를 lt_inventory_data에 복사
  lt_inventory_data = CORRESPONDING #( it_original_data ).

  " 주문 항목 데이터를 읽어옴
  SELECT *
    FROM yc_orderitem_jh
    INTO TABLE @lt_order_items.

  " BOM 데이터를 읽어옴
  SELECT *
    FROM yc_bom_jh
    FOR ALL ENTRIES IN @lt_order_items
    WHERE menuUuid = @lt_order_items-menuUuid
    INTO TABLE @lt_bom.

  " 재료 데이터를 읽어옴
  SELECT *
    FROM yc_material_jh
    INTO TABLE @lt_materials.

  " 전체 사용량 초기화
  lv_total_used = 0.

  " 첫 번째 루프: 각 재료의 사용량을 계산
  LOOP AT lt_inventory_data ASSIGNING FIELD-SYMBOL(<ls_inventory_data>).

    lv_used_quantity = 0. " 각 재고 데이터에 대해 사용량 초기화

    " 해당 재고 데이터에 대해 BOM에서 사용량 계산
    LOOP AT lt_bom INTO DATA(ls_bom)
         WHERE materialUuid = <ls_inventory_data>-materialUuid.

      LOOP AT lt_order_items INTO DATA(ls_order_item)
           WHERE menuUuid = ls_bom-menuUuid.
        lv_used_quantity += ls_bom-bomQuantity * ls_order_item-menuCnt.
      ENDLOOP.

    ENDLOOP.

    " 각 재료의 사용량을 재고 데이터에 저장
    <ls_inventory_data>-usedQuantity = lv_used_quantity.

    " 전체 사용량에 추가
    lv_total_used += lv_used_quantity.

  ENDLOOP.

  " 두 번째 루프: 각 재료의 상태 및 사용 비율을 계산
  LOOP AT lt_inventory_data ASSIGNING FIELD-SYMBOL(<ls_inventory_data2>).

    " 상태 결정
    IF <ls_inventory_data2>-inventoryQuantity < <ls_inventory_data2>-MaterialQuantity * 3.
      lv_state = 'Error'.
    ELSEIF <ls_inventory_data2>-inventoryQuantity < <ls_inventory_data2>-MaterialQuantity * 6.
      lv_state = 'Warning'.
    ELSE.
      lv_state = 'Success'.
    ENDIF.

    " baseQuantity 계산
    lv_baseQuan = CEIL( <ls_inventory_data2>-inventoryQuantity / <ls_inventory_data2>-MaterialQuantity ).

    <ls_inventory_data2>-inventoryState = lv_state.
    <ls_inventory_data2>-baseQuantity = lv_baseQuan.
    <ls_inventory_data2>-baseQunit = 'EA'.

    " 사용 비율 계산
    IF lv_total_used > 0.
      <ls_inventory_data2>-usingRate = ( <ls_inventory_data2>-usedQuantity / lv_total_used ) * 100.
    ELSE.
      <ls_inventory_data2>-usingRate = 0.
    ENDIF.

  ENDLOOP.

  " 원본 데이터와 동일한 구조의 결과 데이터를 생성
  ct_calculated_data = CORRESPONDING #( lt_inventory_data ).

ENDMETHOD.


METHOD if_sadl_exit_calc_element_read~get_calculation_info.
ENDMETHOD.
ENDCLASS.
