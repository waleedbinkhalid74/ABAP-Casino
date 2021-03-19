CLASS z0910_lotto DEFINITION INHERITING FROM z0910_casino_game PUBLIC FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: play REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z0910_lotto IMPLEMENTATION.
  METHOD play.
    DATA lv_lotto_generator TYPE REF TO cl_abap_random_int.
    cl_abap_random_int=>create(
      EXPORTING
        seed = cl_abap_random=>seed( )
        min  = 1
        max  = 49
      RECEIVING
        prng = lv_lotto_generator
    ).



    DATA lt_player_numbers TYPE STANDARD TABLE OF i WITH NON-UNIQUE KEY table_line.
    DATA lt_drawn_numbers TYPE STANDARD TABLE OF i WITH NON-UNIQUE KEY table_line.
    DATA lv_amount_won TYPE i.
    DATA lv_number_of_hits TYPE i.
    DATA lv_lotto_number_helper TYPE i.

    me->set_mv_roundsplayed( mv_roundsplayed = me->get_mv_roundsplayed( ) + 1 ).
    player->set_mv_currentmoney( iv_mv_currentmoney = player->get_mv_currentmoney( ) - amount_to_bet ).

    DO.
      lv_lotto_number_helper = lv_lotto_generator->get_next( ).
      IF NOT line_exists( lt_drawn_numbers[ table_line = lv_lotto_number_helper ] ).
        lt_drawn_numbers = VALUE #( BASE lt_drawn_numbers ( lv_lotto_number_helper ) ).
      ENDIF.
      IF lines( lt_drawn_numbers ) = 6.
        EXIT.
      ENDIF.
    ENDDO.


    DO.
      DATA lv_player_input TYPE string.

      cl_s4d_output=>display_string( 'Please enter a comma separated list of 6 numbers between 1-49 without spaces' ).
      cl_s4d_input=>get_text(
       IMPORTING
         ev_text = lv_player_input
     ).
      DATA lt_split TYPE STANDARD TABLE OF string WITH NON-UNIQUE KEY table_line.
      SPLIT lv_player_input AT ',' INTO TABLE lt_split.

      IF lines( lt_split ) <> 6.
        cl_s4d_output=>display_string( 'You must enter exactly 6 numbers between 1-49 separated by a comma!' ).
        CONTINUE.
      ENDIF.

      DATA(lv_numbers_valid) = abap_true.
      LOOP AT lt_split INTO DATA(lv_input).
        DATA lv_input_converted TYPE cats_its_fields-num_value.
        CALL FUNCTION 'CATS_ITS_MAKE_STRING_NUMERICAL'
          EXPORTING
            input_string  = lv_input
          IMPORTING
            value         = lv_input_converted
          EXCEPTIONS
            not_numerical = 1
            OTHERS        = 2.

        IF sy-subrc = 1 OR sy-subrc = 2.
          lv_numbers_valid = abap_false.
          EXIT.
        ENDIF.

        IF lv_input_converted < 1 OR lv_input_converted > 49.
          lv_numbers_valid = abap_false.
          EXIT.
        ENDIF.
        DATA iv_input_conveted_as_i TYPE i.
        iv_input_conveted_as_i = lv_input_converted.
        IF NOT line_exists( lt_player_numbers[ table_line = iv_input_conveted_as_i ] ).
          lt_player_numbers = VALUE #( BASE lt_player_numbers ( iv_input_conveted_as_i ) ).
        ELSE.
          lv_numbers_valid = abap_false.
          EXIT.
        ENDIF.
      ENDLOOP.

      IF lv_numbers_valid = abap_false.
        cl_s4d_output=>display_string( 'You must enter exactly 6 numbers between 1-49 separated by a comma!' ).
        lv_numbers_valid = abap_true.
        CLEAR lt_player_numbers.
        CONTINUE.
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.

    DATA lv_counter_hits TYPE i.
    LOOP AT lt_player_numbers INTO DATA(lv_player_number_iterator).
      IF line_exists( lt_drawn_numbers[ table_line = lv_player_number_iterator ] ).
        lv_counter_hits = lv_counter_hits + 1.
      ENDIF.
    ENDLOOP.


    CASE lv_counter_hits.
      WHEN 6.
        lv_amount_won = 10 * amount_to_bet.
      WHEN 5.
        lv_amount_won = 6 * amount_to_bet.
      WHEN 4.
        lv_amount_won = 4 * amount_to_bet.
      WHEN 3.
        lv_amount_won = 2 * amount_to_bet.
      WHEN 2.
        lv_amount_won = amount_to_bet.
    ENDCASE.
    player->set_mv_currentmoney( iv_mv_currentmoney = player->get_mv_currentmoney( ) + lv_amount_won ).
    DATA lv_drawn_numbers TYPE string.
    lv_drawn_numbers = lt_drawn_numbers[ 1 ].

    DO 5 TIMES.
      lv_drawn_numbers = lv_drawn_numbers && ',' && lt_drawn_numbers[ sy-index + 1 ].
    ENDDO.
    cl_s4d_output=>display_string( iv_text = | The generated lotto numbers were { lv_drawn_numbers } and you selected { lv_player_input } There were { lv_counter_hits } matches. You won/lost { lv_amount_won - amount_to_bet } | ).
    player->display_status( ).
  ENDMETHOD.

ENDCLASS.
