
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

read_move(Move):-
    write('Enter your move (example: 2B): '),
    read_line_to_codes(Move).
    %format('The character codes are: ~w~n', [Move]).

%---------------------------------------------------   

move(game_state(_, board_size(Width, Height), PlayerInfo1, _, _), Move):-
    validate_move(Move, board_size(Width, Height), PlayerInfo1), !. %passa um PlayerInfo qualquer para validar se é uma posição valida no board
    
    %execute_move(Move, PlayerInfo1, PlayerInfo2, UpdateInfo1, UpdateInfo2), %update the users board and score

    %NextPlayer is (CurrentPlayer mod 2) + 1,
    %NewState = game_state(Mode, board_size(Width, Height), UpdateInfo1, UpdateInfo2, NextPlayer).

move(GameState, _):-
    write('Invalid move. Please try again.\nEnter exactly two characters and make sure it is a free space on the board!\n'),
    nl,
    read_move(NewMove),
    move(GameState, NewMove).

%--------------------------------------------------- 

%Validate Move

validate_move([RowCode, ColCode], board_size(Width, Height), player_info(_, _, _, Board)):-
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

    input_checker(1, Height, Row),
    input_checker(1, Width, Col),
    %write('Move in a valid range\n').

%validate if it is a free space in the board

find_cellcode(RowNumber, Col, board(ShuffledNumbers, ShuffledLetters, Cells), CellCode):-

    char_code(ColChar, Col), 

    %format('The character Row is ~w and Col ~w ~n', [RowNumber, ColChar]),

    find_index(ColChar, ShuffledLetters, ColIndex),
    %format('The index Col is ~w ~n', [ColIndex]),

    find_index(RowNumber, ShuffledNumbers, RowIndex),
    %format('The index Row is ~w~n', [RowIndex]),
    
    nth1(RowIndex, Cells, RowList),  % Get the row in the board
    nth1(ColIndex, RowList, Cell),   % Get the cell in the row 
    
    char_code(Cell, CellCode).
    %format('The character code is: ~w~n', [CellCode]).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         

validate_free_space(45):- 
    write('Free Space, Move Valid!\n').

validate_free_space(_):- 
    write('This space is occupied..\n'),
    fail.
    

%---------------------------------------------------   

%general implementation of the inputs_handlers, but always repeats the message twice for some reason :c
input_checker(Min, Max, Value) :-
    between(Min, Max, Value).
input_checker(_):-
    write('Invalid option. Try again.\n'),
    clear_buffer,
    fail. 
