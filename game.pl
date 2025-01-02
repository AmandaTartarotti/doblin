:- consult(utils).
:- consult(move).
:- consult(configuration).
:- consult(game_aux).

play_game:-
    game_menu(GameConfig),
    initial_state(GameConfig, GameState),
    display_game(GameState),
    game_cycle(GameState).

game_cycle(GameState):-
    game_over(GameState, Winner), !,
    congratulate(Winner).

game_cycle(GameState):-

    define_player(GameState, Player),

    %Iteration X
    choose_move(GameState, Player, moviment(UserMoveX, 'X')), 
    move(GameState, moviment(UserMoveX, 'X'), PartialGameState),
    display_game(PartialGameState),
    
    %Iteration O
    choose_move(PartialGameState, Player, moviment(UserMoveO, 'O')), 
    move(PartialGameState, moviment(UserMoveO, 'O'), FinalGameState),

    next_player(FinalGameState, NewGameState),
    display_game(NewGameState), !,
    game_cycle(NewGameState).

%choose_move Human Level - interaction to select move
choose_move(_GameState, 1, moviment(Move, Symbol)):-
    format('Enter your move for ~w (example: 2B): ', [Symbol]),
    read_line_to_string(Move).
    %format('You entered: ~w~n', [Move]).

%choose_move Computer-Level
choose_move(GameState, 2, moviment(Move, _Symbol)):-
    valid_moves(GameState, ValidMoves),
    get_level(GameState, Level), %retorna o level do current player
    choose_machine_move(Level, GameState, ValidMoves, Move). 

%choose_move_machine Computer Level 1
choose_machine_move(1, _GameState, ValidMoves, Move):-
    random_select(Move, ValidMoves, _Rest),
    format('\nSelected Move ~w\n', [Move]).

choose_move(2, _GameState, _ValidMoves, _Move):-
    write('Under implementation').
    %setof(Value-Mv, NewState^( member(Mv, Moves),
    %move(GameState, Mv, NewState),
    %evaluate_board(NewState, Value) ), [_V-Move|_]).

%valid_moves(GameState, Moves):-
    %findall(Move, move(GameState, Move, NewState), Moves).