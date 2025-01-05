
% welcome/0
% Displays the welcome message for the Doblin game, including game modes and options
welcome:-
    write('===================================================================\n'),
    write('=                                                                 =\n'),
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
    write('            [3]     Computer vs. Human                             \n'),
    write('            [4]     Computer vs. Computer                          \n'),
    write('                                                                   \n'),
    write('            Other:                                                 \n'),
    write('            [5]     RULES                                          \n'),
    write('            [6]     INFORMATION ABOUT PROJECT                      \n'),
    write('-------------------------------------------------------------------\n'),
    write('                     Ready to start? Let\'s go!                    \n'),
    nl.

% game_rules/0
% Prints the game rules and instructions for playing Doblin, including the objective,
% turn requirements, scoring, and strategy tips
game_rules :-
    nl,
    write('#############################################################\n'),
    write('#                       GAME RULES                          #\n'),
    write('#############################################################\n'),
    write('# 1. Objective:                                             #\n'),
    write('#    To be the player with the fewest lines                 #\n'),
    write('#    and squares of four same symbols.                      #\n'),
    write('#                                                           #\n'),
    write('# 2. Game Setup:                                            #\n'),
    write('#    - Choose the game mode: H/H, H/PC, PC/H, or PC/PC.     #\n'),
    write('#    - If playing against a PC, select the difficulty       #\n'),
    write('#      level of the artificial player (Easy or Hard).       #\n'),
    write('#    - At the start of the game, players must decide if     #\n'),
    write('#      the last four spaces will be empty or jokers.        #\n'),
    write('#      Jokers count as both "O" and "X".                    #\n'),
    write('#                                                           #\n'),
    write('#    - To select a move, insert the coordinate of the       #\n'),
    write('#      letter and number where you want to play.            #\n'),
    write('#                                                           #\n'),
    write('#    - The "advantage percentage" is a value that           #\n'),
    write('#      indicates how likely a player is to win.             #\n'),
    write('#                                                           #\n'),
    write('# 3. Taking Turns:                                          #\n'),
    write('#    - Each turn, the player must place both an X           #\n'),
    write('#      and an O in two different cells on the grid.         #\n'),
    write('#                                                           #\n'),
    write('# 4. Winning the Game:                                      #\n'),
    write('#    - The game ends when all cells are filled.             #\n'),
    write('#    - The winner is the player who has the fewest lines    #\n'),
    write('#     (diagonal, rows, or columns) and squares of four      #\n'),
    write('#     same symbols.                                         #\n'),
    write('#                                                           #\n'),
    write('# 4. Strategy Tips:                                         #\n'),
    write('#    - Pay attention to the placement of symbols and avoid  #\n'),
    write('#      creating unwanted lines or squares.                  #\n'),
    write('#    - Keep an eye on your opponents and aim to block them  #\n'),
    write('#      while minimizing your own mistakes.                  #\n'),
    write('#                                                           #\n'),
    write('#                                                           #\n'),
    write('#    [E]EXIT                                                 #\n'),
    write('#############################################################\n'),
    nl.

% info_about_project/0
% Displays information about the project
info_about_project:-
    nl,
    write('##############################################################\n'),
    write('#                      INFO ABOUT PROJECT                    #\n'),
    write('##############################################################\n'),
    write('# 1. Project Name: Doblin Game                               #\n'),
    write('#    The game was developed by Amanda Silva and Tatiana Lin  #\n'),
    write('#    during the academic year 24/25 as part of the Bachelor  #\n'),
    write('#    in Computer and Informatics Engenieering at FEUP.       #\n'),
    write('#                                                            #\n'),
    write('#    It was created for the subject "Functional and Logic    #\n'), 
    write('#    Programming," guided by Professor Goncalo Leao          #\n'),
    write('#    [E]EXIT                                                 #\n'),
    write('##############################################################\n'),
    nl. 

%--------------------------------------------------
%--------------------------------------------------
%GAME MENU

%Allows configuring the game type (H/H, H/PC, PC/H, or PC/PC), difficulty level(s) to be used and define each user last moves 
game_menu(game_configuration(Mode, board_size(Width, Height), player_info(1, Last_move1, 0, Board1, Level1), player_info(2, Last_move2, 0, Board2, Level2))):-
    welcome,
    game_mode(Mode, Last_move1, Last_move2, Level1, Level2), % Obter o modo de jogo e os movimentos finais dos jogadores
    nl,
    game_board(Width, Height),
    
    nl,
    write(' ============================\n'),
    format('|  You chose a board ~w x ~w!  |\n', [Width, Height]),
    write(' ============================\n'),
    nl,

    % generate boards
    generate_board(Width, Height, Board1), 
    generate_board(Width, Height, Board2). 

%--------------------------------------------------
%--------------------------------------------------

%GAME MODE HANDLER

%Return the game mode (H/H, H/PC, PC/H, or PC/PC) and the players defined last_move
game_mode(Mode, Last_move1, Last_move2, Level1, Level2):-  
    get_number(Mode),
    handle_mode(Mode, Last_move1, Last_move2, Level1, Level2).

%-----------------------------------------------

