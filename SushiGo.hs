import Data.List
import Data.Ord
import System.Random
import Debug.Trace

randomSeed = mkStdGen 123
initalCardCount = 10
searchDepth = 5

data GameState = GameState {
    playerHand :: [String],
    playerTable :: [String],
    opponentHand :: [String],
    opponentTable :: [String]
} deriving (Eq, Ord, Show)

data Move = Move {
    cardIndex :: Int,
    chopsticksExtraCardIndex :: Int
} deriving (Eq, Ord, Show)

cardIndexToMove :: Int -> Move
cardIndexToMove index =
    Move {
        cardIndex = index,
        chopsticksExtraCardIndex = -1
    }

cardIndexesToMove :: (Int, Int) -> Move
cardIndexesToMove (index1, index2) =
    Move {
        cardIndex = index1,
        chopsticksExtraCardIndex = index2
    }


main = do
    let cardNames = ["Tempura", "Sashimi", "Dumpling", "SingleMaki", "DoubleMaki", "TripleMaki", "SalmonNigiri", "SquidNigiri", "EggNigiri", "Wasabi", "Chopsticks"]
    let cardCounts = [14, 14, 14, 12, 8, 6, 10, 5, 5, 6, 4]
    let cards = concat (zipWith replicate cardCounts cardNames)
    let deck = (\(x, _) -> x) (shuffle cards randomSeed)

    let playerHand = take initalCardCount deck
    let opponentHand = take initalCardCount (drop initalCardCount deck)

    let gameState = GameState { 
        playerHand = playerHand,
        playerTable = [],
        opponentHand = opponentHand,
        opponentTable = []
    }
    gameLoop gameState


shuffle :: RandomGen g => [a] -> g -> ([a], g)
shuffle [] g0 = ([], g0)
shuffle [x] g0 = ([x], g0)
shuffle xs g0 = (x:newtail, g2) where 
    (i, g1) = randomR (0, length $ tail xs) g0
    (xs1, x:xs2) = splitAt i xs
    (newtail, g2) = shuffle (xs1 ++ xs2) g1


gameLoop gameState = do
    putStr "Player Hand: "
    print (playerHand gameState)
    putStr "Player Table: "
    print (playerTable gameState)
    putStr "Opponent Hand: "
    print (opponentHand gameState)
    putStr "Opponent Table: "
    print (opponentTable gameState)

    if (length (playerHand gameState)) == 0 then do
        putStr "Player Score: "
        print (evaluateTable (playerTable gameState))
        putStr "Opponent Score: "
        print (evaluateTable (opponentTable gameState))
        return ()
    else do
        input <- getLine
        if isInfixOf "," input then do
            let hasChopsticks = length (filter (=="Chopsticks") (playerTable gameState)) > 0
            let moves = splitString (==',') input
            let move1 = (read (moves !! 0) :: Int)
            let move2 = if hasChopsticks then (read (moves !! 1) :: Int) else -1
            let playerMove = cardIndexesToMove (move1, move2)
            let aiMove = minimax searchDepth gameState
            let newGameState = play gameState playerMove aiMove
            gameLoop newGameState
        else do
            let playerMove = cardIndexToMove (read input :: Int)
            let aiMove = minimax searchDepth gameState
            print aiMove
            let newGameState = play gameState playerMove aiMove
            gameLoop newGameState


splitString :: (Char -> Bool) -> String -> [String]
splitString p s = case dropWhile p s of
    "" -> []
    s' -> w : splitString p s''
        where (w, s'') = break p s'


play :: GameState -> Move -> Move -> GameState
play gameState player opponent = 
    swapHands (playerMove (opponentMove gameState opponent) player)

doMove :: ([String], [String]) -> Move -> ([String], [String])
doMove (hand, table) move =
    let applyMove :: ([String], [String]) -> String -> ([String], [String])
        applyMove (hand, table) card = 
            let newHand = delete card hand
                hasWasabi = (length (filter (=="Wasabi") table)) > 0
                isNigiri = isInfixOf "Nigiri" card
                newCard = if hasWasabi && isNigiri then card ++ "Wasabi" else card
                newTable = if hasWasabi && isNigiri then delete "Wasabi" (table ++ [newCard]) else table ++ [newCard]
            in (newHand, newTable)
        usingChopsticks = (chopsticksExtraCardIndex move) /= -1
        card1 = hand !! (cardIndex move)
        card2 = if usingChopsticks then hand !! (chopsticksExtraCardIndex move) else []
        afterMove1 = applyMove (hand, table) card1
        afterMove2 = if not usingChopsticks then afterMove1 else applyMove afterMove1 card2
        newHand = if usingChopsticks then (fst afterMove2) ++ ["Chopsticks"] else (fst afterMove2)
        newTable = if usingChopsticks then delete "Chopsticks" (snd afterMove2) else (snd afterMove2)
    in (newHand, newTable)

playerMove :: GameState -> Move -> GameState
playerMove gameState move = 
    let afterMove = doMove ((playerHand gameState), (playerTable gameState)) move
    in GameState {
        playerHand = (fst afterMove),
        playerTable = (snd afterMove),
        opponentHand = (opponentHand gameState),
        opponentTable = (opponentTable gameState)
    }

