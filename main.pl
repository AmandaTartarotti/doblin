:- consult(move).
:- consult(game_config).

play_game:-
    game_menu(GameConfig),
    initial_state(GameConfig, GameState),
    display_game(GameState),
    game_cycle(GameState).

game_cycle(GameState):-
    game_over(GameState, Winner), !,
    congratulate(Winner).

game_cycle(GameState):-
    
    %O predicado original era choose_move(GameState, Player, UserMove), mas ainda so temos o Player HxH entao omiti Player por agora
    choose_move(GameState, moviment(UserMoveX, 'X')), 
    move(GameState, moviment(UserMoveX, 'X'), PartialGameState),
    display_game(PartialGameState),
    
    choose_move(GameState, moviment(UserMoveO, 'O')), 
    move(PartialGameState, moviment(UserMoveO, 'O'), FinalGameState),

    next_player(FinalGameState, NewGameState),

    display_game(NewGameState), !,
    game_cycle(NewGameState).

choose_move(_, moviment(Move, Symbol)):-
    format('Enter your move for ~w (example: 2B): ', [Symbol]),
    read_line_to_string(Move),
    format('You entered: ~w~n', [Move]).

%choose_move(GameState, human, Move):-
    %interaction to select move

%choose_move(GameState, computer-Level, Move):-
    %valid_moves(GameState, ValidMoves),
    %choose_move(Level, GameState, ValidMoves, Move).

%valid_moves(GameState, Moves):-
    %findall(Move, move(GameState, Move, NewState), Moves).

%choose_move(1, _GameState, Moves, Move):-
    %random_select(Move, Moves, _Rest).

%choose_move(2, GameState, Moves, Move):-
    %setof(Value-Mv, NewState^( member(Mv, Moves),
    %move(GameState, Mv, NewState),
    %evaluate_board(NewState, Value) ), [_V-Move|_]).