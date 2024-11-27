# Doblin

> Functional and Logic Programming - TP2

**Identification**
* 3LEIC12 - group X
* Students:
    - Amanda Tartarotti Cardozo da Silva up202211647 
    - Tatiana Wang Lin up202206371

 # Overview

Doblin is a strategic game played on two interconnected grids. The objective is to carefully fill each grid with symbols (O's and X's) while avoiding specific patterns that result in penalties. The objective is to fill each grid with O's and X's such that neither grid contains:
* A line (horizontal, vertical, or diagonal) of four consecutive identical symbols (O or X).
* A 2x2 square of identical symbols (O or X).

**Be strategic**: The two grids are interconnected. Placing a symbol in one grid will automatically place the same symbol in a corresponding position in the second grid. This creates a dynamic interplay between the grids, forcing players to consider the effects of each move on both. Players take turns placing symbols, aiming to minimize penalties in their own grid while potentially causing penalties in their opponent's grid.

# Game Flow

**Initial Setup:** Two identical grids are prepared, each with the same size.

**Taking Turns:** A player places a symbol (O or X) in an available cell in their grid. The corresponding cell in the oponent grid is automatically filled with the same symbol.

**Checking for Patterns:** After each move, both grids are checked to identity any pattern of four identical symbols.

**Penalties:** each restricted pattern in a grid incurs a penalty for the player.

**Game End:** the game ends when all cells are filled and the player with the fewest penalties is declared the winner.



> Reference: https://boardgamegeek.com/boardgame/308153/doblin
