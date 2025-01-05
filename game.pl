:- consult(utils).
:- consult(move).
:- consult(configuration).
:- consult(game_aux).
:- consult(game_over).

play:-
    game_menu(GameConfig),
    initial_state(GameConfig, GameState),
    display_game(GameState),
    game_cycle(GameState).

game_cycle(GameState):-
    game_over(GameState, Winner), !,
    congratulate(Winner).

game_cycle(GameState):-

    get_level(GameState, Player_Level), %retorna o level do current player

    %Iteration X
    choose_move(GameState, Player_Level, moviment(UserMoveX, 'X')), 
    move(GameState, moviment(UserMoveX, 'X'), PartialGameState),
    display_game(PartialGameState),
    
    %Iteration O
    choose_move(PartialGameState, Player_Level, moviment(UserMoveO, 'O')), 
    move(PartialGameState, moviment(UserMoveO, 'O'), FinalGameState),

    next_player(FinalGameState, NewGameState),
    display_game(NewGameState), !,
    game_cycle(NewGameState).

%choose_move Human - interaction to select move
choose_move(_GameState, 0, moviment(Move, Symbol)):-
    format('Enter your move for ~w (example: 2B): ', [Symbol]),
    read_line_to_string(Move).
    %format('You entered: ~w~n', [Move]).

%choose_move Computer-Level
choose_move(GameState, Computer_Level, moviment(Move, Symbol)):-
    valid_moves(GameState, ValidMoves),
    choose_machine_move(Computer_Level, GameState, ValidMoves, moviment(Move, Symbol)). 

%choose_move_machine Computer Level 1
choose_machine_move(1, _GameState, ValidMoves, moviment(Move, _Symbol)):-
    random_select(Move, ValidMoves, _Rest),
    format('\nRandom move chosen: ~w\n', [Move]).

choose_machine_move(2, GameState, ValidMoves, moviment(BestMove, Symbol)):-
    %com cada valid moves, ver os boards possiveis e guardar o points, daí escolher o move que gerou o board com mais value
    %quero ter  uma lista de estrutura Value-move, onde testei cada move dentro dos ValidMoves, para cada move obtive um novo estado, o NewState e dps avaliei esse NewState, obtendo um Value em percentagem,o que tiver maior percentagem melhor jogo tem, colocamos isso dentro da lista chamada SortedMoves
  findall(Value-Mv, NewState^(
        member(Mv, ValidMoves), %aqui fui ver os moves que eram validMoves
        move(GameState, moviment(Mv, Symbol), NewState), %para cada move foi criado um NewState
        evaluate_game_state(NewState, Perc1, Perc2), %para ter acesso às Perc1 e Perc2
        current_player_value(Perc1, Perc2, NewState, Value) %para dar o value do jogador especifico
    ),AllMoves),
    
    keysort(AllMoves, SortedMoves), 
    last(SortedMoves, _-BestMove),
    format('<  Best move chosen: ~w  >', [BestMove]).


current_player_value(Perc1, _Perc2, game_state(_, _, _, _, 1), Perc1).
current_player_value(_Perc1, Perc2, game_state(_, _, _, _, 2), Perc2).


