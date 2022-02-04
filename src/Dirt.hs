{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use foldr" #-}
module Dirt
(
    findDirt,
    cleanDirt,
    makeDirts,
    dirtBusyPos
) where

import Types
import Utils

findDirt :: Dirt -> Dirts -> Bool
findDirt pos [] = False
findDirt pos (head:tail) = pos == head || findDirt pos tail

cleanDirt :: Dirt -> Dirts -> Dirts
cleanDirt = deleteObject

makeDirt :: Kid -> [Position] -> Dirt
makeDirt (pos, _) busyPos =
    let freeSpaces = aroundFreeSpaces pos busyPos
        len = length freeSpaces
        randomIndex = randomNum 0 len
    in freeSpaces !! randomIndex

makeDirts :: Kids -> [Position] -> Dirts
makeDirts [] _ = []
makeDirts (firstKid:otherKids) busyPos =
    let newDirt = makeDirt firstKid busyPos
        (_, charged) = firstKid
        newBusyPos = busyPos ++ [newDirt]
    in makeDirts otherKids newBusyPos ++ ([newDirt | not charged])

dirtBusyPos :: EnvironmentState -> [Position]
dirtBusyPos state =
    let (corrals, dirts, kids, obstacles, robots) = state
    in dirts ++ obstacles ++ corrals ++ getPositions kids ++ getPositions robots