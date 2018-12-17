{-
Mark Kaganovsky - 100963794

Carleton University
COMP3007 - Programming Paradigms
Fall 2018
Prof.Robert Collier

Assignment 2 Part 1
-}




import Codec.BMP
import GHC.Word
import Data.ByteString

import qualified Data.List as List




-- PROVIDED CODE BELOW

-- For this code to work you will need to have installed the package "bmp-1.2.6.3"
-- You can do this using the cabal package manager (as demonstrated in class)
-- or you can follow a procedure similar to the one detailed below:
--
-- 1. Download bmp-1.2.6.3.tar.gz from http://hackage.haskell.org/package/bmp
-- 2. Extract the folder bmp-1.2.6.3
-- 3. Open a terminal (with administrator rights) and do the following:
--    a. cd into bmp-1.2.6.3
--    b. runhaskell Setup configure
--    c. runhaskell Setup build
--    d. runhaskell Setup install

loadBitmapIntoIt :: FilePath -> IO ([(Int, Int, Int)], Int, Int)
loadBitmapIntoIt filename = do
  (Right bmp) <- readBMP filename
  return ((parseIntoRGBVals (convertToIntList (unpack (unpackBMPToRGBA32 bmp)))), (fst (bmpDimensions bmp)), (snd (bmpDimensions bmp)))

convertToIntList :: [Word8] -> [Int]
convertToIntList [] = []
convertToIntList (h:t) = (fromIntegral (toInteger h)) : (convertToIntList t)

parseIntoRGBVals :: [Int] -> [(Int, Int, Int)]
parseIntoRGBVals [] = []
parseIntoRGBVals (h:i:j:_:t) = (h,i,j) : (parseIntoRGBVals t)

showAsASCIIArt :: [[(Int, Int, Int)]] -> IO ()
showAsASCIIArt pixels = Prelude.putStr (unlines (showAsASCIIArt' pixels))



{-
MY CODE BELOW


You can call my functions like so:

loadBitmapIntoIt "sample_qr_code_for_decoding.bmp"
showAsASCIIArt(polarizeBitmap (formatBitmap it))


The functions that I have written to address the requirements are:
    formatBitmap :: ([(Int, Int, Int)], Int, Int) -> [[(Int, Int, Int)]]
    formatBitmap is the function I have written to address requirement (a)
    
    polarizeBitmap :: [[(Int, Int, Int)]] -> [[(Int, Int, Int)]]
    polarizeBitmap is the function I have written to address requirement (b)
    
    polarizedRowToChars :: [(Int, Int, Int)] -> [Char]
    polarizedRowToChars is the function I have written to address requirement (c)
-}




-- Takes a formatted bitmap and returns a character representation of it
showAsASCIIArt' :: [[(Int, Int, Int)]] -> [[Char]]
showAsASCIIArt' (row : rest)
    | rest == [] = [polarizedRowToChars row]
    | otherwise = [polarizedRowToChars row] ++ showAsASCIIArt' rest




-- Takes a list of polarized rgb tuples representing a row and converts it into a list of characters.
-- ex. [(255,255,255), (0,0,0), (255,255,255), (0,0,0), (0,0,0), (255,255,255), (255,255,255), (255,255,255)] -> " M MM   "
polarizedRowToChars :: [(Int, Int, Int)] -> [Char]
polarizedRowToChars (polarizedPixel : rest)
    | rest == [] = [polarizedRGBpixelToChar polarizedPixel]
    | otherwise = [polarizedRGBpixelToChar polarizedPixel] ++ polarizedRowToChars rest

-- Converts a single polarized RGB pixel to a character
-- ex. (255,255,255) -> ' '
-- ex. (0,0,0) -> 'M'
polarizedRGBpixelToChar :: (Int,Int,Int) -> Char
polarizedRGBpixelToChar (255,255,255) = ' '
polarizedRGBpixelToChar (0,0,0) = 'X'




-- Formats a bitmap into a 2 dimensional list.
formatBitmap :: ([(Int, Int, Int)], Int, Int) -> [[(Int, Int, Int)]]
formatBitmap (pixels, columns, rows) 
    | (List.length pixels) == columns = [List.take columns pixels]
    | otherwise = formatBitmap ((List.drop columns pixels), columns, rows) ++ [List.take columns pixels]




-- Polarizes a formatted bitmap (makes all pixels either white (255,255,255) or black (0,0,0))
polarizeBitmap :: [[(Int, Int, Int)]] -> [[(Int, Int, Int)]]
polarizeBitmap (row : rest)
    | rest == [] = [polarizeBitmapRow row]
    | otherwise = [polarizeBitmapRow row] ++ polarizeBitmap rest

-- Polarizes a row of pixels
polarizeBitmapRow :: [(Int, Int, Int)] -> [(Int, Int, Int)]
polarizeBitmapRow (rgbPixel : rest)
    | rest == [] = [polarizeRGBpixel rgbPixel]
    | otherwise =  [polarizeRGBpixel rgbPixel] ++ polarizeBitmapRow rest

-- Polarizes an individual pixel
polarizeRGBpixel :: (Int, Int, Int) -> (Int, Int, Int)
polarizeRGBpixel (r,g,b)
    | (averageRGB r g b ) > 127 = (255,255,255)
    | otherwise = (0,0,0)

-- Averages an RGB pixel
averageRGB :: Int -> Int -> Int -> Int
averageRGB a b c = quot (a + (b + c)) 3
