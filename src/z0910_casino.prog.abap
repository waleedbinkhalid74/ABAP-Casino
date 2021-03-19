*&---------------------------------------------------------------------*
*& Report z0910_casino
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z0910_casino.

DATA gv_player TYPE REF TO z0910_casino_player.
gv_player = NEW z0910_casino_player( iv_startingmoney = 100 ).

DATA(gv_cointoss) = NEW z0910_cointoss( ).
DATA(gv_lotto) = NEW z0910_lotto(  ).
DATA gv_input TYPE string.
DATA gv_current_betting_amount TYPE i.

CONSTANTS gv_max_games TYPE i VALUE 10.
DO.
  cl_s4d_output=>display_string( iv_text = 'What gave would you like to play. Options: [COINTOSS, LOTTO]' ).

  cl_s4d_input=>get_text(
    IMPORTING
      ev_text = gv_input
  ).


  CASE gv_input.
    WHEN 'EXIT'.
      EXIT.

    WHEN 'LOTTO'.
      IF gv_lotto->get_mv_roundsplayed( ) > 9.
        cl_s4d_output=>display_string( iv_text = 'You Have Exceeded The Max Number of Rounds For Coin Toss ' ).
      ELSE.
        cl_s4d_output=>display_string( iv_text = | How much do you want to bet. You currently have { gv_player->get_mv_currentmoney( ) }| ).
        cl_s4d_input=>get_number(
          IMPORTING
            ev_number = gv_current_betting_amount
        ).
        IF gv_current_betting_amount > gv_player->get_mv_currentmoney( ).
          gv_current_betting_amount = gv_player->get_mv_currentmoney( ).
        ENDIF.
        gv_lotto->play(
  EXPORTING
    player        = gv_player
    amount_to_bet = gv_current_betting_amount
).
      ENDIF.

    WHEN 'COINTOSS'.
      IF gv_cointoss->get_mv_roundsplayed( ) > 9.
        cl_s4d_output=>display_string( iv_text = 'You Have Exceeded The Max Number of Rounds For Coin Toss ' ).
      ELSE.
        cl_s4d_output=>display_string( iv_text = | How much do you want to bet. You currently have { gv_player->get_mv_currentmoney( ) }| ).
        cl_s4d_input=>get_number(
          IMPORTING
            ev_number = gv_current_betting_amount
        ).
        IF gv_current_betting_amount > gv_player->get_mv_currentmoney( ).
          gv_current_betting_amount = gv_player->get_mv_currentmoney( ).
        ENDIF.
        gv_cointoss->play(
  EXPORTING
    player        = gv_player
    amount_to_bet = gv_current_betting_amount
).
      ENDIF.

      "Add coin toss execution here
    WHEN OTHERS.
      cl_s4d_output=>display_string( iv_text = 'Incorrect Entry. Please try again...' ).
  ENDCASE.

  IF gv_player->isbankrupt( ) = abap_true.
    cl_s4d_output=>display_string( iv_text = 'You went bankrupt :( try not to gamble your life savings!' ).
    EXIT.
  ENDIF.
  IF gv_player->isrich( ) = abap_true.
    cl_s4d_output=>display_string( iv_text = 'You ''re RICH! :D You can gamble away your life savings!' ).
    EXIT.
  ENDIF.

ENDDO.
