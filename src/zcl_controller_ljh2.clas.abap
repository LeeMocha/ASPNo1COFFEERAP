CLASS zcl_controller_ljh2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
        INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_CONTROLLER_LJH2 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
        "DELETE FROM tablename WHERE 조건거시오 abap 형태로.
        DELETE FROM zcim_dr_5000_jh.
*        DELETE FROM ytb_category_jh.
*        UPDATE ytb_inventory_jh SET Uuid = 'B5BDA6B1CB481EDF9081A3DF07FAE10F'.
  ENDMETHOD.
ENDCLASS.
