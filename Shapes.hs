-- | Types and functions for shapes. The list of all tetris pieces.
module Shapes where
import Data.List(transpose)
import Data.Maybe(isNothing)
import Test.QuickCheck

-- * Shapes

type Square = Maybe Colour

data Colour = Black | Red | Green | Yellow | Blue | Purple | Cyan | Grey
              deriving (Eq,Bounded,Enum,Show)

-- | A geometric shape is represented as a list of lists of squares. Each square
-- can be empty or filled with a block of a specific colour.

data Shape = S [Row] deriving (Eq)
type Row = [Square]

rows :: Shape -> [Row]
rows (S rs) = rs

-- * Showing shapes

showShape :: Shape -> String
showShape s = unlines [showRow r | r <- rows s]
  where
    showRow :: Row -> String
    showRow r = [showSquare s | s <- r]
    
    showSquare Nothing = '.'
    showSquare (Just Black) = '#' -- can change to '█' on linux/mac
    showSquare (Just Grey)  = 'g' -- can change to '▓'
    showSquare (Just c)     = head (show c)

instance Show Shape where
  show = showShape
  showList ss r = unlines (map show ss)++r


-- * The shapes used in the Tetris game

-- | All 7 tetrominoes (all combinations of connected 4 blocks),
-- see <https://en.wikipedia.org/wiki/Tetromino>
allShapes :: [Shape]
allShapes = [S (makeSquares s) | s <- shapes] 
   where
      makeSquares = map (map colour)
      colour c    = lookup c [('I',Red),('J',Grey),('T',Blue),('O',Yellow),
                              ('Z',Cyan),('L',Green),('S',Purple)]
      shapes = 
              [["I",
               "I",
               "I",
               "I"],
              [" J",
               " J",
               "JJ"],
              [" T",
               "TT",
               " T"],
              ["OO",
               "OO"],
              [" Z",
               "ZZ",
               "Z "],
              ["LL",
               " L",
               " L"],
              ["S ",
               "SS",
               " S"]]

-- * Some simple functions

-- ** A01
emptyShape :: (Int,Int) -> Shape
emptyShape (n,r) = S (replicate n (emptyList r))

emptyList :: Int -> Row
emptyList n = replicate n Nothing 

-- ** A02

-- | The size (width and height) of a shape
shapeSize :: Shape -> (Int,Int)
shapeSize (S (s:rs)) = ((length  (s:rs)), (length s)) 

-- ** A03
-- | Count how many non-empty squares a shape contains
blockCount :: Shape -> Int
blockCount (S (s:rs)) = length (filter (Nothing/=) (concat (s:rs)))

-- * The Shape invariant

-- ** A04
-- | Shape invariant (shapes have at least one row, at least one column, and are rectangular)
prop_Shape :: Shape -> Bool
prop_Shape (S (s:rs)) = shapeSize (S (s:rs)) > (0,0)


-- * Test data generators

-- ** A05
-- | A random generator for colours
rColour :: Gen Colour
rColour = elements [Black,Red,Green,Yellow,Blue,Purple,Cyan,Grey]

instance Arbitrary Colour where
  arbitrary = rColour

-- ** A06
-- | A random generator for shapes
rShape :: Gen Shape
rShape = elements allShapes


instance Arbitrary Shape where
  arbitrary = rShape

-- * Transforming shapes

-- ** A07
-- | Rotate a shape 90 degrees
rotateShape :: Shape -> Shape
rotateShape (S (s:rs)) = S (reverse (transpose (s:rs)))

-- ** A08
-- | shiftShape adds empty squares above and to the left of the shape
shiftShape :: (Int,Int) -> Shape -> Shape
shiftShape (n,r) (S (s:rs)) = S (shiftDown n (shiftRight r (s:rs))) 

shiftDown :: Int -> [Row] -> [Row]
shiftDown n row = [(replicate n Nothing) ++ r | r <- row]


shiftRight :: Int -> [Row] -> [Row]
shiftRight n (s:rs) = (rows (emptyShape ((length(s)),n))) ++ (s:rs)

-- ** A09
-- | padShape adds empty sqaure below and to the right of the shape
padShape :: (Int,Int) -> Shape -> Shape
padShape (n,r) (S (s:rs)) = S (shiftUp n ( shiftLeft r (s:rs)))

shiftLeft :: Int -> [Row] -> [Row]
shiftLeft n (s:rs) = (s:rs) ++ (rows (emptyShape ((length(s)),n)))

shiftUp :: Int -> [Row] -> [Row]
shiftUp n row = [r ++ (replicate n Nothing) | r <-row]

-- ** A10
-- | pad a shape to a given size
padShapeTo :: (Int,Int) -> Shape -> Shape
padShapeTo (n,r) (S (s:rs)) = padShape ((n-x),(r-y)) (S (s:rs)) 
  where (x,y) = shapeSize (S (s:rs))

-- * Comparing and combining shapes

-- ** B01

-- | Test if two shapes overlap
overlaps :: Shape -> Shape -> Bool
s1 `overlaps` s2 = error "A11 overlaps undefined"

-- ** B02
-- | zipShapeWith, like 'zipWith' for lists
zipShapeWith :: (Square->Square->Square) -> Shape -> Shape -> Shape
zipShapeWith = error "A12 zipShapeWith undefined"

-- ** B03
-- | Combine two shapes. The two shapes should not overlap.
-- The resulting shape will be big enough to fit both shapes.
combine :: Shape -> Shape -> Shape
s1 `combine` s2 = error "A13 zipShapeWith undefined"
