# sushigo
Command line SushiGo card game played against an AI using a minimax algorithm. The rules for the card game may be found [here.](https://www.gamewright.com/gamewright/pdfs/Rules/SushiGoTM-RULES.pdf)

## Setup
### Dependencies
This program requires the use of System.Random, you may need to install it before being able to compile:
```
cabal install random
```
### Compile & Run
```
ghc -o SushiGo SushiGo.hs && ./SushiGo
```

## Usage
Each turn, the contents of the players hands and the cards that have been played on the table are output. Enter the card you wish to play as an index describing its offset in the list of cards in your hand. I.e. on your first turn you must enter a number in the range [0, 9].

If you have a Chopsticks card on your table, you may use two cards instead of one in exchange for the Chopsticks card. Enter the indexes of both cards to play delimited by a comma. E.g. "2,5".

### Example Game
```
Player Hand: ["SalmonNigiri","Wasabi","SquidNigiri","DoubleMaki","DoubleMaki","SingleMaki","TripleMaki","EggNigiri","Dumpling","SalmonNigiri"]
Player Table: []
Opponent Hand: ["Wasabi","Wasabi","SalmonNigiri","Tempura","SalmonNigiri","SalmonNigiri","Chopsticks","Dumpling","Tempura","Sashimi"]
Opponent Table: []
1
Player Hand: ["Wasabi","Wasabi","SalmonNigiri","Tempura","SalmonNigiri","SalmonNigiri","Dumpling","Tempura","Sashimi"]
Player Table: ["Wasabi"]
Opponent Hand: ["SalmonNigiri","SquidNigiri","DoubleMaki","DoubleMaki","SingleMaki","TripleMaki","EggNigiri","Dumpling","SalmonNigiri"]
Opponent Table: ["Chopsticks"]
0
Player Hand: ["SalmonNigiri","DoubleMaki","DoubleMaki","SingleMaki","EggNigiri","Dumpling","SalmonNigiri","Chopsticks"]
Player Table: ["Wasabi","Wasabi"]
Opponent Hand: ["Wasabi","SalmonNigiri","Tempura","SalmonNigiri","SalmonNigiri","Dumpling","Tempura","Sashimi"]
Opponent Table: ["SquidNigiri","TripleMaki"]
7
Player Hand: ["SalmonNigiri","Tempura","SalmonNigiri","SalmonNigiri","Dumpling","Tempura","Sashimi"]
Player Table: ["Wasabi","Wasabi","Chopsticks"]
Opponent Hand: ["SalmonNigiri","DoubleMaki","DoubleMaki","SingleMaki","EggNigiri","Dumpling","SalmonNigiri"]
Opponent Table: ["SquidNigiri","TripleMaki","Wasabi"]
0,2
Player Hand: ["DoubleMaki","DoubleMaki","SingleMaki","EggNigiri","Dumpling","SalmonNigiri"]
Player Table: ["SalmonNigiriWasabi","SalmonNigiriWasabi"]
Opponent Hand: ["Tempura","SalmonNigiri","Dumpling","Tempura","Sashimi","Chopsticks"]
Opponent Table: ["SquidNigiri","TripleMaki","SalmonNigiriWasabi"]
4
Player Hand: ["Tempura","SalmonNigiri","Dumpling","Tempura","Sashimi"]
Player Table: ["SalmonNigiriWasabi","SalmonNigiriWasabi","Dumpling"]
Opponent Hand: ["DoubleMaki","DoubleMaki","SingleMaki","EggNigiri","SalmonNigiri"]
Opponent Table: ["SquidNigiri","TripleMaki","SalmonNigiriWasabi","Chopsticks"]
2
Player Hand: ["DoubleMaki","DoubleMaki","SingleMaki","EggNigiri"]
Player Table: ["SalmonNigiriWasabi","SalmonNigiriWasabi","Dumpling","Dumpling"]
Opponent Hand: ["Tempura","SalmonNigiri","Tempura","Sashimi"]
Opponent Table: ["SquidNigiri","TripleMaki","SalmonNigiriWasabi","Chopsticks","SalmonNigiri"]
3
Player Hand: ["SalmonNigiri","Sashimi","Chopsticks"]
Player Table: ["SalmonNigiriWasabi","SalmonNigiriWasabi","Dumpling","Dumpling","EggNigiri"]
Opponent Hand: ["DoubleMaki","DoubleMaki","SingleMaki"]
Opponent Table: ["SquidNigiri","TripleMaki","SalmonNigiriWasabi","SalmonNigiri","Tempura","Tempura"]
0
Player Hand: ["DoubleMaki","DoubleMaki"]
Player Table: ["SalmonNigiriWasabi","SalmonNigiriWasabi","Dumpling","Dumpling","EggNigiri","SalmonNigiri"]
Opponent Hand: ["Sashimi","Chopsticks"]
Opponent Table: ["SquidNigiri","TripleMaki","SalmonNigiriWasabi","SalmonNigiri","Tempura","Tempura","SingleMaki"]
0
Player Hand: ["Sashimi"]
Player Table: ["SalmonNigiriWasabi","SalmonNigiriWasabi","Dumpling","Dumpling","EggNigiri","SalmonNigiri","DoubleMaki"]
Opponent Hand: ["DoubleMaki"]
Opponent Table: ["SquidNigiri","TripleMaki","SalmonNigiriWasabi","SalmonNigiri","Tempura","Tempura","SingleMaki","Chopsticks"]
0
Player Hand: []
Player Table: ["SalmonNigiriWasabi","SalmonNigiriWasabi","Dumpling","Dumpling","EggNigiri","SalmonNigiri","DoubleMaki","Sashimi"]
Opponent Hand: []
Opponent Table: ["SquidNigiri","TripleMaki","SalmonNigiriWasabi","SalmonNigiri","Tempura","Tempura","SingleMaki","Chopsticks","DoubleMaki"]
Player Score: 18
Opponent Score: 16
```

## Parameters
At the top of the source code file there are two parameters to adjust:
- randomSeed: the same cards will always be delt unless the seed is changed
- searchDepth: how many iterations the AI performs when deciding on the best move option

## Limitations
- Only supports two players, human vs. AI
- Only one round of the game (it's supposed to have three rounds), with no pudding cards included
- The first move is made with full knowledge of all cards in both players hands
- Plain and simple minimax, no alpha-beta pruning or iterative search deepening etc.
