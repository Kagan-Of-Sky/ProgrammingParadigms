{-
Mark Kaganovsky - 100963794

Carleton University
COMP3007 - Programming Paradigms
Fall 2018
Prof.Robert Collier

Assignment 2 Part 2
-}

data TernaryLogicValue = TRU | FALS | UNKNOWN deriving (Enum, Eq, Show)

ternaryNOT :: TernaryLogicValue -> TernaryLogicValue
ternaryNOT a
    | a == TRU = FALS
    | a == FALS = TRU
    | otherwise = UNKNOWN

ternaryAND :: TernaryLogicValue -> TernaryLogicValue -> TernaryLogicValue
ternaryAND a b
    | a == FALS || b == FALS = FALS
    | a == UNKNOWN || b == UNKNOWN = UNKNOWN
    | otherwise = TRU

ternaryOR :: TernaryLogicValue -> TernaryLogicValue -> TernaryLogicValue
ternaryOR a b
    | a == TRU || b == TRU = TRU
    | a == UNKNOWN || b == UNKNOWN = UNKNOWN
    | otherwise = FALS

{-
Test

ternaryNOT TRU
ternaryNOT FALS
ternaryNOT UNKNOWN

ternaryAND TRU TRU
ternaryAND TRU FALS
ternaryAND TRU UNKNOWN
ternaryAND FALS TRU
ternaryAND FALS FALS
ternaryAND FALS UNKNOWN
ternaryAND UNKNOWN TRU
ternaryAND UNKNOWN FALS
ternaryAND UNKNOWN UNKNOWN

ternaryOR TRU TRU
ternaryOR TRU FALS
ternaryOR TRU UNKNOWN
ternaryOR FALS TRU
ternaryOR FALS FALS
ternaryOR FALS UNKNOWN
ternaryOR UNKNOWN TRU
ternaryOR UNKNOWN FALS
ternaryOR UNKNOWN UNKNOWN
-}