%Here you will find:
%HANDLE GAME MOVE
%HANDLE GAME SCORE

    
%---------------------------------------------------
%---------------------------------------------------

%HANDLE GAME MOVE

%---------------------------------------------------
%---------------------------------------------------

%Read Move

read_line_to_string(String) :-
    get_char(Char),
    process(Char, String).

process('\n', []). % código ASCII para newline (10)
process(Char, [Char | Tail]) :-
    read_line_to_string(Tail).

%---------------------------------------------------  

move(
    game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, CurrentPlayer), 
    moviment(Move,Symbol), 
    game_state(Mode, board_size(Width, Height), UpdateInfo1, UpdateInfo2, CurrentPlayer)
):-
    validate_move(moviment(Move,_), board_size(Width, Height), PlayerInfo1), %passa um PlayerInfo qualquer para validar se é uma posição valida no board
    !, 
    execute_move(Width, Height, moviment(Move,Symbol), PlayerInfo1, PlayerInfo2, UpdateInfo1, UpdateInfo2), !.

move(GameState, moviment(_,Symbol), NewState):-
    write('\nInvalid move.\nEnter exactly two characters and make sure it is a free space on the board!\n'),
    nl,
    choose_move(GameState, _, moviment(NewMove,Symbol)),
    move(GameState, moviment(NewMove,Symbol), NewState).


%--------------------------------------------------- 

%Validate Move

%validate_move(moviment([RowChar, ColChar], _), board_size(Width, Height), player_info(_, _, _, Board)):-
validate_move(moviment([RowChar, ColChar], _), board_size(Width, Height), player_info(_, _, _, Board, _)):-
    %write('Validating move: '), write([RowChar, ColChar]),
    length([RowChar, ColChar], 2),
    %write('Lenght Valid\n'),

    char_code(RowChar, RowCode),
    char_code(ColChar, ColCode),

    Row is RowCode - 48,    % '1'-'9'
    Col is ColCode - 64,    % 'A'-'Z'

    validate_range(Row, Col, board_size(Width, Height)),

    find_cellcode(Row, ColChar, Board, CellCode),
    validate_free_space(CellCode).

find_index(Value, List, Index) :-
    nth1(Index, List, Value).

%validate if it is in the Row Col range 
validate_range(Row, Col, board_size(Width, Height)):-

    input_checker(1, Height, Col),
    input_checker(1, Width, Row).
    %write('Move in a valid range\n').

%validate if it is a free space in the board

find_cellcode(RowNumber, ColChar, board(ShuffledNumbers, ShuffledLetters, Cells), CellCode):-

    %format('The character Row is ~w and Col ~w ~n', [RowNumber, ColChar]),

    find_index(ColChar, ShuffledLetters, ColIndex),
    %format('The index Col is ~w ~n', [ColIndex]),

    find_index(RowNumber, ShuffledNumbers, RowIndex),
    %format('The index Row is ~w~n', [RowIndex]),
    
    nth1(ColIndex, Cells, RowList),  % Get the row in the board
    %format('RowList ~w', [RowList]),
    nth1(RowIndex, RowList, Cell),   % Get the cell in the row 
    
    char_code(Cell, CellCode).
    %format('The character code is: ~w~n', [CellCode]).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         

validate_free_space(45).
    %write('\nFree Space, Move Valid!\n')

%---------------------------------------------------

%execute move - update the users board and score

execute_move(Width, Height, moviment(Move,Symbol), player_info(_, Last_move1, _, Board1, Level1), player_info(_, Last_move2, _, Board2, Level2), player_info(1, Last_move1, NewScore1, NewBoard1, Level1), player_info(2, Last_move2, NewScore2, NewBoard2, Level2)):-

    update_board(moviment(Move,Symbol),Board1, NewBoard1),
    update_board(moviment(Move,Symbol),Board2, NewBoard2),

    count_score(Width, Height, NewBoard1, NewScore1),
    %write('Moving to the other player score\n'),
    count_score(Width, Height, NewBoard2, NewScore2).

%---------------------------------------------------  

update_board(
    moviment([RowChar, ColChar],Symbol), 
    board(ShuffledNumbers, ShuffledLetters, Cells), 
    board(ShuffledNumbers, ShuffledLetters, NewCells)
):-

    char_code(RowChar, RowCode),
    Row is RowCode - 48,

    find_index(ColChar, ShuffledLetters, ColIndex),
    %format('The index Col is ~w ~n', [ColIndex]),
    find_index(Row, ShuffledNumbers, RowIndex),
    %format('The index Row is ~w~n', [RowIndex]),

    nth1(ColIndex,Cells, OldRow),
    update_board_aux(OldRow, RowIndex, Symbol, NewRow),
    update_board_aux(Cells, ColIndex, NewRow, NewCells).


update_board_aux([_|Tail], 1, NewInsert, [NewInsert|Tail]).
update_board_aux([Head|Tail], Index, NewInsert, [Head|NewTail]) :-
    Index > 1, 
    NextIndex is Index - 1,
    update_board_aux(Tail, NextIndex, NewInsert, NewTail).
 
%---------------------------------------------------
%---------------------------------------------------

%HANDLE GAME SCORE

%---------------------------------------------------
%---------------------------------------------------

%count the total score for a board considering lines (Row and Column), diagonal and squares
count_score(Width, Height, board(_, _, Cells), Score):- 
    %row
    score_lines(Cells, RowScore),

    %col
    transpose(Cells, Ts),
    score_lines(Ts,ColScore),

    %diagonal
    score_diagonals(Width, Height, Cells, DiagonalScore, 4),

    %squares
    score_square(Width, Height, Cells, SquareScore),

    %format('\nRowScore ~w, ColScore ~w, DiagonalScore ~w, SquareScore ~w\n', [RowScore, ColScore, DiagonalScore,SquareScore]),
    Score is RowScore + ColScore + DiagonalScore + SquareScore.

