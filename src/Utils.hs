{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Replace case with fromMaybe" #-}
{-# OPTIONS_GHC -Wno-deferred-out-of-scope-variables #-}
module Utils
(
    size,
    findItem,
    validPos,
    getCoords,
    deleteObject,
    aroundFreeSpaces,
    randomNum,
    getPositions
) where

import Data.List
import Types

import System.IO.Unsafe
import System.Random

randomNum :: Int -> Int -> Int
{-# NOINLINE randomNum #-}
randomNum min max = unsafePerformIO (getStdRandom (randomR (min, max)))
size = 10

findDirection :: Direction  -> [(Direction , Position )] -> Position
findDirection value dict =
    case lookup value dict of
        Just result -> result
        Nothing -> (0, 0)

findItem :: Eq a => a -> [a] -> Bool
findItem _ [] = False
findItem item (head:tail) = (item == head) || findItem item tail

validPos :: (Int, Int) -> Bool
validPos (row, column) = 0 <= row && row < size && 0 <= column && column < size

directions = [("north", (-1, 0)), ("east", (0, 1)), ("south", (1, 0)), ("west", (0, -1))]

getCoords :: (Int, Int) -> [Char] -> (Int, Int)
getCoords position direction =
    let nextDir = findDirection direction directions
        (dirRow, dirColumn) = nextDir
        (actualRow, actualColum) = position
        nextPos = (actualRow + dirRow, actualColum + dirColumn)
    in nextPos

deleteObject :: Eq a => a -> [a] -> [a]
deleteObject obj objs =
    if obj `elem` objs
        then delete obj objs
        else objs

distance :: Position -> Position -> Int
distance (x1, y1) (x2, y2) =
    let distance = (x1 - x2)**2 + (y1 - y2)**2
    in toInt distance

checkValidFreeSpaces :: [Position] -> [Position] -> [Position]
checkValidFreeSpaces [] _ = []
checkValidFreeSpaces (head:tail) busyPos =
    let spacesFound = checkValidFreeSpaces tail busyPos
    in if validPos head && notElem head busyPos
        then spacesFound ++ [head]
        else spacesFound

aroundFreeSpaces :: Position -> [Position] -> [Position]
aroundFreeSpaces (row, column) busyPos =
    let aroundSpaces = [(row - 1, column - 1),
                        (row - 1, column),
                        (row - 1, column + 1),
                        (row, column - 1),
                        (row, column + 1),
                        (row + 1, column - 1),
                        (row + 1, column),
                        (row + 1, column + 1)]
    in checkValidFreeSpaces aroundSpaces busyPos

getPositions :: [(Position, Bool)] -> [Position]
getPositions [] = []
getPositions (head:tail) = 
    let (pos, _) = head
    in getPositions tail ++ [pos]