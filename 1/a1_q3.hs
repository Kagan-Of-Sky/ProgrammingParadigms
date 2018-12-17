puzzle :: Int -> Int -> Int
puzzle a b = a * b

enigma :: Int -> Int -> Int
enigma a b = a - b

secret :: Int -> Int -> Int
secret a b = b - a

secret (puzzle (enigma 3 5 ) 7 ) 9