%Handle Mode H/H 
handle_mode(1, Last_move1, Last_move2, Level1, Level2):- 
    game_human(1, Last_move1, Level1),
    game_human(2, Last_move2, Level2).

%Handle Mode H/PC 
handle_mode(2, Last_move1, Last_move2, Level1, Level2):- 
    game_human(1, Last_move1, Level1),
    game_machine(2, Last_move2, Level2).

%Handle Mode PC/H 
handle_mode(3, Last_move1, Last_move2, Level1, Level2):- 
    game_machine(1, Last_move1, Level1),
    game_human(2, Last_move2, Level2).

%Handle Mode PC/PC 
handle_mode(4, Last_move1, Last_move2, Level1, Level2):- 
    game_machine(1, Last_move1, Level1),
    game_machine(2, Last_move2, Level2).

%Handle Mode View Game Rules 
handle_mode(5, _Last_move1, _Last_move2, _Level1, _Level2):- 
    game_rules, 
    repeat,
    get_char(Char),
    member(Char,['E','e']),
    !, 
    clear_buffer,
    play.

%Handle Mode View info About Project
handle_mode(6, _Last_move1, _Last_move2, _Level1, _Level2):- 
    info_about_project,
    repeat,
    get_char(Char),
    member(Char,['E','e']),
    !, 
    clear_buffer,
    play.

%Handle Exceptions
handle_mode(_):- 
    write('Other game_modes to be defined'). 

%--------------------------------------------------

%Get Machine Player last moves
game_machine(Player, Last_move, Level):-
    define_level(Player, Level),
    random_last_moves(Last_move),
    format('\nPlayer ~w choose as the last move ~w\n', [Player, Last_move]).

%Generate the machine last moves
random_last_moves(MoveSymbol):-
    random_select(Move, [1,2], _Rest),
    get_symbol(Move, MoveSymbol).

%Defines the machine difficulty level
define_level(Player, Level):-
    repeat,
    clear_buffer,
    format('\nWhat will be the PC Player ~w difficulty level?\n', [Player]),
    write('1 - Level Easy\n'),
    write('2 - Level Hard\n'),
    get_number(Level),
    input_checker(1, 2, Level),
    format('You choose as the PC difficulty level ~w \n', [Level]).


%Get Human Player last moves
game_human(Player, Last_move, 0):-
    format('\nHey Player ~w', [Player]),    
    nl,
    player_last_moves(Last_move),
    format('You choose as your last move ~w \n', [Last_move]).

%player_last_moves 
player_last_moves(MoveSymbol) :-
    repeat,
    clear_buffer,
    write('\nWhat will be your last 4 moves?\n'),
    write('1 - Empty places\n'),
    write('2 - Joker places\n'),
    get_number(Move),
    input_checker(1, 2, Move),
    get_symbol(Move, MoveSymbol).

%Empyt places symbol
get_symbol(1,'*').

%Joker places symbol
get_symbol(2,'@').

%---------------------------------------------------
%--------------------------------------------------

%GAME BOARD HANDLER

%Generate Board with random indexes

random_index_number(Width, ShuffledNumbers):-
    findall(Number, between(1, Width, Number), List), %create a list of numbers between 1 and Width
    random_permutation(List, ShuffledNumbers). %shuffle this list using random

random_index_letters(Height, ShuffledLetters):- 
    End is 65 + Height - 1, %Código ASCII para 'A'
    findall(Letter, (between(65, End, Code), char_code(Letter, Code)), List),  %create a list of letters between a and Height
    random_permutation(List, ShuffledLetters). %shuffle

generate_empty_cells(Width, Height, Cells) :-
    length(Row, Width),          % Cria uma linha vazia com a largura definida
    maplist(=('-'), Row),        % Preenche a linha com espaços vazios
    length(Cells, Height),       % Cria a lista de linhas
    maplist(=(Row), Cells).      % Preenche cada linha com a mesma estrutura.

generate_board(Width, Height, board(ShuffledNumbers, ShuffledLetters, Cells)) :-
    random_index_number(Width, ShuffledNumbers), nl,
    random_index_letters(Height, ShuffledLetters),
    generate_empty_cells(Width, Height, Cells).

%--------------------------------------------------

%Define Board Size  

board_width(Width) :-
    repeat,        
    write('Choose the board WIDTH:\n'),
    write('Hint: only numbers between 4-8:'),
    get_number(Width),
    input_checker(4, 8, Width). 

board_length(Length) :-
    repeat,  % Retry loop
    write('\nChoose the board LENGTH:\n'),
    write('Hint: only numbers between 4-8:'),
    get_number(Length), 
    input_checker(4, 8, Length).   

game_board(Width, Length) :-
    clear_buffer,
    board_width(Width),
    clear_buffer,
    board_length(Length),
    clear_buffer.

%--------------------------------------------------
%--------------------------------------------------

%criar o board - antigo --> tive que mudar a implementação para add os indices

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

%show the board direitinho
format_board([]).  % Base case for empty list
format_board([Row|Rest]) :-
    format_row(Row),
    nl,  % New line after each row
    format_board(Rest).

format_row(Row) :-
    format('~w', [Row]).  % Print each row

