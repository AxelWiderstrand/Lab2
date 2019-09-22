module Blackjack where

import Cards
import RunGame

--A1
--All steps it takes 
hand2 :: Hand
hand2 = (Card (Numeric 2) Hearts : (Card Jack Spades : []))

sizeSteps :: [Int]
sizeSteps = [ size hand2, size (Card (Numeric 2) Hearts : (Card Jack Spades : [])), 1 + size (Card Jack Spades : []), 1 + 1 + size [], 1 + 1, 2]

--Defining diffrent cards for testing
aCard1 :: Card
aCard1 = (Card (Numeric 5) Spades)

aCard2 :: Card
aCard2 = (Card (King) Hearts)

aCard3 :: Card
aCard3 = (Card( Ace) Clubs)

--Defining diffrent hands for testing
aHand :: Hand
aHand = [aCard1, aCard2]

aHand2 :: Hand
aHand2 = [aCard1, aCard2, aCard3]

--A2
--Displays the cards in a hand
display :: Hand -> String
display []    = ""
display (c:h) = (displayCard c) ++ ", " ++ (display h)

--Shows the card i a nice format
displayCard :: Card -> String
displayCard (Card (Numeric n) s) = show n ++ " of " ++ show s
displayCard (Card r s)           = show r ++ " of " ++ show s

--A3
--Calculates the value of the hand
value :: Hand -> Int
value h | (valueAce h) > 21 = (valueAce h) - 10*(numberOfAces h)
        | otherwise         = valueAce h

--Calculates the value of a rank
valueRank :: Rank -> Int
valueRank (Numeric n) = n
valueRank Ace         = 11
valueRank _           = 10

--Calculates the value of a hand where Ace = 11
valueAce :: Hand -> Int
valueAce [] = 0
valueAce (c:h) = (valueCard c) + (valueAce h)

--Calculates the value of a card
valueCard :: Card -> Int
valueCard (Card r s) = (valueRank r)

-- A function calculating the number of Aces in a hand
numberOfAces :: Hand -> Int
numberOfAces [] = 0
numberOfAces ((Card r s): h) | r==Ace    = 1 + (numberOfAces h)
                             | otherwise = (numberOfAces h)

--A4
--Checks if a hand has a value over 21 "GameOver"
gameOver :: Hand -> Bool
gameOver h | (value h) <=21 = False
           | otherwise     = True


--Here we check wich player wins
--We have given Player our example Hand aHand and the Bank aHand2
winner :: Hand -> Hand -> Player
winner aHand aHand2
                   | gameOver (aHand)  == True      = Bank
                   | gameOver (aHand2) == True      = Guest
                   | value (aHand) > value (aHand2) = Guest
                   | value (aHand) < value (aHand2) = Bank
                   | otherwise                      = Bank

--B1
--Lists all ranks
allRank :: [Rank]
allRank = [Numeric n | n <- [2..10]] ++ [Jack, Queen, King, Ace]

--Lists all suits
allSuit :: [Suit]
allSuit = [Hearts, Diamonds, Clubs, Spades]

--Shows a full deck of cards
fullDeck :: Deck
fullDeck = [Card r s | r <- allRank, s <- allSuit]

--Checks if the deck has 52 cards
prop_size_fullDeck :: Bool
prop_size_fullDeck = size fullDeck == 52

--B2
--Draws a card from the deck and puts it the hand 
draw :: Deck -> Hand -> (Deck, Hand)
draw [] hand = error "draw: The deck is empty."
draw (c:deck) hand = (deck, c:hand)

--B3
--A function putting cards in bankHand from a deck until the value of the hand is >= 16
playBank :: Deck -> Hand
playBank deck = playBank' deck []

playBank' :: Deck -> Hand -> Hand
playBank' deck bankHand | (value bankHand) >= 16 = bankHand

playBank' deck bankHand    = playBank' deck' bankHand'
  where (deck', bankHand') = draw deck bankHand

--B4
--Creates a random number between 0 and 52
randomNumber :: Double -> Deck -> Int
randomNumber r deck = floor (r * (size deck))

--Removes a specifik card
removeCard :: Int -> Deck -> Deck
removeCard n deck = take n deck ++ drop (n+1) deck

--Chooses a specifik card
chooseCard :: Int -> Deck -> Card
chooseCard n deck = deck!!n

--Shuffles the deck
shuffle :: [Double] -> Deck -> Deck
shuffle _ [] = []
shuffle (r:rs) deck = ((chooseCard i deck):( shuffle rs newDeck))
    where i = (randomNumber r deck)
          newDeck = (removeCard i deck)

--B5
belongsTo :: Card -> Deck -> Bool
c `belongsTo` []      = False
c `belongsTo` (c':cs) = c == c' || c `belongsTo` cs

prop_shuffle :: Card -> Deck -> Rand -> Bool
prop_shuffle card deck (Rand randomlist) =
    card `belongsTo` deck == card `belongsTo` shuffle randomlist deck

prop_size_shuffle :: Rand -> Deck -> Bool
prop_size_shuffle (Rand randomlist) deck = size (shuffle randomlist deck) == 52

--B6
implementation = Interface
  {  iFullDeck  = fullDeck
  ,  iValue     = value
  ,  iDisplay   = display
  ,  iGameOver  = gameOver
  ,  iWinner    = winner
  ,  iDraw      = draw
  ,  iPlayBank  = playBank
  ,  iShuffle   = shuffle
  }

main :: IO ()
main = runGame implementation
