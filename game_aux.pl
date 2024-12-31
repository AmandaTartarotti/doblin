%-----------------------------------------------

initial_state(
    game_configuration(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2), GameState
):-
    CurrentPlayer = 1,
    GameState = game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, CurrentPlayer).

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

print_player_info(player_info(Player, _, Score, Board), Width) :-
    format('Player ~w score: ~w\n', [Player, Score]),
    print_player_board(Board, Width).

print_player_board(board(Numbers, Letters, Cells), Width) :-
    write('   '), % um espaço adicional so para formatar bonitin c:
    format('~w', [Numbers]), nl,  % Print each row
    print_board_rows(Letters, Cells, Width).

print_board_rows([], [], _).
print_board_rows([Letter|Tail], [CellHead|CellTail], Width) :-
    format('~w  ~w\n', [Letter, CellHead]),
    print_board_rows(Tail, CellTail, Width).

%-----------------------------------------------

%O player vai ser humano(1) quando o Mode for 1 | quando o Mode for 2 e o CurrentPlayer for 1 | quando o Mode for 3 e o CurrentPlayer for 2
%O player vai ser computer(1) quando o Mode for 4 | quando o Mode for 2 e o CurrentPlayer for 2 | quando o Mode for 3 e o CurrentPlayer for 1

define_player(_GameState, Player):-
    Player is 1. %Por enquanto, só temos o H/H

%-----------------------------------------------

%Next Player

next_player(game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, CurrentPlayer), NewState):-
    NextPlayer is (3 - CurrentPlayer),
    NewState = game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, NextPlayer).

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

%Valid Moves -- falta implementar corretamente fiz uma gambiarra para testar o game_over

valid_moves(_, ValidMoves):-

    %Use this one to avoid the game_over as it has more than 8 elements
    ValidMoves = [['1', 'A'], ['2', 'A'], ['3', 'A'], ['4', 'A'], ['1', 'B'], ['2', 'B'], ['4', 'B'], ['3', 'B'], ['X','X']].

    %Use this one to access the game_over as it has 8 elements
    %ValidMoves = [['1', 'A'], ['2', 'A'], ['3', 'A'], ['4', 'A'], ['1', 'B'], ['2', 'B'], ['4', 'B'], ['3', 'B']].
    %format('ValidMoves -- ~w\n', [ValidMoves]).

%---------------------------------------------------
%---------------------------------------------------