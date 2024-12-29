
%---------------------------------------------------

%Read Move and transform user_input to ASCII code

read_line_to_codes(Codes) :-
    get_char(Char),
    char_code(Char, Code),
    process(Code, Codes).

process(10, []). % código ASCII para newline (10)
process(-1, []). % código ASCII para end_of_file (-1)
process(Code, [Code | Rest]) :-
    read_line_to_codes(Rest).

choose_move(_, moviment(Move, Symbol)):-
    Symbol = 'X',
    write('Enter your move (example: 2B): '),
    read_line_to_codes(Move).
    %format('The character codes are: ~w~n', [Move]).

%---------------------------------------------------   

move(game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, CurrentPlayer), moviment(Move,Symbol), NewState):-
    validate_move(moviment(Move,_), board_size(Width, Height), PlayerInfo1), %passa um PlayerInfo qualquer para validar se é uma posição valida no board
    !, 
    execute_move(moviment(Move,Symbol), PlayerInfo1, PlayerInfo2, UpdateInfo1, UpdateInfo2), 

    NextPlayer is (3 - CurrentPlayer),
    NewState = game_state(Mode, board_size(Width, Height), UpdateInfo1, UpdateInfo2, NextPlayer).

move(GameState, _, NewState):-
    write('Invalid move. Please try again.\nEnter exactly two characters and make sure it is a free space on the board!\n'),
    nl,
    choose_move(GameState, NewMove),
    move(GameState, NewMove, NewState).


%--------------------------------------------------- 

%Validate Move

validate_move(moviment([RowCode, ColCode], _), board_size(Width, Height), player_info(_, _, _, Board)):-
    length([RowCode, ColCode], 2),
    %write('Lenght Valid\n'),

    Row is RowCode - 48,    % '1'-'9'
    Col is ColCode - 64,    % 'A'-'Z'

    validate_range(Row, Col, board_size(Width, Height)),

    find_cellcode(Row, ColCode, Board, CellCode),
    validate_free_space(CellCode).

find_index(Value, List, Index) :-
    nth1(Index, List, Value).

%validate if it is in the Row Col range 
validate_range(Row, Col, board_size(Width, Height)):-

    input_checker(1, Height, Col),
    input_checker(1, Width, Row).
    %write('Move in a valid range\n').

%validate if it is a free space in the board

find_cellcode(RowNumber, Col, board(ShuffledNumbers, ShuffledLetters, Cells), CellCode):-

    char_code(ColChar, Col), 

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

validate_free_space(45):- 
    write('\nFree Space, Move Valid!\n').

%---------------------------------------------------
%---------------------------------------------------   

%execute move - update the users board and score

execute_move(moviment(Move,Symbol), player_info(_, Last_move1, _, Board1), player_info(_, Last_move2, _, Board2), UpdateInfo1, UpdateInfo2):-

    update_board(moviment(Move,Symbol),Board1, NewBoard1),
    update_board(moviment(Move,Symbol),Board2, NewBoard2),

    NewScore1 is 0, NewScore2 is 0,
    %count_score(NewBoard1, NewScore1),
    %count_score(NewBoard2, NewScore2),

    UpdateInfo1  = player_info(1, Last_move1, NewScore1, NewBoard1),
    UpdateInfo2  = player_info(2, Last_move2, NewScore2, NewBoard2).

%---------------------------------------------------  

update_board(moviment([RowCode, ColCode],Symbol), board(ShuffledNumbers, ShuffledLetters, Cells), NewBoard):-

    char_code(ColChar, ColCode),
    Row is RowCode - 48,

    find_index(ColChar, ShuffledLetters, ColIndex),
    %format('The index Col is ~w ~n', [ColIndex]),
    find_index(Row, ShuffledNumbers, RowIndex),
    %format('The index Row is ~w~n', [RowIndex]),

    nth1(ColIndex,Cells, OldRow),
    update_board_aux(OldRow, RowIndex, Symbol, NewRow),
    update_board_aux(Cells, ColIndex, NewRow, NewCells),

    NewBoard = board(ShuffledNumbers, ShuffledLetters, NewCells).


update_board_aux([_|Tail], 1, NewInsert, [NewInsert|Tail]).
update_board_aux([Head|Tail], Index, NewInsert, [Head|NewTail]) :-
    Index > 1, 
    NextIndex is Index - 1,
    update_board_aux(Tail, NextIndex, NewInsert, NewTail).

%---------------------------------------------------  

%count the total score for a board considering lines (Row and Column), diagonal and squares

count_score(board(_, _, Cells), Score):- 
    %lines
    score_lines(Cells, RowScore),
    Score is RowScore,
    format('RowScore: ~w\n', [RowScore]),
    format('Score: ~w\n', [Score]).

    %transpose(Cells, Ts),
    %format('Transpose ~w\n', [Ts]),
    %score_lines(Ts,ColScore),

    %diagonal
    %squares

    %Score is RowScore + ColScore.

%---------------------------------------------------  

%Line Case

score_lines([], 0).

score_lines([Line | Rest], TotalScore) :-
    %format('Line ~w and Rest ~w\n', [Line, Rest]),
    score_line(Line, LineScore),
    score_lines(Rest, RestScore),
    format('LineScore ~w & RestScore ~w\n', [LineScore,RestScore]),
    TotalScore is LineScore + RestScore.

%Recursive Case
score_line([A,A,A,A |Tail], Score):-
    A \= '-',
    %format('A ~w\n', [A]),
    score_line([A,A,A | Tail], NewScore),
    Score is NewScore + 1.
    %format('Score: ~w\n', [Score]).

score_line([_ | Tail], Score) :-
    score_line(Tail, Score).

%Base Case
score_line(Line, 0) :-
    length(Line, Len),
    Len < 4.

%--------------------------------------------------- 

%Diagonal Case -- under implementation

list_diag1([], []).
list_diag1([[E|_]|Ess], [E|Ds]) :-
    maplist(list_tail, Ess, Ess0),
    list_diag1(Ess0, Ds).

list_tail([_|Es], Es).

list_diag2(Ess,Ds) :-
    maplist(reverse, Ess, Fss),
    list_diag1(Fss, Ds).

%--------------------------------------------------- 

%Square Case
    
%--------------------------------------------------- 
%---------------------------------------------------   

%general implementation of the inputs_handlers, but always repeats the message twice for some reason :c
input_checker(Min, Max, Value) :-
    %format('Min ~w Max ~w Value ~w\n', [Min, Max, Value]),
    between(Min, Max, Value).
input_checker(_):-
    write('Invalid option. Try again.\n'),
    clear_buffer,
    fail. 
