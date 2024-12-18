%/usr/local/sicstus4.9.0/bin/sicstus
%consult('/Users/tatianalin/Downloads/3ANO/PFL/Training/PROLOG/game_config.pl').

:- use_module(library(between)).
:- use_module(library(random)).

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

%--------------------------------------------------
handle_mode(1, Last_move1, Last_move2):- 
    game_human(1, Last_move1),
    game_human(2, Last_move2).
handle_mode(2, _Last_move1, _Last_move2):- 
    game_human(1, _Last_move1),
    write('game_mode 2 to be defined').
handle_mode(3, _Last_move1, _Last_move2):- 
    write('game_mode 3 to be defined').

handle_mode(4):- 
    game_rules, %fazer que ao clicar em [E] voltar para o menu
    repeat,
    get_char(Char),
    member(Char,['E','e']),
    %( Char = 'E' ; Char = 'e' ), 
    !, % Sai do repeat após uma entrada válida
    game_start.

handle_mode(5):-
    info_about_project,
    repeat,
    get_char(Char),
    member(Char,['E','e']),
    %( Char = 'E' ; Char = 'e' ), 
    !, % Sai do repeat após uma entrada válida
    game_start.

handle_mode(_):- 
    write('Other game_modes to be defined'). %dizer e fazer para repetir ate meter numero entre 1-5
%--------------------------------------------------

%Return the game mode (H/H, H/PC, PC/H, or PC/PC) and the players defined last_move
game_mode(Mode, Last_move1, Last_move2):-  
    get_number(Mode),
    handle_mode(Mode, Last_move1, Last_move2).

%--------------------------------------------------
%old game start, só mudei para seguir a nomenclatura que esta na descricao do projeto
game_menu:-
    welcome,
    game_mode(Mode, Last_move1, Last_move2),nl,
    game_board(Width, Height), %get the board measure -- user input
    
    %get_board(Width, Length, Board),  % Create the board
    nl,
    write(' ============================\n'),
    format('|  You chose a board ~w x ~w!  |\n', [Width, Height]),
    write(' ============================\n'),
    nl,

    %format_board(Board),  % Print the board
    generate_board(Width, Height), % Creates and Print the board
    nl,
    
    %Criar informações dos jogadores
    %PlayerInfo1  = player_info(1, Last_move1, 0),
    %PlayerInfo2  = player_info(2, Last_move2, 0),

    %Criar a configuração do jogo
    %GameConfig  = game_configuration(Mode, board_size(Width, Height), player_info1, player_info2),

    format('Game Mode: ~w\nPlayer1 last move: ~w\nPlayer2 last move: ~w\n', [Mode, Last_move1, Last_move2]).

game_human(Player, Last_move):-
    clear_buffer,
    format('\nHey Player ~w', [Player]),
    nl,
    player_last_moves(Last_move),
    format('You choose as your last move ~w \n', [Last_move]).


%------------------------------------------------

%Defined Data Structures

board_size( _Width, _Height).

game_configuration(_Game_mode, _board_size, _player_info1, _player_info2).

game_state(_player_turn).

player_info( _Player, _Last_move, _Score).

%empyt Last_move = 1
%joker Last_move = 2

%--------------------------------------------------

%general implementation of the inputs_handlers, but always repeats the message twice for some reason :c
input_checker(Min, Max, Value) :-
    between(Min, Max, Value).
input_checker(_):-
    write('Invalid option. Try again.\n'),
    clear_buffer,
    fail. 

%checks if it is a valid mode input
input_checker_mode(Value) :-
    between(1, 2, Value).
input_checker_mode(_):-
    write('Invalid option. Try again.\n'),
    clear_buffer,
    fail.  

%player_last_moves 
player_last_moves(Move) :-
    repeat,
    write('What will be your last 4 moves?\n'),
    write('1 - Empty places\n'),
    write('2 - Joker places\n'),
    get_number(Move),
    input_checker_mode(Move).
    %input_checker(1, 2, Move).

%--------------------------------------------------

%criar board com random indices 

random_index_number(Width):-
    findall(Number, between(1, Width, Number), List), %create a list of numbers between 1 and Width
    random_permutation(List, ShuffledList), %shuffle this list using random
    write('   '), % um espaço adicional so para formatar bonitin c:
    format('~w', [ShuffledList]).  % Print each row

random_index_letters(Height, ShuffledLetters):-
    Start is 65, %Código ASCII para 'A'
    End is Start + Height - 1,
    findall(Letter, (between(Start, End, Code), char_code(Letter, Code)), List),  %create a list of letters between a and Height
    random_permutation(List, ShuffledLetters). %shuffle

print_board_rows([], _).
print_board_rows([Letter|Tail], Width) :-
    findall('-', between(1, Width, _), Places),
    format('~w  ~w\n', [Letter, Places]),
    print_board_rows(Tail, Width).

generate_board(Width, Height) :-
    random_index_number(Width), nl,
    random_index_letters(Height, ShuffledLetters),
    print_board_rows(ShuffledLetters, Width).

%--------------------------------------------------

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

%show the board direitinho
format_board([]).  % Base case for empty list
format_board([Row|Rest]) :-
    format_row(Row),
    nl,  % New line after each row
    format_board(Rest).

format_row(Row) :-
    format('~w', [Row]).  % Print each row

%--------------------------------------------------
%Logica-para-pegar-o-tamanho-do-tabuleiro

input_checker_board(Value) :-
    between(4, 8, Value).
input_checker_board(_):-
    write('Invalid option. Try again.\n'),
    clear_buffer,  % Clear the buffer before retrying
    fail.  % Force failure to retry input

board_width(Width) :-
    repeat,        
    write('Choose the board WIDTH:\n'),
    write('Hint: only numbers between 4-8:'),
    get_number(Width),
    input_checker_board(Width).
    %input_checker(4, 8, Width). 

board_length(Length) :-
    repeat,  % Retry loop
    write('\nChoose the board LENGTH:\n'),
    write('Hint: only numbers between 4-8:'),
    get_number(Length), 
    input_checker_board(Length).
    %input_checker(4, 8, Length).   

game_board(Width, Length) :-
    clear_buffer,
    board_width(Width),
    clear_buffer,
    board_length(Length).

%DICAS PARA PROJETO 16/12/2024
%bot random
%bot mais inteligente

%O que é suposto fazer o bot inteligente? Ver o 'value'!!!!!
%Considerar todas as jogadas possiveis, e ver qual é a melhor jogada possivel.

%NO CASO DE CHESS
%a medida do site chess.com é que no exemplo do stor, tem 6 pioes de desvantagem
%fazer Nw-Nb, e fazer formula com o value das peças
%value= 9*(Qw-Qb)+5*(Rw-Rb)+3*(Bw-Bb)+3*(Nw-Nb)+1*(Pw-Pb)

%controlar o centro do tabuleiro
%ou seja nao só ver o numero de peças, mas tmb ver a posição das peças

%no das tartarugas, ver o numero de tartarugas que já passou para o lado do adversario
%+
%ver a distancia a que tao do outro lado do adversário

%Como condensar as duas condições?
%-Ter função que pesa as duas coisas
%value(State,Value):-
%    eval_n_pieces(State,V1),
%    eval_n_moves(State,V2),
%    Value is V1+V2. % ou até pode ser Value is V1*0.4+V2*0.6.

%valid_moves
%findall(move(X-Y), Xf-Yf), (between(1,8,X),..para o resto das variaveis), can_move(State,move(X-Y,Xf-Yf)),ListMoves).

%o bot nao é determinisco, dentro dos valid moves, fazer random!!!!! 
