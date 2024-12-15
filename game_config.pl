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
    write('\nHey Player 1'),
    player_last_moves(Move),
    format('You choose as your last move ~w \n', [Move]),
    %write('\nHey Player 1 '),
    game_board(Width, Length),
    get_board(Width, Length, Board),  % Create the board
    format('You chose a board ~w x ~w \n', [Width, Length]),
    write('Your game board:\n'),
    format_board(Board).  % Print the board
    %format('Your game board:\n~w\n', [Board]).

%show the board direitinho
format_board([]).  % Base case for empty list
format_board([Row|Rest]) :-
    format_row(Row),
    nl,  % New line after each row
    format_board(Rest).

format_row(Row) :-
    format('~w', [Row]).  % Print each row

%criar o board
default(empty).
create_list(_, 0, []).
create_list(Element, Size, [Element|Sublist]) :-
    Size > 0,
    Size1 is Size - 1,
    create_list(Element, Size1, Sublist).

create_board(Element, Width, Length, Board) :-
    create_list(Element, Width, Row),  % Create a single row with `Width` elements
    create_list(Row, Length, Board).   % Repeat the row `Length` times to form the board

get_board(Width, Length, Board) :-
    default(Element),
    create_board(Element, Width, Length, Board).    


player_last_moves(Move):-
    write('What will be your last 4 moves?\n'),
    write('1 - Empyt places\n'),
    write('2 - Joker places\n'),
    get_number(Move).


%Logica-para-pegar-o-tamanho-do-tabuleiro

handle_board(Value) :-
    between(4, 8, Value).
   % between(4, 8, Value),          
   % !.    %perceber melhor, 
handle_board(_) :-
    write('Invalid option. Try again.\n'),
    clear_buffer,  % Clear the buffer before retrying
    %game_board. %its wrong because game_board uses 2 arguments, using fail its better
    fail.  % Force failure to retry input

board_width(Width):-
    repeat,          
    write('Choose the board WIDTH:\n'),
    write('Hint: only numbers between 4-8:'),
    get_number(Width),
    handle_board(Width),
    !.

board_length(Length) :-
    repeat,  % Retry loop
    write('\nChoose the board LENGTH:\n'),
    write('Hint: only numbers between 4-8:'),
    get_number(Length), 
    handle_board(Length),  
    !.  


game_board(Width, Length) :-
    clear_buffer,
    board_width(Width),
    board_length(Length).


