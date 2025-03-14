CLASS lhc_Material DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Material RESULT result.

    METHODS init_field FOR DETERMINE ON SAVE
      IMPORTING keys FOR Material~init_field.

ENDCLASS.

CLASS lhc_Material IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

    METHOD init_field.
      DATA lv_price TYPE f.
      DATA lv_quantity TYPE f.
      DATA lv_ppq TYPE f.
      DATA lv_current_ppq TYPE f.

      " 재료 데이터를 로컬 모드에서 읽어옵니다.
      READ ENTITIES OF YR_MATERIAL_JH IN LOCAL MODE
        ENTITY Material
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_material_data).

      LOOP AT lt_material_data INTO DATA(ls_material_data1).
        lv_current_ppq = ls_material_data1-ppq.
        EXIT. " 한 번만 필요함
      ENDLOOP.

      LOOP AT lt_material_data INTO DATA(ls_material_data).
        " Price와 MaterialQuantity 값을 실수 타입으로 변환
        lv_price = CONV f( ls_material_data-price ).
        lv_quantity = CONV f( ls_material_data-MaterialQuantity ).

        " Ppq(price per quantity) 계산 (Price를 MaterialQuantity로 나눈 값)
        lv_ppq = lv_price / lv_quantity * 100.
        EXIT.
      ENDLOOP.

          " 재료 데이터 업데이트
      IF lv_current_ppq <> lv_ppq.
        MODIFY ENTITIES OF YR_MATERIAL_JH IN LOCAL MODE
          ENTITY Material
          UPDATE
            FIELDS ( Unit Ppq )
            WITH VALUE #( FOR ls_material_data2 IN lt_material_data (
                            %tky = ls_material_data2-%tky
                            Ppq = lv_ppq
                            Unit = 'KRW'
                          ) )
            MAPPED DATA(mapped_data).
      ENDIF.

    ENDMETHOD.





ENDCLASS.
