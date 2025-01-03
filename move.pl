%Here you will find:
%HANDLE GAME OVER
%HANDLE GAME MOVE
%HANDLE GAME SCORE

%---------------------------------------------------
%---------------------------------------------------

%HANDLE GAME OVER

%---------------------------------------------------
%---------------------------------------------------


congratulate(0):-
    write('#############################################################\n'),
    write('                  X      IT IS A TIE!      O                  \n'),
    write('#############################################################\n').   

congratulate(Winner):-
    Winner \= 0,
    write('#############################################################\n'),
    format('        CONGRATULATIONS THE WINNER IS PLAYER ~w\n', [Winner]),
    write('#############################################################\n').

%---------------------------------------------------


define_winner(game_state(_, _, player_info( _, _, Score1, _, _), player_info( _, _, Score2, _, _), _), Winner):-
    ScoreFinal is Score1 - Score2,
    compare_score(ScoreFinal, Winner).


compare_score(0,0).
compare_score(N, 1):- 
    N > 0.
compare_score(_, 2).

%---------------------------------------------------

execute_last_moves(game_state(Mode, BoardSize, PlayerInfo1, PlayerInfo2, CurrentPlayer), FinalGameState):-
    write('Player 1, you have 4 final pieces to place.\n'),
    get_level(game_state(Mode, BoardSize, PlayerInfo1, PlayerInfo2, CurrentPlayer), Level),
    place_final_pieces(
        4,
        game_state(Mode, BoardSize, PlayerInfo1, PlayerInfo2, CurrentPlayer), 
        IntermediateGameState, 
        Level),
    write('\nPlayer 2, your 4 final pieces are going to be placed in the remain spaces.\n'),
    place_remain_final_pieces(4, IntermediateGameState, FinalGameState),
    display_game(FinalGameState).

%---------------------------------------------------

%Place the final pieces for player 1 when it is a level 0 - human
place_final_pieces(0, GameState, GameState, 0) :- !.
place_final_pieces(
    N, 
    game_state(Mode, BoardSize, player_info(Id1, Last_move1, Score1, Board1, Level1), PlayerInfo2, CurrentPlayer),
    FinalGameState, 
    0
):-
    N > 0,
    choose_move(game_state(Mode, BoardSize, player_info(Id1, Last_move1, Score1, Board1,Level1), PlayerInfo2, CurrentPlayer), _, moviment(UserMove, Last_move1)),
    move(game_state(Mode, BoardSize, player_info(Id1, Last_move1, Score1, Board1,Level1), PlayerInfo2, CurrentPlayer), moviment(UserMove, Last_move1), NewGameState),
    Remain is N - 1,
    display_game(NewGameState),
    place_final_pieces(Remain, NewGameState, FinalGameState,0).


%Place the final pieces for player 1 when it is a level 1 or 2 - machine
place_final_pieces(N, GameState, FinalGameState, _):-
    place_remain_final_pieces(N, GameState, FinalGameState).

place_remain_final_pieces(0,GameState, GameState) :- !.
place_remain_final_pieces(
    N,
    game_state(Mode, BoardSize, PlayerInfo1, player_info(Id2, Last_move2, Score2, Board2,Level2), CurrentPlayer), 
    FinalGameState
):-
    N > 0,
    valid_moves(game_state(Mode, BoardSize, PlayerInfo1, player_info(Id2, Last_move2, Score2, Board2,Level2), CurrentPlayer), ValidMoves),
    random_select(RandomMove, ValidMoves, _Rest),
    format('RandomMove ~w', [RandomMove]),
    move(game_state(Mode, BoardSize, PlayerInfo1, player_info(Id2, Last_move2, Score2, Board2,Level2), CurrentPlayer),  moviment(RandomMove, Last_move2), NewGameState),
    Remain is N - 1,
    place_remain_final_pieces(Remain, NewGameState, FinalGameState).

    
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
    execute_move(moviment(Move,Symbol), PlayerInfo1, PlayerInfo2, UpdateInfo1, UpdateInfo2).

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

execute_move(moviment(Move,Symbol), player_info(_, Last_move1, _, Board1, Level1), player_info(_, Last_move2, _, Board2, Level2), player_info(1, Last_move1, NewScore1, NewBoard1, Level1), player_info(2, Last_move2, NewScore2, NewBoard2, Level2)):-

    update_board(moviment(Move,Symbol),Board1, NewBoard1),
    update_board(moviment(Move,Symbol),Board2, NewBoard2),

    count_score(NewBoard1, NewScore1),
    write('Moving to the other player score\n'),
    count_score(NewBoard2, NewScore2).

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
count_score(board(_, _, Cells), Score):- 
    %row
    score_lines(Cells, RowScore),

    %col
    transpose(Cells, Ts),
    score_lines(Ts,ColScore),

    %diagonal
    %squares

    Score is RowScore + ColScore.

%---------------------------------------------------  

%LINE CASE

%---Main Flow---

%Base Case
score_lines([], 0):- write('Finaly here\n').

%Recursive Case
score_lines([Line | Rest], TotalScore) :-
    %format('Line ~w and Rest ~w\n', [Line, Rest]),
    score_line(Line, LineScore),
    %format('Line Score: ~w\n', [LineScore]),
    score_lines(Rest, RestScore),
    %format('LineScore ~w & RestScore ~w\n', [LineScore,RestScore]),
    sum_score(LineScore, RestScore, TotalScore).

sum_score(LineScore, RestScore, TotalScore):-
    TotalScore is LineScore + RestScore.
    %format('LineScore ~w & RestScore ~w & TotalScore ~w\n', [LineScore,RestScore,TotalScore]).

%---Auxiliar Flow----

%Recursive Case with points
score_line([A,B,C,D|Tail], Score):-
    valid_sequence([A,B,C,D]),
    !,
    %format('A is ~w\n', [A]),
    %trace,
    write('Find one point\n'),
    score_line([B,C,D|Tail], NewScore),
    Score is NewScore + 1,
    format('NewScore ~w & Score ~w\n', [NewScore, Score]).

%Recursive Case without points
score_line([_,B,C,D|Tail], Score) :-
    %write('Nothing here sorry :c\n'),
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
equal_sequence(Cleaned):-
    sort(Cleaned, [_]).

%--------------------------------------------------- 

%DIAGONAL CASE -- under implementation

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
    
%---------------------------------------------------   