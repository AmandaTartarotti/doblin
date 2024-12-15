:- use_module(library(between)).

clear_buffer:-
    repeat,
    get_char(C),
    C = '\n',
    !.

welcome:-
    write('*****************\n'),
    write('    Welcome!\n'),
    write('*****************\n').

menu_mode:-  
    write('Choose a game mode:\n'),
    write('1 - Human vs. Human\n'),
    write('2 - Human vs. Computer\n'),
    write('3 - Computer vs. Computer\n').

game_rules:-
    write('To be defined').

game_start:-
    welcome,
    game_board.

%Logica-para-pegar-o-tamanho-do-tabuleiro

get_number(Value) :-
    get_char(Char),
    char_code(Char, Code),
    !,
    Value is Code - 48,
    handle_board(Value).

handle_board(Value) :-
    between(4, 8, Value),          
    !.
handle_board(_) :-
    write('Invalid option. Try again:\n'),
    clear_buffer,
    game_board.

board_width(Width):-
    write('\nChoose the board WIDTH:\n'),
    write('Hint: only numbers between 4-8:'),
    get_number(Width),
    clear_buffer.

board_length(Length):-
    write('\nChoose the board LENGTH:\n'),
    write('Hint: only numbers between 4-8:'),
    get_number(Length),
    clear_buffer.

game_board :-
    board_width(Width),
    board_length(Length),
    format('C - You chose a board ~w x ~w \n', [Width, Length]).
