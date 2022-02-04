{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Replace case with fromMaybe" #-}
{-# OPTIONS_GHC -Wno-deferred-out-of-scope-variables #-}
{-# LANGUAGE BlockArguments #-}
module Utils
(
    size,
    findItem,
    validPos,
    getCoords,
    deleteObject,
    aroundFreeSpaces,
    randomNum,
    getPositions,
    bfs,
    buildWay,
    printState
) where

import Data.List
import Types

import System.IO.Unsafe
import System.Random
import Text.Read (Lexeme(String))

randomNum :: Int -> Int -> Int
{-# NOINLINE randomNum #-}
randomNum min max = unsafePerformIO (getStdRandom (randomR (min, max)))
size = 10

findDirection :: Direction  -> [(Direction , Position)] -> Position
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

bfsGetPositionsFound :: [(Int, Position)] -> [Position]
bfsGetPositionsFound [] = []
bfsGetPositionsFound (head:tail) =
    let (_, pos) = head
    in pos : bfsGetPositionsFound tail

bfsAddValidPositions :: [(Int, Position)] -> [Position] -> [Position] -> [(Int, Position)]
bfsAddValidPositions [] _ _ = []
bfsAddValidPositions (firstPos:otherPos) posFound busyPos =
    let (index, pos) = firstPos
        posToAdd = [firstPos | validPos pos && notElem pos posFound && notElem pos busyPos]
    in posToAdd ++ bfsAddValidPositions otherPos posFound busyPos

bfs :: [(Int, Position)] -> Int -> [Position] -> [Position] -> (Bool, [(Int, Position)], Int)
bfs posFound index objectives busyPos =
    if index == length posFound
        then (False, posFound, index)
        else
            (
                let (parent, pos) = posFound !! index
                in if pos `elem` objectives
                    then (True, posFound, index)
                    else
                        (
                            let positionsFound = bfsGetPositionsFound posFound
                                newPos = [(index, getCoords pos "north")
                                        , (index, getCoords pos "east")
                                        , (index, getCoords pos "south")
                                        , (index, getCoords pos "west")]
                                validPositions = bfsAddValidPositions newPos positionsFound busyPos
                            in bfs (posFound ++ validPositions) (index + 1) objectives busyPos
                        )
            )

buildWay :: [(Int, Position)] -> Int -> [Position]
buildWay posFound index = 
    let (nextIndex, pos) = posFound !! index 
    in if index == 0
        then [pos]
        else buildWay posFound nextIndex ++ [pos]


printState :: EnvironmentState  -> IO ()
printState (corrals, dirts, kids, obstacles, robots) = do
  print "---------------------- House Cleaner ----------------------------"
  print "Robots :"
  print robots
  print "Dirts: "
  print dirts
  print "Corrals:"
  print corrals
  print "Kids:"
  print kids
  print "Obstacles:"
  print obstacles