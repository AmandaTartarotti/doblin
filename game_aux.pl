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
   
print_player_info(player_info(Player, _, Score, Board,_), Width) :-
    format('Player ~w score: ~w\n\n', [Player, Score]),
    print_player_board(Board, Width).

print_player_board(board(Numbers, Letters, Cells), _) :-
    write('   '), % um espaço adicional so para formatar bonitin c:
    print_numbers(Numbers),
    nl,
    write('  +'),
    print_divider(Numbers),
    nl,
    % cada linha com a sua letra
    print_board_rows(Letters, Cells).

% 1º linha com os numeros
print_numbers([]).
print_numbers([Num|Tail]) :-
    format(' ~w  ', [Num]),
    print_numbers(Tail).

% divisor horizontal das linhas
print_divider([]) :-
    write(' ').

print_divider([_|Tail]) :-
    write('---+'),
    print_divider(Tail).

% todas as linhas 
print_board_rows([], []).
print_board_rows([Letter|TailLetters], [Row|TailRows]) :-
    format('~w |', [Letter]),
    print_row(Row),
    nl,
    write('  +'),
    print_divider(Row),
    nl,
    print_board_rows(TailLetters, TailRows).

% uma só linha
print_row([]).
print_row([Cell|Tail]) :-
    format(' ~w |', [Cell]),
    print_row(Tail).

%-----------------------------------------------
%Define level

%return player level
get_level(game_state(_, _, player_info( _, _, _, _, Level), _, 1), Level).
get_level(game_state(_, _, _, player_info( _, _, _, _, Level), 2), Level).


%-----------------------------------------------
%Next Player

next_player(
    game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, CurrentPlayer), 
    game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, NextPlayer)
):-
    NextPlayer is (3 - CurrentPlayer).


%---------------------------------------------------
%---------------------------------------------------
% value for Player 1 and Player 2
%evaluate_game_state(GameState, Value1, Value2) :-
evaluate_game_state(game_state(_, _, PlayerInfo1, PlayerInfo2, CurrentPlayer), Perc1, Perc2):-
    %write('----------- Calculating Value for Player 1 -----------'), nl,
    value(game_state(_, _, PlayerInfo1, PlayerInfo2, CurrentPlayer), 1, Value1),  % calculate value for Player1
    %format('Player 1 Value: ~w\n', [Value1]), nl,

    %write('----------- Calculating Value for Player 2 -----------'), nl,
    value(game_state(_, _, PlayerInfo1, PlayerInfo2, CurrentPlayer), 2, Value2), % calculate value for Player2
    %format('Player 2 Value: ~w\n', [Value2]), nl,
    %format('Value1: ~w Value2: ~w\n', [Value1, Value2]),nl,

    TotalValue is Value1 + Value2,
    handle_percentages(Value1, Value2, TotalValue, Perc1, Perc2).

handle_percentages(_, _, 0, 0, 0) :- !.% se TotalValue é zero, a percentagem fica a 0
    
handle_percentages(Value1, Value2, TotalValue, Perc1, Perc2) :-
    TotalValue \= 0,
    Perc1 is round((Value1 / TotalValue) * 100),
    Perc2 is round((Value2 / TotalValue) * 100).

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

%value(+GameState, +Player, -Value).
%value do Player1, vê os pontos do jog2
value(game_state(_, _, _, player_info(_, _, OpponentScore2, _OpponentBoard2,_), _), 1, OpponentScore2).
%value do Player1, vê os pontos do jog1
value(game_state(_, _, player_info(_, _, OpponentScore1, _OpponentBoard1,_), _, _), 2, OpponentScore1).


%---------------------------------------------------
%---------------------------------------------------
% generate_cells(+Width, +Height, -ListOfCells)
%todas as células do tabuleiro 
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
valid_moves(game_state(_, board_size(Width, Height), PlayerInfo, _, _), ListOfMoves) :-
    %write('Width: '), write(Width), 
    %nl,
    %write('Height: '), write(Height), 
    %nl,
    integer(Width), integer(Height),

    generate_cells(Width, Height, AllCells),
    %write('AllCells: '), write(AllCells), 
    nl,

    % aqui que filtra os moves que sao válidos
    findall(
        [RowChar, ColChar],
        (
            member([RowChar, ColChar], AllCells), % itera pelas cells
            %write('Checking cell: '), write([RowChar, ColChar]), nl,
            validate_move(moviment([RowChar, ColChar], _), board_size(Width, Height), PlayerInfo)
            %validate_move(moviment([RowChar, ColChar], _), board_size(Width, Height), PlayerInfo),
            %write('Valid cell: '), write([RowChar, ColChar]), nl 
        ),
        ListOfMoves
    ),
    %write('ListOfMoves: '), write(ListOfMoves), 
    nl. 

%---------------------------------------------------
%---------------------------------------------------