CLASS lhc_Payment DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Payment RESULT result.

    METHODS init_field FOR DETERMINE ON SAVE
      IMPORTING keys FOR Payment~init_field.

ENDCLASS.

CLASS lhc_Payment IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD init_field.
      READ ENTITIES OF YR_PAYMENT_JH IN LOCAL MODE
    ENTITY Payment
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_payment_data).

    MODIFY ENTITIES OF YR_PAYMENT_JH IN LOCAL MODE
      ENTITY Payment
        UPDATE
          FIELDS ( Unit )
          WITH VALUE #( FOR ls_payment_data IN lt_payment_data (
                          %tky = ls_payment_data-%tky
                          Unit = 'KRW'
                        ) )
          MAPPED DATA(mapped_data).

    reported = CORRESPONDING #( DEEP mapped_data ).

  ENDMETHOD.

ENDCLASS.