%---------------------------------------------------  

%LINE CASE

%---Main Flow---

%Base Case
score_lines([], 0).

%Recursive Case
score_lines([Line | Rest], TotalScore) :-
    score_line(Line, LineScore),
    score_lines(Rest, RestScore),
    sum_score(LineScore, RestScore, TotalScore).

sum_score(LineScore, RestScore, TotalScore):-
    TotalScore is LineScore + RestScore.

%---Auxiliar Flow----

%Recursive Case with points
score_line([A,B,C,D|Tail], Score):-
    valid_sequence([A,B,C,D]),
    !,
    score_line([B,C,D|Tail], NewScore),
    Score is NewScore + 1.

%Recursive Case without points
score_line([_,B,C,D|Tail], Score) :-
    score_line([B,C,D|Tail],Score).

%Base Case
score_line(_Line, 0).

%---Validate Flow----

%The approach here is to remove all joker symbols and check if the remain ones are all equal 

valid_sequence([A,B,C,D]):-
    remove_jokers([A,B,C,D], Cleaned),
    equal_sequence(Cleaned).

remove_jokers([], []).
remove_jokers(['@'|T], Rest):-
    remove_jokers(T, Rest).
remove_jokers([H|T], [H|Rest]):-
    H \= '@', 
    remove_jokers(T, Rest).

equal_sequence([]).
equal_sequence([H|T]):-
    H \= '-',
    H \= '*',
    sort([H|T], [_]).

%--------------------------------------------------- 

%DIAGONAL CASE 

score_diagonals(Width, Height, Cells, TotalScore, N) :-
    findall(Diagonal, diagonal(Width, Height, Cells, Diagonal, N), Diagonals),
    %format('Diagonals ~w\n', [Diagonals]),
    score_lines(Diagonals, TotalScore).

%Busca uma diagonal válida

%Começa de cada linha na primeira coluna
diagonal(Width, Height, Cells, Diagonal, N) :-
    between(1, Height, StartRow), 
    extract_diagonal(Cells, StartRow, 1, 1, 1, Diagonal, Width, Height),
    length(Diagonal, Len), Len >= N.
    %format('Diagonal1 ~w\n', [Diagonal]).

% Começa de cada linha na última coluna
diagonal(Width, Height, Cells, Diagonal, N) :-
    between(2, Height, StartRow),
    extract_diagonal(Cells, StartRow, Width, 1, -1, Diagonal,Width, Height),
    length(Diagonal, Len), Len >= N.
    %format('Diagonal2 ~w\n', [Diagonal]).

%Começa de cada coluna na primeira linha
diagonal(Width, Height, Cells, Diagonal, N) :-
    % Começa de cada coluna na primeira linha
    between(2, Width, StartCol),
    extract_diagonal(Cells, 1, StartCol, 1, 1, Diagonal,Width, Height),
    length(Diagonal, Len), Len >= N.
    %format('Diagonal3 ~w\n', [Diagonal]).

%Começa de cada coluna na última linha
diagonal(Width, Height, Cells, Diagonal, N) :-
    between(1, Width, StartCol),
    %trace,
    extract_diagonal(Cells, 1, StartCol, 1, -1, Diagonal,Width, Height),
    length(Diagonal, Len), Len >= N.

%Se passar dos limites, nao é valido.
extract_diagonal(_, X, Y, _, _, [], Width, Height) :-
    \+ board_limits(X, Y, Width, Height),!.

%Extrai uma diagonal a partir de uma posição (X, Y) com direção (DX, DY)
extract_diagonal(Cells, X, Y, DX, DY, [Elem | Rest], Width, Height) :-
    %write('\n NN Falhei\n'),
    get_cell(Cells, X, Y, Elem),
    NX is X + DX,
    NY is Y + DY,
    extract_diagonal(Cells, NX, NY, DX, DY, Rest, Width, Height).

%Limites do tabuleiro
board_limits(X, Y, Width, Height) :-
    X >= 1,
    Y >= 1,
    X =< Height,
    Y =< Width.

% Obtém o elemento na célula (X, Y)
get_cell(Cells, X, Y, Elem) :-
    nth1(X, Cells, Row),
    nth1(Y, Row, Elem).


%--------------------------------------------------- 

list_diag1([], []).
list_diag1([[E|_]|Ess], [E|Ds]) :-
    maplist(list_tail, Ess, Ess0),
    list_diag1(Ess0, Ds).

list_tail([_|Es], Es).

list_diag2(Ess,Ds) :-
    maplist(reverse, Ess, Fss),
    list_diag1(Fss, Ds).

%--------------------------------------------------- 

%SQUARE CASE

% score_square(+Width, +Height, +Cells, -SquareScore)
score_square(Width, Height, Cells, SquareScore) :-
    findall(1,  (between(1, Height, X), 
         between(1, Width, Y), 
         valid_square(Cells, Width, Height, X, Y)), Squares),
    length(Squares, SquareScore).

% valid_square(+Cells, +Width, +Height, +X, +Y)
% Verifica se as coordenadas (X, Y), (X, Y+1), (X+1, Y), (X+1, Y+1) formam um quadrado válido.
valid_square(Cells, Width, Height, X, Y) :-
    X1 is X + 1,
    Y1 is Y + 1,
    board_limits(X1, Y1, Width, Height),
    nth1(X, Cells, Row1),
    nth1(X1, Cells, Row2),
    nth1(Y, Row1, A),
    nth1(Y1, Row1, B),
    nth1(Y, Row2, C),
    nth1(Y1, Row2, D),
    valid_sequence([A, B, C, D]).

    
%---------------------------------------------------   