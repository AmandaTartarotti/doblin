%-----------------------------------------------

%initial_state(
%    game_configuration(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2), GameState
%):-
    %CurrentPlayer = 1,
    %GameState = game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, CurrentPlayer).
%tirar '='
initial_state(
    game_configuration(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2), 
    game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, 1)
).

%-----------------------------------------------

%Display game and aux predicates

display_game(game_state(_, board_size(Width, _), PlayerInfo1, PlayerInfo2, CurrentPlayer)) :-
    write('\n ***************************\n'),
    format('      Current Player: ~w\n', [CurrentPlayer]),
    write(' ***************************\n'),

    nl, write('Game Boards:\n'), nl,

    %Imprimir informações dos jogadores
    print_player_info(PlayerInfo1, Width), nl,
    print_player_info(PlayerInfo2, Width), nl. 

%print_player_info(player_info(Player, _, Score, Board), Width) :-
print_player_info(player_info(Player, _, Score, Board,_), Width) :-
    format('Player ~w score: ~w\n', [Player, Score]),
    nl,
    print_player_board(Board, Width).


print_player_board(board(Numbers, Letters, Cells), _) :-
    write('   '), % um espaço adicional so para formatar bonitin c:
    %format('~w', [Numbers]), nl,  % Print each row
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

%O player vai ser humano(1) quando o Mode for 1 | quando o Mode for 2 e o CurrentPlayer for 1 | quando o Mode for 3 e o CurrentPlayer for 2
%O player vai ser computer(2) quando o Mode for 4 | quando o Mode for 2 e o CurrentPlayer for 2 | quando o Mode for 3 e o CurrentPlayer for 1


%Case H/H
define_player(game_state(1, _, _, _, _), Player):- Player is 1.

%Case H/PC
define_player(game_state(2, _, _, _, CurrentPlayer), Player):- Player is CurrentPlayer.

%Case PC/H
define_player(game_state(3, _, _, _, CurrentPlayer), Player):- Player is 3 - CurrentPlayer.

%Case PC/PC
define_player(game_state(4, _, _, _, _), Player):- Player is 2.

%-----------------------------------------------

%Next Player

%next_player(game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, CurrentPlayer), NewState):-
%    NextPlayer is (3 - CurrentPlayer),
%    NewState = game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, NextPlayer).
%tirar '='
next_player(
    game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, CurrentPlayer),
    game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, NextPlayer)
) :-
    NextPlayer is 3 - CurrentPlayer.

%---------------------------------------------------

%Game Over

%Embora nas descricao do projeto diz para o game_over não imprimir nada no terminal, 
%no caso do nosso jogo precisamos fazer as 8 jogadas finais para definir o winner.

%Recives a GameState where the CurrentPlayer is 1, checks if there are 8 remain moves to be played, if so it execute the last moves and returns the winner.

game_over(game_state(Mode, BoardSize, PlayerInfo1, PlayerInfo2, 1), Winner):-
    valid_moves(game_state(Mode, BoardSize, PlayerInfo1, PlayerInfo2, 1), ValidMoves),
    length(ValidMoves, 8), %Confirma que restam exatamente 8 jogadas
    execute_last_moves(
        game_state(Mode, BoardSize, PlayerInfo1, PlayerInfo2, 1), 
        FinalGameState
    ),
    define_winner(FinalGameState, Winner).

game_over(_,_):-
    fail.

%---------------------------------------------------
 

%value(+GameState, +Player, -Value).

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
    write('Width: '), write(Width), 
    nl,
    write('Height: '), write(Height), 
    nl,

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
    ).
    %write('ListOfMoves: '), write(ListOfMoves), nl. 

%---------------------------------------------------
%---------------------------------------------------

