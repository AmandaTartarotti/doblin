%---------------------------------------------------
%---------------------------------------------------
%HANDLE GAME OVER
% Addendum: although the project description says that game_over should not print anything to the terminal,
% in our game, we need to make the last 8 moves to determine the winner.

%---------------------------------------------------
%---------------------------------------------------

%game_over(+GameState, -Winner)

%game_state -- recives a current game state
%Winner -- returns the PlayerID with the biggest score

%Strategy: receives a GameState where the CurrentPlayer is 1, checks if there are 8 remaining moves to be played, 
%and if so, it executes the last moves and returns the winner.
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

congratulate(0):-
    nl
    write('#############################################################\n'),
    write('                  X      IT IS A TIE!      O                  \n'),
    write('#############################################################\n').   

congratulate(Winner):-
    Winner \= 0, 
    nl,
    write('#############################################################\n'),
    format('        CONGRATULATIONS THE WINNER IS PLAYER ~w\n', [Winner]),
    write('#############################################################\n').

%---------------------------------------------------

%define_winner(+GameState, -Winner)

%game_state -- recives a current game state
%Winner -- returns the PlayerID with the biggest score

%Strategy: subtract the user scores and uses an auxiliar function to return the WinnerId

define_winner(game_state(_, _, player_info( _, _, Score1, _, _), player_info( _, _, Score2, _, _), _), Winner):-
    ScoreFinal is Score1 - Score2,
    compare_score(ScoreFinal, Winner).


compare_score(0,0).              %Tie
compare_score(N, 2):-  N > 0.    %Winner is Player 1
compare_score(_, 1).             %Winner is Player 2

%---------------------------------------------------

%execute_last_moves(+GameState, -FinalGameState)

%GameStateves -- recives a current game state
%FinalGameState -- returns the final game state after playing the four final moves

%Strategy: checks if the Player1 is a human or an artificial player, then call an auxiliar function place_final_pieces
%to handle the player1 final moves. The player2 moves must fill the remain spaces on the board, which is done through
%an auxiliar function place_remain_final_pieces, that finally returns the FinalGameState.

execute_last_moves(game_state(Mode, BoardSize, player_info(Id1, Last_move1, Score1, Board1, Level1), player_info(Id2, Last_move2, Score2, Board2, Level2), CurrentPlayer), FinalGameState):-
    
    write('Player 1, you have 4 final pieces to place.\n'),
    get_level(game_state(Mode, BoardSize, player_info(_, _, _, _, Level1), player_info(_, _, _, _, Level2), CurrentPlayer), Level),
    place_final_pieces(4, game_state(Mode, BoardSize, player_info(Id1, Last_move1, Score1, Board1, Level1), player_info(Id2, Last_move2, Score2, Board2, Level2), CurrentPlayer), IntermediateGameState, Last_move1, Level),
    display_game(IntermediateGameState),
    
    write('\nPlayer 2, your 4 final pieces are going to be placed in the remain spaces.\n'),
    place_remain_final_pieces(4, IntermediateGameState, Last_move2, FinalGameState),
    display_game(FinalGameState).

%---------------------------------------------------

%place_final_pieces(+Amount_of_pieces, +GameState, +FinalGameState, +Last_move, +Level)

%Place the final pieces for player 1 when it is a level 0 - human

place_final_pieces(0, GameState, GameState, _Last_move, 0) :- !.
place_final_pieces(N,  GameState, FinalGameState, Last_move, 0):-
    N > 0,
    choose_move(GameState, _, moviment(UserMove, Last_move)),
    move(GameState, moviment(UserMove, Last_move), NewGameState),
    Remain is N - 1,
    display_game(NewGameState),
    place_final_pieces(Remain, NewGameState, FinalGameState, Last_move,0).


%Place the final pieces for player 1 when it is a level 1 or 2 - machine

place_final_pieces(0, GameState, GameState, _Last_move, _Level) :- !.
place_final_pieces(N, GameState, FinalGameState, Last_move, _Level):-
    place_remain_final_pieces(N, GameState, Last_move, FinalGameState).

%---------------------------------------------------

%Place four pieces in the board in random places

%place_final_pieces(+Amount_of_pieces, +GameState, +Last_move, +FinalGameState)

place_remain_final_pieces(0,GameState, _Last_move, GameState) :- !.
place_remain_final_pieces(N, GameState, Last_move, FinalGameState):-
    N > 0,
    valid_moves(GameState, ValidMoves),
    random_select(RandomMove, ValidMoves, _Rest),
    format('Selected Move ~w', [RandomMove]),
    move(GameState,  moviment(RandomMove, Last_move), NewGameState),
    Remain is N - 1,
    place_remain_final_pieces(Remain, NewGameState, Last_move, FinalGameState).
