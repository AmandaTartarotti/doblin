:- use_module(library(between)).

%utils

clear_buffer:-
    repeat,
    get_char(C),
    C = '\n',
    !.

get_number(Value) :-
    get_char(Char),
    char_code(Char, Code),
    Value is Code - 48.

%game-configuration

player(1, player1).
player(2, player2).

welcome:-
    write('*****************\n'),
    write('    Welcome!\n'),
    write('*****************\n').

game_rules:-
    write('Rules to be defined').

handle_mode(1):- game_play.
handle_mode(_):- 
    write('Other game_modes to be defined').

game_mode:-  
    write('\nChoose a game mode:\n'),
    write('1 - Human vs. Human\n'),
    write('2 - Human vs. Computer\n'),
    write('3 - Computer vs. Computer\n'),
    get_number(Mode),
    handle_mode(Mode).

game_start:-
    welcome,
    game_rules,
    game_mode.

game_play:-
    clear_buffer,
    write('\nHey Player 1 '),
    player_last_moves(Move),
    format('You chose as your last move ~w \n', [Move]),
    write('\nHey Player 1 '),
    game_board(Width, Length),
    format('You chose a board ~w x ~w \n', [Width, Length]).


player_last_moves(Move):-
    write('What will be your last 4 moves?\n'),
    write('1 - Empyt places\n'),
    write('2 - Joker places\n'),
    get_number(Move).

%Logica-para-pegar-o-tamanho-do-tabuleiro

handle_board(Value) :-
    between(4, 8, Value),          
    !.
handle_board(_) :-
    write('Invalid option. Try again.\n'),
    game_board.

board_width(Width):-
    write('Choose the board WIDTH:\n'),
    write('Hint: only numbers between 4-8:'),
    get_number(Width),
    handle_board(Width),
    clear_buffer.

board_length(Length):-
    write('\nChoose the board LENGTH:\n'),
    write('Hint: only numbers between 4-8:'),
    get_number(Length),
    handle_board(Length),
    clear_buffer.

game_board(Width, Length) :-
    clear_buffer,
    board_width(Width),
    board_length(Length).
