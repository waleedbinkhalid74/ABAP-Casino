CLASS z0910_cointoss DEFINITION INHERITING FROM z0910_casino_game PUBLIC FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: play REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z0910_cointoss IMPLEMENTATION.
  METHOD play.
    DATA lv_random_gen TYPE REF TO cl_abap_random_int.
    DATA lv_current_result TYPE i.
    DATA lv_player_choice TYPE string.
    DATA lv_amount_won TYPE i.
    me->set_mv_roundsplayed( mv_roundsplayed = me->get_mv_roundsplayed( ) + 1 ).
    player->set_mv_currentmoney( iv_mv_currentmoney = player->get_mv_currentmoney( ) - amount_to_bet ).
    cl_abap_random_int=>create(
      EXPORTING
        seed = cl_abap_random=>seed( )                 " Initial Value of PRNG
        min  = 1      " Lower Limit for Value Area
        max  = 2       " Upper Limit for Value Area
      RECEIVING
        prng = lv_random_gen                  " Random Number Generator Object
    ).
*    CATCH cx_abap_random. " Exception for CL_ABAP_RANDOM*
    lv_current_result = lv_random_gen->get_next( ).

    DO.
      cl_s4d_output=>display_string( 'Please enter either HEADS or TAILS' ).

      cl_s4d_input=>get_text(
        IMPORTING
          ev_text = lv_player_choice
      ).

      CASE lv_player_choice.
        WHEN 'HEADS'.
          IF lv_current_result = 1.
            " Winning Case
            lv_amount_won = 2 * amount_to_bet.
            player->set_mv_currentmoney( iv_mv_currentmoney = player->get_mv_currentmoney( ) + lv_amount_won ).
            cl_s4d_output=>display_string( iv_text = | You won { amount_to_bet } | ).

          ELSE.
            "Losing case
            cl_s4d_output=>display_string( iv_text = | You lost { amount_to_bet } | ).
          ENDIF.
          EXIT.

        WHEN 'TAILS'.
          IF lv_current_result = 2.
            " Winning Case
            lv_amount_won = 2 * amount_to_bet.
            player->set_mv_currentmoney( iv_mv_currentmoney = player->get_mv_currentmoney( ) + lv_amount_won ).
            cl_s4d_output=>display_string( iv_text = | You won { amount_to_bet } | ).

          ELSE.
            "Losing case
            cl_s4d_output=>display_string( iv_text = | You lost { amount_to_bet } | ).

          ENDIF.

          EXIT.
        WHEN OTHERS.
          cl_s4d_output=>display_string( iv_text = 'Incorrect Entry' ).
      ENDCASE.



    ENDDO.
    player->display_status( ).


  ENDMETHOD.

ENDCLASS.
