{-
Mark Kaganovsky
100963794

Carleton University
COMP3007 - Programming Paridigms
Fall 2018
Prof.Robert Collier
Assignment 3
-}

import Data.Fixed
-- import Data.Maybe




----------------------------------------------------------------------------------------------------
-- Question 1: Pseudorandom Numbers
----------------------------------------------------------------------------------------------------
lcg :: Float -> Float
lcg xi = (69.420*xi + 420.69) `mod'` 1.0

-- Testing function
generateRandomNumbers :: Float -> Int -> [Float]
generateRandomNumbers _ 0 = []
generateRandomNumbers seed count = generateRandomNumbers' (lcg seed) (count-1)
  where
    generateRandomNumbers' :: Float -> Int -> [Float]
    generateRandomNumbers' number count = number : generateRandomNumbers number count




----------------------------------------------------------------------------------------------------
-- Question 2: Recursive Structures
----------------------------------------------------------------------------------------------------
data Expression =
  Value Float |
  Variable |
  Addition Expression Expression |
  Subtraction Expression Expression |
  Multiplication Expression Expression |
  Division Expression Expression




----------------------------------------------------------------------------------------------------
-- Question 3: Expression Tree Functions
----------------------------------------------------------------------------------------------------

{-
Question 3.1: Evaluation

Usage and testing:
  ((evaluate (Addition (Value 3) Variable)) 4.0) == Just 7.0
  ((evaluate (Subtraction (Value 3) Variable)) 1.0) == Just 2.0
  ((evaluate (Multiplication (Value 2) Variable)) 6.0) == Just 12.0
  ((evaluate (Division (Value 4) Variable)) 2) == Just 2
  
  ((evaluate (Division (Value 4) Variable)) 0) == Nothing
  ((evaluate (Division Variable Variable)) 0) == Nothing
  ((evaluate (Division (Value 100) (Division (Value 4) Variable))) 0) == Nothing
  ((evaluate (Multiplication (Value 100) (Division (Value 4) Variable))) 0) == Nothing
  
  (evaluate (Division (Multiplication (Subtraction (Addition Variable (Value 3)) (Value 6)) (Value 3.0)) (Value 6.0)) 5.0) == Just 1.0
  (evaluate (Division (Multiplication (Subtraction (Addition Variable (Value 3)) (Value 6)) (Value 3.0)) (Value 0)) 5.0) == Nothing
-}
evaluate :: Expression -> Float -> Maybe Float
evaluate (Value literalFloat) _ = Just literalFloat
evaluate Variable substitute = Just substitute
evaluate (Addition left right) substitute = binaryOperationWithMaybe Add (evaluate left substitute) (evaluate right substitute)
evaluate (Subtraction left right) substitute = binaryOperationWithMaybe Sub (evaluate left substitute) (evaluate right substitute)
evaluate (Multiplication left right) substitute = binaryOperationWithMaybe Mul (evaluate left substitute) (evaluate right substitute)
evaluate (Division left right) substitute = binaryOperationWithMaybe Div (evaluate left substitute) (evaluate right substitute)

data BinaryOperation = Add | Sub | Mul | Div
binaryOperationWithMaybe :: BinaryOperation -> Maybe Float -> Maybe Float -> Maybe Float
binaryOperationWithMaybe Add (Just x) (Just y) = Just (x+y)
binaryOperationWithMaybe Sub (Just x) (Just y) = Just (x-y)
binaryOperationWithMaybe Mul (Just x) (Just y) = Just (x*y)
binaryOperationWithMaybe Div (Just x) (Just 0) = Nothing
binaryOperationWithMaybe Div (Just x) (Just y) = Just (x/y)
binaryOperationWithMaybe _ _ _ = Nothing




{-
Question 3.2: String expression

Usage:
  expressionStringify (Division (Multiplication (Subtraction (Addition Variable (Value 3)) (Value 6)) (Value 3.0)) (Value 6.0))
-}

expressionStringify :: Expression -> [Char]
expressionStringify (Value literalFloat) = show literalFloat
expressionStringify Variable = "x"
expressionStringify (Addition left right) = "(" ++ (expressionStringify left) ++ " + " ++ (expressionStringify right) ++ ")"
expressionStringify (Subtraction left right) = "(" ++ (expressionStringify left) ++ " - " ++ (expressionStringify right) ++ ")"
expressionStringify (Multiplication left right) = "(" ++ (expressionStringify left) ++ " * " ++ (expressionStringify right) ++ ")"
expressionStringify (Division left right) = "(" ++ (expressionStringify left) ++ " / " ++ (expressionStringify right) ++ ")"


