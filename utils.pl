:- use_module(library(between)).
:- use_module(library(random)).
:- use_module(library(lists)).
:- use_module(library(clpfd)).

%--------------------------------------------------

%Defined Data Structures

board_size( _Width, _Height).

game_configuration(_game_mode, _board_size, _player_info1, _player_info2).

game_state(_game_mode, _board_size, _player_info1,  _player_info2, _current_player).

player_info( _Player, _Last_move, _Score, _Board).

board(_Numbers, _Letters, _Cells).

moviment(_Move,_Symbol).

%empyt Last_move = 1
%joker Last_move = 2

%--------------------------------------------------

%utils functions

clear_buffer:-
    repeat,
    get_char(C),
    (C = '\n' ; C == -1),  % Verifica se encontrou um Enter ou final de arquivo
    !.

get_number(Value) :-
    get_char(Char),
    char_code(Char, Code),
    Value is Code - 48.

input_checker(Min, Max, Value) :-
    %format('Min ~w Max ~w Value ~w\n', [Min, Max, Value]),
    between(Min, Max, Value).
input_checker(_):-
    write('Invalid option. Try again.\n'),
    clear_buffer,
    fail. 

%--------------------------------------------------