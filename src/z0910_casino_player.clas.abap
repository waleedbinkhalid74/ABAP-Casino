CLASS z0910_casino_player DEFINITION PUBLIC FINAL CREATE PUBLIC .
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING iv_startingmoney TYPE i.
    METHODS isbankrupt
      RETURNING VALUE(rv_bankrupt) TYPE abap_bool.
    METHODS isrich
      RETURNING VALUE(rv_rich) TYPE abap_bool.
    METHODS: get_mv_currentmoney RETURNING value(r_result) TYPE i,
             set_mv_currentmoney IMPORTING iv_mv_currentmoney TYPE i,
             display_status.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA mv_startingmoney TYPE i.
    DATA mv_currentmoney TYPE i.
ENDCLASS.

CLASS z0910_casino_player IMPLEMENTATION.
  METHOD constructor.
    me->mv_currentmoney = iv_startingmoney.
    me->mv_startingmoney = iv_startingmoney.
  ENDMETHOD.

  METHOD isbankrupt.
    IF me->mv_currentmoney <= 0 .
      rv_bankrupt = abap_true.
    ELSE.
      rv_bankrupt = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD isrich.
    IF me->mv_currentmoney >= ( me->mv_startingmoney * 100 ).
      rv_rich = abap_true.
    ELSE.
      rv_rich = abap_false.
    ENDIF.
  ENDMETHOD.
  METHOD get_mv_currentmoney.
    r_result = me->mv_currentmoney.
  ENDMETHOD.

  METHOD set_mv_currentmoney.
    me->mv_currentmoney = iv_mv_currentmoney.
  ENDMETHOD.

  METHOD display_status.
    cl_s4d_output=>display_string( iv_text = | You currently have { me->get_mv_currentmoney( ) }| ).
  ENDMETHOD.

ENDCLASS.
