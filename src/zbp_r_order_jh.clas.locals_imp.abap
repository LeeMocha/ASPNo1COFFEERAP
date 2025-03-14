CLASS lhc_Order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Order RESULT result.

    METHODS init_field FOR DETERMINE ON SAVE
      IMPORTING keys FOR Order~init_field.

ENDCLASS.

CLASS lhc_Order IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

METHOD init_field.
  READ ENTITIES OF YR_ORDER_JH IN LOCAL MODE
    ENTITY Order
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_orderE_data).

     DATA: lt_order_data TYPE TABLE OF yr_order_jh-OrderCode,
        lv_date_str   TYPE string,
        lv_seq_num    TYPE i,
        lv_max_seq    TYPE i VALUE 0,
        lv_seq_str    TYPE string,
        lv_order_code TYPE string,
        ls_order      TYPE yr_order_jh-OrderCode.

  " 현재 날짜를 YYYYMMDD 형식의 문자열로 변환
  lv_date_str = |{ sy-datum }|.

  " 오늘 날짜에 해당하는 OrderCode 중 모든 시퀀스 번호 찾기
  SELECT OrderCode
    FROM yr_order_jh
    WHERE SUBSTRING( OrderCode, 1, 8 ) = @lv_date_str
    INTO TABLE @lt_order_data.

  " 데이터가 없는 경우 처리
  IF lt_order_data IS INITIAL.
    lv_seq_num = 1.
  ELSE.
    " 최대 시퀀스 번호 찾기
    LOOP AT lt_order_data INTO ls_order.
      lv_seq_str = ls_order+8(6). " OrderCode에서 시퀀스 부분 추출
      lv_seq_num = lv_seq_str.
      IF lv_seq_num > lv_max_seq.
        lv_max_seq = lv_seq_num.
      ENDIF.
    ENDLOOP.

    " 시퀀스 번호 초기화 (기존 값이 있다면 +1)
    lv_seq_num = lv_max_seq + 1.
  ENDIF.

  " 시퀀스 번호를 6자리 문자열로 변환
  DATA lv_len TYPE i.
  lv_len = 7 - strlen( |{  lv_seq_num }| ).
  lv_seq_str = lv_seq_num.
  CONCATENATE '000000' lv_seq_str INTO lv_seq_str.
  lv_seq_str = lv_seq_str+1(lv_len).

  " 날짜 문자열과 시퀀스 문자열을 결합하여 OrderCode 생성
  lv_order_code = lv_date_str && lv_seq_str.

  " 변경된 값을 데이터베이스에 반영
  MODIFY ENTITIES OF yr_order_jh IN LOCAL MODE
    ENTITY Order
    UPDATE
      FIELDS ( OrderCode )
      WITH VALUE #( FOR ls_orderE_data IN lt_orderE_data (
                      %tky = ls_orderE_data-%tky
                      OrderCode = lv_order_code
                    ) )
    MAPPED DATA(mapped_data).

  reported = CORRESPONDING #( DEEP mapped_data ).

ENDMETHOD.

ENDCLASS.

CLASS lhc_Orderitem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS reduce_inventory FOR DETERMINE ON SAVE
      IMPORTING keys FOR Orderitem~reduce_inventory.
*    METHODS rba_Bom FOR READ
*      IMPORTING keys_rba FOR READ Orderitem\_Bom FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_Orderitem IMPLEMENTATION.

  METHOD reduce_inventory.
    DATA lt_Inventory_data TYPE TABLE OF yr_inventory_jh.

    READ ENTITIES OF YR_ORDER_JH IN LOCAL MODE
    ENTITY OrderItem
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_OrderItem_data).

    DATA lt_Bom_data TYPE TABLE OF yr_bom_jh.

    LOOP AT lt_OrderItem_data INTO DATA(ls_OrderItem_data).

    IF ls_OrderItem_data-MenuCnt <> 0.
        SELECT *
        FROM yr_bom_jh
        WHERE MenuUuid = @ls_OrderItem_data-MenuUuid
        INTO TABLE @lt_Bom_data.

        LOOP AT lt_Bom_data INTO DATA(ls_Bom_data).
        SELECT *
        FROM yr_inventory_jh
        WHERE MaterialUuid = @ls_Bom_data-MaterialUuid
        INTO TABLE @lt_Inventory_data.

            LOOP AT lt_Inventory_data INTO DATA(ls_Inventory_data).
            " 재고 수량에서 Bom 수량을 뺍니다.
            ls_Inventory_data-InventoryQuantity = ls_Inventory_data-InventoryQuantity - ( ls_Bom_data-BomQuantity * ls_OrderItem_data-MenuCnt ).

            " 재고 수량을 업데이트합니다.
            MODIFY ENTITIES OF yr_inventory_jh
              ENTITY Inventory
              UPDATE
                FIELDS ( InventoryQuantity )
                WITH VALUE #( ( Uuid = ls_Inventory_data-Uuid
                                InventoryQuantity = ls_Inventory_data-InventoryQuantity ) )
              MAPPED DATA(mapped_data).

            reported = CORRESPONDING #( mapped_data ).
        ENDLOOP.
      ENDLOOP.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

*METHOD rba_Bom.
*  DATA: lt_bom_data       TYPE TABLE OF ytb_bom_jh,
*        lt_bom_result     TYPE TABLE OF ytb_bom_jh.
*
*  " Orderitem 엔터티 데이터를 읽어옵니다.
*  READ ENTITIES OF YR_ORDER_JH IN LOCAL MODE
*    ENTITY Orderitem
*    ALL FIELDS WITH CORRESPONDING #( keys_rba )
*    RESULT DATA(lt_orderitem_data).
*
*  " 각 Orderitem에 대한 BOM 데이터 읽기
*  LOOP AT lt_orderitem_data INTO DATA(ls_orderitem_data).
*    DATA(lv_menu_uuid) = ls_orderitem_data-MenuUuid.
*
*    " BOM 데이터 읽기
*    READ ENTITIES OF YR_MENU_JH
*      ENTITY Bom
*      ALL FIELDS WITH CORRESPONDING #( lv_menu_uuid )
*      RESULT DATA(lt_bom_data).
*
*    " BOM 데이터를 결과 테이블에 추가
*    APPEND LINES OF lt_bom_data TO lt_bom_result.
*  ENDLOOP.
*
*  " BOM 데이터 반환
*  result = lt_bom_result.
*ENDMETHOD.


ENDCLASS.
