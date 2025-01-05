%-----------------------------------------------

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

    %evaluate_game_state(game_state(_, _, PlayerInfo1, PlayerInfo2, CurrentPlayer), Value1, Value2),
    %format('Player 1 Value: ~w\nPlayer 2 Value: ~w\n', [Value1, Value2]),
    evaluate_game_state(game_state(_, _, PlayerInfo1, PlayerInfo2, CurrentPlayer), _Perc1, _Perc2),
    %format('Player 1 Perc1: ~w\nPlayer 2 Perc2: ~w\n', [Perc1, Perc2]),

    nl, write('Game Boards:\n'), nl,
    %Imprimir informações dos jogadores
    print_player_info(PlayerInfo1, Width), nl,
    print_player_info(PlayerInfo2, Width), nl.
   
print_player_info(player_info(Player, _, Score, Board,_), Width) :-
    format('Player ~w score: ~w\n', [Player, Score]),
    nl,
    print_player_board(Board, Width).

%print_player_board(board(Numbers, Letters, Cells), Width) :-
%    write('   '), % um espaço adicional so para formatar bonitin c:
%    format('~w', [Numbers]), nl,  % Print each row
%    print_board_rows(Letters, Cells, Width).

%print_board_rows([], [], _).
%print_board_rows([Letter|Tail], [CellHead|CellTail], Width) :-
%    format('~w  ~w\n', [Letter, CellHead]),
%    print_board_rows(Tail, CellTail, Width).

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

%Define level

%return player level
get_level(game_state(_, _, player_info( _, _, _, _, Level), _, 1), Level).
get_level(game_state(_, _, player_info( _, _, _, _, Level), _, 2), Level).

%-----------------------------------------------

%Next Player

next_player(
    game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, CurrentPlayer), 
    game_state(Mode, board_size(Width, Height), PlayerInfo1, PlayerInfo2, NextPlayer)
):-
    NextPlayer is (3 - CurrentPlayer).

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

handle_percentages(_, _, 0, 0, 0) :- % se TotalValue é zero, a percentagem fica a 0
    write('---------------------------------------'),nl,
    write('Player 1 advantage percentage: 0%\n'),
    write('Player 2 advantage percentage: 0%\n'), 
    write('---------------------------------------'),nl,nl.

handle_percentages(Value1, Value2, TotalValue, Perc1, Perc2) :-
    %Perc1 is (Value1 / TotalValue) * 100,
    %Perc2 is (Value2 / TotalValue) * 100, nl,
    %format('Player 1 Percentage em ganhar: 2f%\n', [Perc1]),
    %format('Player 2 Percentage em ganhar: ~2f%\n', [Perc2]).
    Perc1 is round((Value1 / TotalValue) * 100),
    Perc2 is round((Value2 / TotalValue) * 100),
    write('-------------------------------------------------'),nl,
    format('Player 1 advantage percentage: ~w%\n', [Perc1]),
    format('Player 2 advantage percentage: ~w%\n', [Perc2]) ,
    write('-------------------------------------------------'),nl,nl.

    %Perc1 is (Value1 / TotalValue) * 100,
    %Perc1 is (Value2 / TotalValue) * 100,

    %format('Player 1 Percentage: ~2f%\n', [Perc1]),
    %format('Player 2 Percentage: ~2f%\n', [Perc2]),
    %write('SAI DO evaluate_game_state'), nl.

%value(+GameState, +Player, -Value).
%value do Player1
%value(game_state(_, _, _, player_info(_, _, OpponentScore2, OpponentBoard2,_), _), 1, Value1) :-
value(game_state(_, _, _, player_info(_Player2, _, OpponentScore2, _OpponentBoard2,_), _), 1, Value1) :-
    %format('OpponentScore2: ~w\n', [OpponentScore2]),
    %format('Player2 score: ~w\n', [OpponentScore2]),
    %write('ENTREI NO VALUE1 '), nl,
    % combinações possíveis (linhas com 3 elementos consecutivos ou quadrado quase completo com uma elemento em falta)
    %count_possible_combinations(OpponentBoard2, PotentialCombinations),
    %write('SAI DO count_possible_combinations '),nl,
    %format('OpponentScore2: ~w, PotentialCombinations: ~w\n', [OpponentScore2, PotentialCombinations]),
    % calculo do value
    
    Value1 is OpponentScore2. %+ 0.5 * PotentialCombinations.

%value do Player2
value(game_state(_, _, player_info(_, _, OpponentScore1, _OpponentBoard1,_), _, _), 2, Value2) :-
    %format('Player1 score: ~w\n', [OpponentScore1]),
    %write('ENTREI NO VALUE2: '),nl,
    % combinações possíveis (linhas com 3 elementos consecutivos ou quadrado quase completo com uma elemento em falta)
    %count_possible_combinations(OpponentBoard1, PotentialCombinations),
    %format('OpponentScore1: ~w, PotentialCombinations: ~w\n', [OpponentScore1, PotentialCombinations]),
    % calculo do value
    Value2 is OpponentScore1. %+ 0.5 * PotentialCombinations.


