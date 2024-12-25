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
    read_line_to_codes(Move),
    format('The character codes are: ~w~n', [Move]).

%---------------------------------------------------   

move(game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, CurrentPlayer), Move, game_state):-
    validate_move(Move),
    %atualizar boards do player1 e player2
    NextPlayer is (CurrentPlayer mod 2) + 1,
    NewState = game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, NextPlayer).

%--------------------------------------------------- 

%Validate Move

validate_move(Codes):-
    length(Codes, 2),
    write('Lenght Valid').
    %validate if it is in the Row Col range 
    %validate if it is a free space in the board


validate_move(Codes) :-
    length(Codes, _),
    write('Invalid input. Please enter exactly two characters'),
    read_move.

%---------------------------------------------------   
