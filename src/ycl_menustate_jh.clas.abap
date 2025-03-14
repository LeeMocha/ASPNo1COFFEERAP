CLASS ycl_menustate_jh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
      INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YCL_MENUSTATE_JH IMPLEMENTATION.


    METHOD if_sadl_exit_calc_element_read~calculate.
        DATA: lt_bom TYPE TABLE OF yc_bom_jh,
              lt_menu TYPE TABLE OF yc_menu_jh,
              lt_inventory TYPE TABLE OF yc_inventory_jh,
              lv_menu_state TYPE string.

        " 메뉴 데이터를 읽어옴
        SELECT *
          FROM yc_menu_jh
          INTO TABLE @lt_menu.

        LOOP AT lt_menu ASSIGNING FIELD-SYMBOL(<ls_menu>).
          " 메뉴 상태 초기화
          lv_menu_state = 'O'. " 기본값을 'O'로 설정

          " 해당 메뉴에 대한 BOM 데이터를 읽어옴
          SELECT *
            FROM yc_bom_jh
            WHERE menuUuid = @<ls_menu>-Uuid " 주문된 메뉴에 해당하는 BOM만 필터링
            INTO TABLE @lt_bom.

          LOOP AT lt_bom ASSIGNING FIELD-SYMBOL(<ls_bom>).
            " BOM 항목에 해당하는 재고 데이터를 읽어옴
            SELECT *
              FROM yc_inventory_jh
              WHERE materialUuid = @<ls_bom>-materialUuid
              INTO TABLE @lt_inventory.

            " 재료가 아예 없는 경우나 재고 수량이 부족한 경우
            IF lt_inventory IS INITIAL.
              lv_menu_state = 'X'.
              EXIT.
            ENDIF.

            LOOP AT lt_inventory ASSIGNING FIELD-SYMBOL(<ls_inventory>).
              IF <ls_inventory>-inventoryQuantity < <ls_bom>-bomQuantity.
                lv_menu_state = 'X'.
                EXIT.
              ENDIF.
            ENDLOOP.

            IF lv_menu_state = 'X'.
              EXIT.
            ENDIF.
          ENDLOOP.

          <ls_menu>-menuState = lv_menu_state.
        ENDLOOP.

        ct_calculated_data = CORRESPONDING #( lt_menu ).
      ENDMETHOD.


    METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    ENDMETHOD.
ENDCLASS.
