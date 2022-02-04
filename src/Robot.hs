{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use foldr" #-}
module Robot
(
    findRobot,
    moveRobot,
    movableRobot
) where

import Types
import Utils
import Obstacle
import Dirt
import Kid

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

moveRobots :: Robots -> EnvironmentState -> EnvironmentState
moveRobots [] state = state
moveRobots (firstRobot:otherRobots) state =
    let (pos, charging) = firstRobot
        (corrals, dirts, kids, obstacles, robots) = state
        movedState
          | findDirt pos dirts = clean pos state
          | charging && findPathToCorral firstRobot state = followCorral firstRobot state
          | walkingKids kids && not charging && findPathToKid firstRobot state = followKid firstRobot state
          | findPathToDirt firstRobot state = followDirt firstRobot state
          | otherwise = state
    in moveRobots otherRobots movedState

clean :: Dirt -> EnvironmentState -> EnvironmentState
clean pos (corrals, dirts, kids, obstacles, robots) =
    let newDirts = cleanDirt pos dirts
    in (corrals, newDirts, kids, obstacles, robots)

robotChargedBusyPos :: EnvironmentState -> [Position]
robotChargedBusyPos state =
    let (corrals, dirts, kids, obstacles, robots) = state
    in dirts ++ obstacles ++ getPositions kids ++ getPositions robots

robotUnchargedBusyPos :: EnvironmentState -> [Position]
robotUnchargedBusyPos state =
    let (_, dirts, _, obstacles, robots) = state
    in dirts ++ obstacles ++ getPositions robots

findPathToCorral :: Robot -> EnvironmentState -> Bool
findPathToCorral robot state =
    let (corrals, _, _, _, _) = state
        (pos, charged) = robot
        busyPos = if charged then robotChargedBusyPos state else robotUnchargedBusyPos state
        (found, _, _) = bfs [(-1, pos)] 0 corrals busyPos
    in found

followCorral :: Robot -> EnvironmentState -> EnvironmentState
followCorral robot state =
    let (corrals, dirts, kids, obstacles, robots) = state
        (pos, charged) = robot
        busyPos = if charged then robotChargedBusyPos state else robotUnchargedBusyPos state
        (_, posFound, index) = bfs [(-1, pos)] 0 corrals busyPos
        way = buildWay posFound index
        newPos
          | charged && length way > 1 = way !! 1
          | not (null way) = head way
          | otherwise = pos
    in (corrals, dirts, kids, obstacles, deleteObject robot robots ++ [(newPos, charged)])

findPathToKid :: Robot -> EnvironmentState -> Bool
findPathToKid robot state =
    let (corrals, _, kids, _, _) = state
        (pos, charged) = robot
        kidsPos = getPositions kids
        kidsCorral = corralKids kidsPos corrals
        busyPos = kidsCorral ++ if charged then robotChargedBusyPos state else robotUnchargedBusyPos state
        (found, _, _) = bfs [(-1, pos)] 0 kidsPos busyPos
    in found

followKid :: Robot -> EnvironmentState -> EnvironmentState
followKid robot state =
    let (corrals, dirts, kids, obstacles, robots) = state
        (pos, charged) = robot
        kidsPos = getPositions kids
        kidsCorral = corralKids kidsPos corrals
        busyPos = kidsCorral ++ if charged then robotChargedBusyPos state else robotUnchargedBusyPos state
        (_, posFound, index) = bfs [(-1, pos)] 0 kidsPos busyPos
        way = buildWay posFound index
        newPos
          | charged && length way > 1 = way !! 1
          | not (null way) = head way
          | otherwise = pos
    in (corrals, dirts, kids, obstacles, deleteObject robot robots ++ [(newPos, charged)])

findPathToDirt :: Robot -> EnvironmentState -> Bool
findPathToDirt robot state =
    let (_, dirts, _, _, _) = state
        (pos, charged) = robot
        busyPos = if charged then robotChargedBusyPos state else robotUnchargedBusyPos state
        (found, _, _) = bfs [(-1, pos)] 0 dirts busyPos
    in found

followDirt :: Robot -> EnvironmentState -> EnvironmentState
followDirt robot state =
    let (corrals, dirts, kids, obstacles, robots) = state
        (pos, charged) = robot
        busyPos = if charged then robotChargedBusyPos state else robotUnchargedBusyPos state
        (_, posFound, index) = bfs [(-1, pos)] 0 dirts busyPos
        way = buildWay posFound index
        newPos
          | charged && length way > 1 = way !! 1
          | not (null way) = head way
          | otherwise = pos
    in (corrals, dirts, kids, obstacles, deleteObject robot robots ++ [(newPos, charged)])