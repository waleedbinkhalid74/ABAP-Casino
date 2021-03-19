CLASS z0910_casino_game DEFINITION PUBLIC ABSTRACT.
  PUBLIC SECTION.
    METHODS play ABSTRACT
      IMPORTING player        TYPE REF TO z0910_casino_player
                amount_to_bet TYPE i.
    METHODS: get_mv_roundsplayed RETURNING VALUE(r_result) TYPE i,
             set_mv_roundsplayed IMPORTING mv_roundsplayed TYPE i.
  PROTECTED SECTION.
    CONSTANTS c_maxrounds TYPE i VALUE 10.
    DATA mv_roundsplayed TYPE i.
  PRIVATE SECTION.
ENDCLASS.



CLASS z0910_casino_game IMPLEMENTATION.
  METHOD get_mv_roundsplayed.
    r_result = me->mv_roundsplayed.
  ENDMETHOD.
  METHOD set_mv_roundsplayed.
    me->mv_roundsplayed = mv_roundsplayed.
  ENDMETHOD.

ENDCLASS.
