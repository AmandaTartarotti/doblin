# Doblin

> Functional and Logic Programming - TP2

**Identification**
* 3LEIC12 - group X
* Students:
    - Amanda Tartarotti Cardozo da Silva up202211647 
    - Tatiana Wang Lin up202206371

# Installation and Execution

**1.1 Prerequisites**

Before running the game, ensure the following software is installed on your system:
* SICStus Prolog 4.9 (mandatory for executing the Prolog code).
> If not already installed, follow the official installation guide: [SICStus Prolog Download]([url](https://sicstus.sics.se/download4.html))
* Text Editor or IDE (e.g., Visual Studio Code with the Prolog extension).

**1.2 Game Execution**

Follow the steps below to execute the game correctly:

* Open the SICStus application
* Load the main game file (game.pl):
* To start the game, run:
    * ?- play.

It is also possible to launch SICStus in your terminal, following the steps:

* Open your terminal (or Command Prompt on Windows)
* Launch SICStus Prolog by typing:
     * /usr/local/sicstus4.9.0/bin/sicstus
* Load the main game file (for example, game.pl):
    * ?- consult('game.pl').
* To start the game, run:
    * ?- play.

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
