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
    write('===================================================================\n'),
    write('=                                                                 =\n'),
    %write('=        ██████╗   ██████╗  ██████╗  ██╗     ██╗ ███╗   ██╗ =\n'),
    %write('=      ██╔════██╗ ██╔═══██║ ██╔══██╗ ██║     ██║ ████╗  ██║ =\n'),
    %write('=      ██║     ██║██║   ██║ ██████╔╝ ██║     ██║ ██╔██╗ ██║ =\n'),
    %write('=      ██║    ██║ ██║   ██║ ██   ██║ ██║     ██║ ██║╚██╗██║ =\n'),
    %write('=      ╚██████╔╝  ╚██████╔╝ ███████║ ███████╗██║ ██║ ╚████║ =\n'),
    %write('=       ╚═════╝    ╚═════╝  ╚═════╝  ╚══════╝╚═╝ ╚═╝  ╚═══╝ =\n'),
    write('#       #######    ########  ########  ##      ##  ####    ##     #\n'),
    write('#      ##     ##  ##      ## ##     ## ##      ##  ####    ##     #\n'),
    write('#      ##      ## ##      ## ##    ##  ##      ##  ##  ##  ##     #\n'),
    write('#      ##      ## ##      ## ########  ##      ##  ##   #####     #\n'),
    write('#      ##     ##  ##      ## ##     ## ##      ##  ##     ###     #\n'),
    write('#      ########    ########  ########  ####### ##  ##     ###     #\n'),
    write('#                                                                 #\n'),
    write('=                                                                 =\n'),
    write('===================================================================\n'),
    write('                          WELCOME TO DOBLIN                        \n'),
    write('                    A Strategy Board Game Experience               \n'),
    write('-------------------------------------------------------------------\n'),
    write('            Choose your mode!                                      \n'),
    write('            [1]     Human vs. Human                                \n'),
    write('            [2]     Human vs. Computer                             \n'),
    write('            [3]     Computer vs. Computer                          \n'),
    write('                                                                   \n'),
    write('            Other:                                                 \n'),
    write('            [4]     RULES                                          \n'),
    write('            [5]     INFORMATION ABOUT PROJECT                      \n'),
    write('-------------------------------------------------------------------\n'),
    write('                     Ready to start? Let\'s go!                    \n'),
    nl.


game_rules :-
    nl,
    write('#############################################################\n'),
    write('#                       GAME RULES                          #\n'),
    write('#############################################################\n'),
    write('# 1. Objective:                                             #\n'),
    write('#    - ------------                                         #\n'),
    write('#    - ------------                                         #\n'),
    write('#                                                           #\n'),
    write('# 2. Game Setup:                                            #\n'),
    write('#    - ------------                                         #\n'),
    write('#    - ------------                                         #\n'),
    write('#                                                           #\n'),
    write('# 3. -----------------                                      #\n'),
    write('#    - ------------                                         #\n'),
    write('#    - ------------                                         #\n'),
    write('#                                                           #\n'),
    write('# 4. ---------------                                        #\n'),
    write('#    - ------------                                         #\n'),
    write('#    - ------------                                         #\n'),
    write('#                                                           #\n'),
    write('# 5. Winning the Game:                                      #\n'),
    write('#    - ------------                                         #\n'),
    write('#    - ------------                                         #\n'),
    write('#                                                           #\n'),
    write('# 6. Strategy Tips:                                         #\n'),
    write('#    - ------------                                         #\n'),
    write('#    - ------------                                         #\n'),
    write('#                                                           #\n'),
    write('#    [E]EXIT                                                 #\n'),
    write('#############################################################\n'),
    nl.

info_about_project:-
    nl,
    write('###############################################################\n'),
    write('#                       INFO ABOUT PROJECT                    #\n'),
    write('###############################################################\n'),
    write('# 1. Project Name:                                            #\n'),
    write('#    - ------------                                           #\n'),
    write('#                                                             #\n'),
    write('#    [E]EXIT                                                  #\n'),
    write('###############################################################\n'),
    nl. 

%handle_mode(1):- game_play.
%handle_mode(_):- 
%    write('Other game_modes to be defined').

%game_mode:-  
%    write('\nChoose a game mode:\n'),
%   write('1 - Human vs. Human\n'),
%   write('2 - Human vs. Computer\n'),
%   write('3 - Computer vs. Computer\n'),
%   get_number(Mode),
%   handle_mode(Mode).

%game_start:-
    %welcome,
    %game_rules,
    %game_mode.

handle_mode(1):- game_config.
handle_mode(2):- 
    write('game_mode 2 to be defined').
handle_mode(3):- 
    write('game_mode 3 to be defined').

handle_mode(4):- 
    game_rules, %fazer que ao clicar em [E] voltar para o menu
    repeat,
    get_char(Char),
    ( Char = 'E' ; Char = 'e' ), % Aceitar tanto 'E' quanto 'e' %como fazemos para nao usar '='??? aqui usamos o '='
    !, % Sai do repeat após uma entrada válida
    game_start.

handle_mode(5):-
    info_about_project,
    repeat,
    get_char(Char),
    ( Char = 'E' ; Char = 'e' ), % Aceitar tanto 'E' quanto 'e' %como fazemos para nao usar '='??? aqui usamos o '='
    !, % Sai do repeat após uma entrada válida
    game_start.

handle_mode(_):- 
    write('Other game_modes to be defined'). %dizer e fazer para repetir ate meter numero entre 1-5

game_mode:-  
    get_number(Mode),
    handle_mode(Mode).

game_start:-
    welcome,
    game_mode.

game_config:-
    clear_buffer,
    write('\nHey Player 1'),
    nl,
    player_last_moves(Move),
    format('You choose as your last move ~w \n', [Move]),
    %write('\nHey Player 1 '),
    game_board(Width, Length),
    get_board(Width, Length, Board),  % Create the board
    nl,
    write(' ============================\n'),
    format('|  You chose a board ~w x ~w!  |\n', [Width, Length]),
    write(' ============================\n'),
    nl,
    %write('Your game board:\n'),
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
default('-').
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
    write('1 - Empty places\n'),
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


