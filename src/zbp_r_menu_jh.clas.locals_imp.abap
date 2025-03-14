CLASS lhc_Menu DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Menu RESULT result.

    METHODS init_field FOR DETERMINE ON SAVE
      IMPORTING keys FOR Menu~init_field.

ENDCLASS.

CLASS lhc_Menu IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD init_field.
    READ ENTITIES OF YR_MENU_JH IN LOCAL MODE
    ENTITY Menu
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_menu_data).

    MODIFY ENTITIES OF YR_MENU_JH IN LOCAL MODE
      ENTITY Menu
        UPDATE
          FIELDS ( Unit )
          WITH VALUE #( FOR ls_menu_data IN lt_menu_data (
                          %tky = ls_menu_data-%tky
                          Unit = 'KRW'
                        ) )
          MAPPED DATA(mapped_data).

    reported = CORRESPONDING #( DEEP mapped_data ).

  ENDMETHOD.

ENDCLASS.