opponentMove :: GameState -> Move -> GameState
opponentMove gameState move = 
    let afterMove = doMove ((opponentHand gameState), (opponentTable gameState)) move
    in GameState {
        playerHand = (playerHand gameState),
        playerTable = (playerTable gameState),
        opponentHand = (fst afterMove),
        opponentTable = (snd afterMove)
    }

swapHands :: GameState -> GameState
swapHands gameState =
    GameState {
        playerHand = (opponentHand gameState),
        playerTable = (playerTable gameState),
        opponentHand = (playerHand gameState),
        opponentTable = (opponentTable gameState)
    }

   
evaluateTable :: [String] -> Int
evaluateTable cards = 
    let tempura = (countInList "Tempura" cards) `div` 2 * 5
        sashimi = (countInList "Sashimi" cards) `div` 3 * 10
        dumplings = (countInList "Dumpling" cards) * ((countInList "Dumpling" cards) + 1) `div` 2
        eggNigiri = (countInList "EggNigiri" cards)
        salmonNigiri = (countInList "SalmonNigiri" cards) * 2
        squidNigiri = (countInList "SquidNigiri" cards) * 3
        eggNigiriWasabi = (countInList "EggNigiriWasabi" cards) * 3
        salmonNigiriWasabi = (countInList "SalmonNigiriWasabi" cards) * 6
        squidNigiriWasabi = (countInList "SquidNigiriWasabi" cards) * 9
    in  tempura + sashimi + dumplings + eggNigiri + salmonNigiri + squidNigiri + eggNigiriWasabi + salmonNigiriWasabi + squidNigiriWasabi

makiCount :: [String] -> Int
makiCount cards =
    let singleMaki = (countInList "SingleMaki" cards)
        doubleMaki = (countInList "DoubleMaki" cards)
        tripleMaki = (countInList "TripleMaki" cards)
    in  singleMaki + doubleMaki * 2 + tripleMaki * 3

evaluateScore :: GameState -> Int
evaluateScore gameState =
    let playerMakiCount = makiCount (playerTable gameState)
        opponentMakiCount = makiCount (opponentTable gameState)
        playerMakiScore = if playerMakiCount > 0 then if playerMakiCount > opponentMakiCount then 6 else 3 else 0
        opponentMakiScore = if opponentMakiCount > 0 then if opponentMakiCount > playerMakiCount then 6 else 3 else 0
    in  (evaluateTable (playerTable gameState)) + playerMakiScore - (evaluateTable (opponentTable gameState)) - opponentMakiScore

countInList :: String -> [String] -> Int
countInList find list = length (filter (==find) list)


getPossibleMoves :: ([String], [String]) -> [Move]
getPossibleMoves (hand, table) = 
    let numCards = length hand
        cardIndexes = [0..(numCards - 1)]
        standardMoves = map cardIndexToMove cardIndexes
        hasChopsticks = (length (filter (=="Chopsticks") table) > 0)
        chopsticksCombos = filter (\(x,y) -> x /= y) (nubBy moveEq [(x,y) | x<-cardIndexes, y<-cardIndexes])
        chopsticksMoves = map cardIndexesToMove chopsticksCombos
    in if hasChopsticks then standardMoves ++ chopsticksMoves else standardMoves

moveEq :: Eq a => (a,a) -> (a,a) -> Bool
moveEq (x,y) (u,v) = (x == u && y == v) || (x == v && y == u)

greedy :: GameState -> Move
greedy gameState = 
    let moves = getPossibleMoves ((opponentHand gameState), (opponentTable gameState))
        newStates = map (opponentMove gameState) moves
        scores = map evaluateScore newStates
    in Move {
        cardIndex = minIndex scores,
        chopsticksExtraCardIndex = -1
    }

minimax :: Int -> GameState -> Move
minimax depth gameState =
    let moves = getPossibleMoves ((opponentHand gameState), (opponentTable gameState))
        newStates = map (opponentMove gameState) moves
        scores = (map (maximize (depth - 1)) newStates)
    in moves !! (minIndex scores)

maximize :: Int -> GameState -> Int
maximize depth gameState =
    if depth == 0 || length (playerHand gameState) == 0 then
        evaluateScore gameState
    else
        let moves = getPossibleMoves ((playerHand gameState), (playerTable gameState))
            newStates = map swapHands (map (playerMove gameState) moves)
            scores = map (minimize (depth - 1)) newStates
        in maximum scores

minimize :: Int -> GameState -> Int
minimize depth gameState =
    if depth == 0 || length (opponentHand gameState) == 0 then
        evaluateScore gameState
    else
        let moves = getPossibleMoves ((opponentHand gameState), (opponentTable gameState))
            newStates = map (opponentMove gameState) moves
            scores = map (maximize (depth - 1)) newStates
        in minimum scores


minIndex :: (Ord a) => [a] -> Int
minIndex l = 
    let pmin :: (Ord a) => [a] -> Int -> (a, Int)
        pmin [x] xi = (x, xi)
        pmin (x:xs) xi 
            | x < t     = (x, xi)
            | otherwise = (t, ti)
            where (t, ti) = pmin xs (xi + 1)
    in snd (pmin l 0)    
