CLASS ycl_calculate_jh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YCL_CALCULATE_JH IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA:
      lt_order TYPE TABLE OF YC_ORDER_JH WITH DEFAULT KEY,
      lt_orderitem TYPE STANDARD TABLE OF YR_ORDERITEM_JH WITH DEFAULT KEY,  " orderitem 테이블의 타입으로 변경
      lv_total TYPE p DECIMALS 2,
      lv_BomAmount TYPE f VALUE 0,
      lv_BomTotal TYPE f,
      lv_cnt       TYPE i,
      lv_menuCnt  TYPE i VALUE 0.

      lt_order = CORRESPONDING #( it_original_data ).

    LOOP AT lt_order ASSIGNING FIELD-SYMBOL(<ls_order>).
      CLEAR lv_total.
      CLEAR lv_BomAmount.
      CLEAR  lv_menuCnt.

      " order_uuid로 orderitem 테이블에서 가격을 합산
      SELECT SUM( MenuPrice * MenuCnt )
        FROM YR_ORDERITEM_JH
        WHERE OrderUuid = @<ls_order>-uuid
        INTO @lv_total.

      " 해당 OrderUuid에 대한 orderitem 항목들을 가져오기
      SELECT *
        FROM YR_ORDERITEM_JH
        WHERE OrderUuid = @<ls_order>-uuid
        INTO TABLE @lt_orderitem.

      LOOP AT lt_orderitem INTO DATA(ls_orderitem).
        CLEAR lv_BomTotal.

        SELECT SUM( BomQuantity * Ppq )
            FROM YR_BOM_JH
            WHERE MenuUuid = @ls_orderitem-MenuUuid
            INTO @lv_BomTotal.

            lv_BomAmount = lv_BomAmount +  ( lv_BomTotal * ls_orderitem-MenuCnt ) .
            lv_menuCnt = lv_menuCnt + ls_orderitem-MenuCnt.
      ENDLOOP.

      <ls_order>-TotalAmount = lv_total.
      <ls_order>-Tunit = 'KRW'.
      <ls_order>-BomAmount = ROUND( val = lv_BomAmount / 100 dec = 2 ).
      <ls_order>-TotalMenu = lv_menuCnt.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_order ).
  ENDMETHOD.


    METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    ENDMETHOD.
ENDCLASS.