-- Question 3.3: Print expression tree
{-data Expression =
  Value Float |
  Variable |
  Addition Expression Expression

expressionTreeStringify :: Expression -> [[Char]]
expressionTreeStringify (Value literalFloat)
expressionTreeStringify expression = etsHelper expression "" ""
 where
  etsHelper :: Expression -> [Char] -> [Char] -> [[Char]]
  etsHelper (Value literalFloat) indent currentLine = currentLine ++ (show literalFloat)
  etsHelper Variable indent currentLine = currentLine ++ "x"
  etsHelper (Addition left right) indent currentLine = (etsHelper left indent (currentLine ++ "(+) ---- ")) : (etsHelper left indent indent)
-}




{---------------------------------------------------------------------------------------------------
Question 4: Expression Tree Mutation

Usage:
  expressionStringify (expressionMutate (Division (Multiplication (Subtraction (Addition Variable (Value 3)) (Value 6)) (Value 3.0)) (Value 6.0)) 0.48)
  evaluate (expressionMutate (Division (Multiplication (Subtraction (Addition Variable (Value 3)) (Value 6)) (Value 3.0)) (Value 6.0)) 0.48) 1
---------------------------------------------------------------------------------------------------}
expressionMutate :: Expression -> Float -> Expression
expressionMutate (Value literalFloat) seed = expressionMutateLiteral literalFloat (lcg seed)
expressionMutate Variable _ = Variable
expressionMutate (Addition left right) seed
  | (lcg seed) > 0.5 = Value (100 * (lcg seed))
  | otherwise = Addition (expressionMutate left (lcg seed)) (expressionMutate right (lcg(lcg seed)))
expressionMutate (Subtraction left right) seed
  | (lcg seed) > 0.5 = Value (100 * (lcg seed))
  | otherwise = Subtraction (expressionMutate left (lcg seed)) (expressionMutate right (lcg(lcg seed)))
expressionMutate (Multiplication left right) seed
  | (lcg seed) > 0.5 = Value (100 * (lcg seed))
  | otherwise = Multiplication (expressionMutate left (lcg seed)) (expressionMutate right (lcg(lcg seed)))
expressionMutate (Division left right) seed
  | (lcg seed) > 0.5 = Value (100 * (lcg seed))
  | otherwise = Division (expressionMutate left (lcg seed)) (expressionMutate right (lcg(lcg seed)))

expressionMutateLiteral :: Float -> Float -> Expression
expressionMutateLiteral d seed
  | seed < (1/3) = Value (100 * (lcg seed))
  | seed < (2/3) = createRandomSubtree (lcg seed)
  | otherwise = Value d

createRandomSubtree ::Float -> Expression
createRandomSubtree seed
  | seed < 0.6 = Value (100 * (lcg seed))
  | seed < 0.7 = Addition (createRandomSubtree (lcg seed)) (createRandomSubtree (lcg(lcg seed)))
  | seed < 0.8 = Subtraction (createRandomSubtree (lcg seed)) (createRandomSubtree (lcg(lcg seed)))
  | seed < 0.9 = Multiplication (createRandomSubtree (lcg seed)) (createRandomSubtree (lcg(lcg seed)))
  | otherwise  = Division (createRandomSubtree (lcg seed)) (createRandomSubtree (lcg(lcg seed)))




----------------------------------------------------------------------------------------------------
-- Question 5: Trees of Best Fit
----------------------------------------------------------------------------------------------------
fit :: Expression -> (Float -> Float) -> [Float] -> Float
fit expression function values = kendallRankCC (convertMaybeToValue (evaluateAsFunction expression values) 0) (map function values)

convertMaybeToValue :: [Maybe Float] -> Float -> [Float]
convertMaybeToValue [] _ = []
convertMaybeToValue (Nothing:xs) value = value : (convertMaybeToValue xs value)
convertMaybeToValue ((Just f):xs) value = f : (convertMaybeToValue xs value)

evaluateAsFunction :: Expression -> [Float] -> [Maybe Float]
evaluateAsFunction expression [] = []
evaluateAsFunction expression (x:xs) = (evaluate expression x) : (evaluateAsFunction expression xs)

mapFunction :: (Float -> Float) -> [Float] -> [Float]
mapFunction function [] = []
mapFunction function (x:xs) = (function x) : (mapFunction function xs)

kendallRankCC :: [Float] -> [Float] -> Float
kendallRankCC x y = (((fromIntegral (countDiffs x y))-(fromIntegral((length x)-(countDiffs x y))))/ (((fromIntegral (length x)) * ((fromIntegral (length x))-1.0))/2.0))^2

countDiffs :: [Float] -> [Float] -> Int
countDiffs [] [] = 0
countDiffs (x:xs) (y:ys)
 | x == y = 1 + (countDiffs xs ys)
 | otherwise = (countDiffs xs ys)

twoX :: Float -> Float
twoX x = 2*x

threeX :: Float -> Float
threeX x = 3*x