%------------------------------
% find_possible_combinations(+Board, -Count)
count_possible_combinations(board(_, _, Cells), Count) :-
    % Count potential rows
    %write('ENTREI NO count_possible_combinations: '),nl,

    %linhas
    potential_lines(Cells, RowCount),
    %write('SAI DO potential_lines: '),nl,
    format('Potential horizontal lines: ~w\nResulting RowCount: ~w\n', [Cells, RowCount]), nl,

    %colunas
    transpose(Cells, Ts),
    potential_lines(Ts,ColCount),
    format('Potential vertical lines: ~w\nResulting ColCount: ~w\n', [Cells, ColCount]), nl,
    
    % potential diagonals
    %potential_diagonals(Board, DiagonalCount),

    % potential squares
    %potential_squares(Board, SquareCount),


    %Count is RowCount + ColCount + DiagonalCount + SquareCount.
    %Count is DiagonalCount + SquareCount.
    %Count is SquareCount.

    
    Count is RowCount + ColCount.
    %Count is RowCount.
    %Count is ColCount.

%---------------------------------------------
%pensei em fazer doutra forma onde nao retira totalmente o conjunto que ja foi contado, mas iria contar repetido, por exemplo xxx_xxx iria contar como 2
% potential_lines(+Board, -Count)
potential_lines([], 0).
potential_lines([Line | Rest], Total) :-
    potential_line(Line, LineCount),
    potential_lines(Rest, RestTotal),
    Total is LineCount + RestTotal.

% potential_line(+Line, -Count)
potential_line([], 0).
%potential_line([], 0) :-
%    write('-> Linha vazia, retornando 0.\n').

%estes foram casos mais especificos, onde há sobreposição e preciso de ter em conta o conjunto já contado anteoriormente, mas a sobrpeosição é de 1 ou 2 elementos
% x_xx_x resultado de sobreposição de 2 elem x_xx e xx_x
potential_line([A, -, A, A, -, A| Rest], 2) :-
    %write('-> Detectado padrão x_xx_x\n'),
    A \= '-', 
    %!, %CUT VERDE, os cuts que meti foram para nao tar a ver mais o resto da linha visto que nestes casos iriam sobrar apenas 3 elem no max o que nao iria ser possivel haver combinações possíveis
    write('-> Contado padrão x_xx_x: +2 pontos\n'),
    potential_line(Rest, 0). 
% xx_x_xx resultado de sobreposição de 1 elem xx_x e x_xx
potential_line([A, A, -, A, -, A, A| Rest], 2) :-
    %write('-> Detectado padrão xx_x_xx\n'),
    A \= '-', 
    %!,
    write('-> Contado padrão xx_x_xx: +2 pontos\n'),
    potential_line(Rest, 0). 

%primeiro convem checkar os casos maiores e com possiveis combinações dos dois lados 
% caso com points nos dois lados, tamanho 8
%estes caso funcionava sem este pois nao há sobreposição, podem ser contados separadamente
potential_line([-, A, A, A, A, A, A, - | Rest], 2) :-
    %write('-> Detectado padrão -AAAAAA-\n'),
    A \= '-', 
    %!,
    write('-> Contado padrão -AAAAAA-: +2 pontos\n'),
    potential_line(Rest, 0). 


% caso com points nos dois lados, tamanho 7
potential_line([-, A, A, A, A, A, - | Rest], 2) :-
    %write('-> Detectado padrão -AAAAA-\n'),
    A \= '-', 
    %!,
    write('-> Contado padrão -AAAAA-: +2 pontos\n'),
    potential_line(Rest, 0). 

% caso com points nos dois lados, tamanho 6
potential_line([-, A, A, A, A, - | Rest], 2) :-
    %write('-> Detectado padrão -AAAA-\n'),
    A \= '-', 
    %!,
    write('-> Contado padrão -AAAA-: +2 pontos\n'),
    potential_line(Rest, 0). 

% caso com points nos dois lados, tamanho 5
potential_line([-, A, A, A, - | Rest], 2) :-
    %write('-> Detectado padrão -AAA-\n'),
    A \= '-', 
    %!,
    write('-> Contado padrão -AAA-: +2 pontos\n'),
    potential_line(Rest, 0). 

%agora os casos só com apenas de um lado
% caso 1
potential_line([A, A, A, '-' | Rest], 1) :- 
    %write('-> Detectado padrão AAA-\n'),
    A \= '-', 
    write('-> Contado padrão AAA-: +1 ponto\n'),                               
    potential_line(Rest, 0).

% caso 2
potential_line(['-', A, A, A | Rest], 1) :-
    %write('-> Detectado padrão -AAA\n'),
    A \= '-', 
    write('-> Contado padrão -AAA: +1 ponto\n'),                              
    potential_line(Rest, 0).

% caso 3
potential_line([A, A, '-', A | Rest], 1) :-
    %write('-> Detectado padrão AA-A\n'),
    A \= '-',
    write('-> Contado padrão AA-A: +1 ponto\n'),
    potential_line(Rest, 0).

% caso 4
potential_line([A,'-', A, A | Rest], 1) :-
    %write('-> Detectado padrão A-AA\n'),
    A \= '-',
    write('-> Contado padrão A-AA: +1 ponto\n'),
    potential_line(Rest, 0).

potential_line([_ | Rest], Count) :-
    %write('-> Nenhum padrão encontrado, passando para o próximo elemento.\n'),
    potential_line(Rest, Count).
%tava a pensar se faria sentido no caso: -xxx nao passar xxx todo
%mas por agora vou deixar passar
%por isso tmb meti o caso de verificar -xxx- logo no inicio de todos
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