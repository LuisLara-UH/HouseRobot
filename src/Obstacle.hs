{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use foldr" #-}
module Obstacle 
(
    findObstacle,
    pusheableObstacle,
    pushObstacle
) where

import Types
import Utils

findObstacle :: Obstacle -> Obstacles -> Bool
findObstacle pos [] = False
findObstacle pos (head:tail) = pos == head || findObstacle pos tail

pusheableObstacle :: Obstacle -> Obstacles -> Direction -> [(Int, Int)] -> Bool
pusheableObstacle pos obstacles dir busyPos =
    let nextPos = getCoords pos dir
    in validPos nextPos && (if findObstacle nextPos obstacles
                               then pusheableObstacle nextPos obstacles dir busyPos
                               else not(findItem nextPos busyPos))

pushObstacle :: Obstacle -> Direction -> Obstacles -> Obstacles
pushObstacle pos dir obstacles = 
    let nextPos = getCoords pos dir
        newObstacles = (if findObstacle nextPos obstacles
                        then pushObstacle nextPos dir obstacles
                        else obstacles)
    in  deleteObject pos obstacles ++ [nextPos]