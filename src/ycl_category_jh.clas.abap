CLASS ycl_category_jh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
      INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YCL_CATEGORY_JH IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
      DATA:
      lt_category TYPE TABLE OF YC_CATEGORY_JH WITH DEFAULT KEY,
      lt_menu TYPE TABLE OF yc_menu_jh,
      menuCnt TYPE i VALUE 0,
      categoryCnt TYPE i VALUE 0.


      lt_category = CORRESPONDING #( it_original_data ).

      LOOP AT lt_category ASSIGNING FIELD-SYMBOL(<ls_category>).
      CLEAR categoryCnt.

      SELECT *
      FROM yc_menu_jh
      WHERE CategoryUuid = @<ls_category>-Uuid
      INTO TABLE @lt_menu.

          LOOP AT lt_menu INTO DATA(ls_menu).
            CLEAR menuCnt.

              SELECT COUNT( * )
              FROM yc_orderitem_jh
              WHERE MenuUuid = @ls_menu-Uuid
              INTO @menuCnt.

            categoryCnt += menuCnt.

          ENDLOOP.

        <ls_category>-categoryCnt = categoryCnt.

      ENDLOOP.

        " 원본 데이터와 동일한 구조의 결과 데이터를 생성
      ct_calculated_data = CORRESPONDING #( lt_category ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
