{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Replace case with fromMaybe" #-}
{-# OPTIONS_GHC -Wno-deferred-out-of-scope-variables #-}
module Utils
(
    size,
    findValue,
    findItem,
    validPos,
    getCoords,
    deleteObject
) where

import Data.List

size = 10

findValue :: Eq k => k -> [(k, a)] -> Maybe a
findValue value dict = May =<< lookup value dict

findItem :: a -> [a] -> Bool 
findItem item [] = False
findItem item (head:tail) = item == head || findCorral item tail

validPos :: (Int, Int) -> Bool 
validPos (row, column) = 0 <= row && row < size && 0 <= column && column < size

directions = [("north", (-1, 0)), ("east", (0, 1)), ("south", (1, 0)), ("west", (0, -1))]

getCoords :: (Int, Int) -> [Char] -> (Int, Int)
getCoords position direction =  
    let nextDir = findValue direction directions 
        (dirRow, dirColumn) = Maybe nextDir
        (actualRow, actualColum) = position
        nextPos = (actualRow + dirRow, actualColum + dirColumn)
    in nextPos

deleteObject :: Eq a => a -> [a] -> [a]
deleteObject obj objs = 
    if obj `elem` objs 
        then delete obj objs
        else objs