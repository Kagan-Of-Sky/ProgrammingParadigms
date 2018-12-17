{-
Mark Kaganovsky - 100963794

Carleton University
COMP3007 - Programming Paradigms
Fall 2018
Prof.Robert Collier

Assignment 4 part 2a
-}




{-
Tail call optimized function which counts all numbers in a given range (inclusive).

Example:
countInRange [2,4,6,8,10,12,14,16,18] 3 11
Should return: 4
-}
countInRange :: [Int] -> Int -> Int -> Int
countInRange list min max = countInRangeHelper list min max 0
  where
    countInRangeHelper :: [Int] -> Int -> Int -> Int -> Int
    countInRangeHelper [] _ _ count = count
    countInRangeHelper (h:t) min max count
      | (h >= min) && (h <= max) = countInRangeHelper t min max (count+1)
      | otherwise = countInRangeHelper t min max count