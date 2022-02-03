{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use foldr" #-}
module Robot
(
    findRobot,
    moveRobot
) where

import Types
import Utils
import Obstacle

findRobot :: Position -> Robots -> Bool
findRobot pos [] = False
findRobot pos (head:tail) = 
    let (actualPos, charged) = head
    in pos == actualPos || findRobot pos tail

moveRobot :: Robot -> Robots -> Direction -> Robots 
moveRobot (pos, charging) robots dir = 
    let newPos = getCoords pos dir 
    in deleteObject (pos, charging) robots ++ [(newPos, charging)]

movableRobot :: Robot -> Direction -> [Position] -> Obstacles  -> Bool 
movableRobot (pos, _) dir busyPos obstacles =
    let newPos = getCoords pos dir 
    in if findObstacle newPos obstacles
        then pusheableObstacle newPos obstacles dir busyPos
        else not(findItem newPos busyPos)