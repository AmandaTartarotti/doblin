% initial_state(+GameConfig, -GameState)
% Initializes the game state based on the provided game configuration
% GameConfig -- includes the mode, board size, and players information
% GameState -- set with current player as Player 1
initial_state(
    game_configuration(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2), 
    game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, 1)
).

%-----------------------------------------------
% display_game(+GameState)
% Displays the current game state, including the boards, scores, and advantage percentages
display_game(game_state(_, board_size(Width, _), PlayerInfo1, PlayerInfo2, CurrentPlayer)) :-
    write('\n ***************************\n'),
    format('      Current Player: ~w\n', [CurrentPlayer]),
    write(' ***************************\n'),

    % Calculate advantage percentages to evaluate the current game state
    evaluate_game_state(game_state(_, _, PlayerInfo1, PlayerInfo2, CurrentPlayer), Perc1, Perc2),
    print_percentages(Perc1,Perc2),

    nl, write('Game Boards:\n'), nl,

    % Display each player's score and board
    print_player_info(PlayerInfo1, Width), nl,
    print_player_info(PlayerInfo2, Width), nl.

% print_player_info(+PlayerInfo, +Width)
% Prints the score and board for a given player
print_player_info(player_info(Player, _, Score, Board,_), Width) :-
    format('Player ~w score: ~w\n\n', [Player, Score]),
    print_player_board(Board, Width).

% print_player_board(+Board, +Width)
% Prints the board along with column headers and dividers
print_player_board(board(Numbers, Letters, Cells), _) :-
    write('   '), % um espaço adicional so para formatar bonitin c:
    print_numbers(Numbers),
    nl,
    write('  +'),
    print_divider(Numbers),
    nl,
    % each row with a letter
    print_board_rows(Letters, Cells).

% print_numbers(+List)
% Prints the column numbers on the board
print_numbers([]).
print_numbers([Num|Tail]) :-
    format(' ~w  ', [Num]),
    print_numbers(Tail).

% print_divider(+List)
% Prints the horizontal divider line
print_divider([]) :-
    write(' ').
print_divider([_|Tail]) :-
    write('---+'),
    print_divider(Tail).

% print_board_rows(+Letters, +Cells)
% Prints all rows with their corresponding letters and cell values
print_board_rows([], []).
print_board_rows([Letter|TailLetters], [Row|TailRows]) :-
    format('~w |', [Letter]),
    print_row(Row),
    nl,
    write('  +'),
    print_divider(Row),
    nl,
    print_board_rows(TailLetters, TailRows).

% print_row(+Row)
% Prints a single row of the board
print_row([]).
print_row([Cell|Tail]) :-
    format(' ~w |', [Cell]),
    print_row(Tail).

%-----------------------------------------------
%Define level

% get_level(+GameState, -Level)
% Retrieves the level of the current player
get_level(game_state(_, _, player_info( _, _, _, _, Level), _, 1), Level).
get_level(game_state(_, _, _, player_info( _, _, _, _, Level), 2), Level).


%-----------------------------------------------
%Next Player

% next_player(+GameState, -NextGameState)
% Switches the current player for the next turn
next_player(
    game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, CurrentPlayer), 
    game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, NextPlayer)
):-
    NextPlayer is (3 - CurrentPlayer).


%---------------------------------------------------
%---------------------------------------------------
%Value for Player 1 and Player 2

% evaluate_game_state(+GameState, -Perc1, -Perc2)
% Calculates the advantage percentages for both players based on their scores
evaluate_game_state(game_state(_, _, PlayerInfo1, PlayerInfo2, CurrentPlayer), Perc1, Perc2):-
    value(game_state(_, _, PlayerInfo1, PlayerInfo2, CurrentPlayer), 1, Value1),  %  value Player1
    value(game_state(_, _, PlayerInfo1, PlayerInfo2, CurrentPlayer), 2, Value2), %  value Player2

    TotalValue is Value1 + Value2,
    handle_percentages(Value1, Value2, TotalValue, Perc1, Perc2).

% handle_percentages(+Value1, +Value2, +TotalValue, -Perc1, -Perc2)
% Calculates the percentage of advantage for both players.
handle_percentages(_, _, 0, 0, 0) :- !.
    
handle_percentages(Value1, Value2, TotalValue, Perc1, Perc2) :-
    TotalValue \= 0,
    Perc1 is round((Value1 / TotalValue) * 100),
    Perc2 is round((Value2 / TotalValue) * 100).

% print_percentages(+Perc1, +Perc2)
% Prints the advantage percentages for both players.
print_percentages(0,0):-
    write('---------------------------------------'),nl,
    write('Player 1 advantage percentage: 0%\n'),
    write('Player 2 advantage percentage: 0%\n'), 
    write('---------------------------------------'),nl,nl.

print_percentages(Perc1,Perc2):-
    write('---------------------------------------'),nl,
    format('Player 1 advantage percentage: ~w%\n', [Perc1]),
    format('Player 2 advantage percentage: ~w%\n', [Perc2]) ,
    write('---------------------------------------'),nl,nl.

%value(+GameState, +Player, -Value)
%value Player 1, sees points of Player 2 
value(game_state(_, _, _, player_info(_, _, OpponentScore2, _OpponentBoard2,_), _), 1, OpponentScore2).
%value Player 2, sees points of Player 1 
value(game_state(_, _, player_info(_, _, OpponentScore1, _OpponentBoard1,_), _, _), 2, OpponentScore1).


%---------------------------------------------------
%---------------------------------------------------
% generate_cells(+Width, +Height, -ListOfCells)
% Generates a list of all possible cells on the board based on the provided dimensions
generate_cells(Width, Height, ListOfCells) :-
    findall(
        [RowChar, ColChar],
        (
            between(1, Width, Row),
            between(1, Height, Col),

            RowCode is Row + 48,                     
            ColCode is Col + 64, 

            char_code(RowChar, RowCode),            
            char_code(ColChar, ColCode)              
        ),
        ListOfCells
    ).


% valid_moves(+GameState, -ListOfMoves)
% List of valid moves for the current game state
valid_moves(game_state(_, board_size(Width, Height), PlayerInfo, _, _), ListOfMoves) :-
    integer(Width), integer(Height),

    generate_cells(Width, Height, AllCells),
    nl,

    % filters the valid moves
    findall(
        [RowChar, ColChar],
        (
            member([RowChar, ColChar], AllCells), % iterate the cells
            validate_move(moviment([RowChar, ColChar], _), board_size(Width, Height), PlayerInfo)
        ),
        ListOfMoves
    ),
    nl. 

