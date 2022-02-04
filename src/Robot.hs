{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use foldr" #-}
module Robot
(
    findRobot,
    moveRobots,
    followKid
) where

import Types
import Utils
import Obstacle
import Dirt
import Kid
import Corral (findCorral)

findRobot :: Position -> Robots -> Bool
findRobot pos [] = False
findRobot pos (head:tail) =
    let (actualPos, charged) = head
    in pos == actualPos || findRobot pos tail

moveRobots :: Robots -> (EnvironmentState, Activity) -> EnvironmentState
moveRobots [] (state, _) = state
moveRobots (firstRobot:otherRobots) (state, "proactive") =
    let (pos, charging) = firstRobot
        (corrals, dirts, kids, obstacles, robots) = state
        movedState
          | charging = followCorral firstRobot state
          | walkingKids kids && not charging = followKid firstRobot state
          | otherwise = state
    in moveRobots otherRobots (movedState, "proactive")
moveRobots (firstRobot:otherRobots) (state, "reactive") =
    let (pos, charging) = firstRobot
        (corrals, dirts, kids, obstacles, robots) = state
        movedState
          | findDirt pos dirts = clean pos state
          | charging = followCorral firstRobot state
          | walkingKids kids && not charging = followKid firstRobot state
          | otherwise = state
    in moveRobots otherRobots (movedState, "reactive")
moveRobots (firstRobot:otherRobots) (state, _) =
    let (pos, charging) = firstRobot
        (corrals, dirts, kids, obstacles, robots) = state
        movedState
          | findDirt pos dirts = clean pos state
          | charging && findPathToCorral firstRobot state = followCorral firstRobot state
          | walkingKids kids && not charging && findPathToKid firstRobot state = followKid firstRobot state
          | findPathToDirt firstRobot state = followDirt firstRobot state
          | otherwise = state
    in moveRobots otherRobots (movedState, "pro-reactive")

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
          | charged && length way > 2 = way !! 2
          | length way > 1 = way !! 1
          | otherwise = pos
        arrivedToCorral = findCorral newPos corrals
        newKids = if charged then deleteObject (pos, True) kids ++ [(newPos, True)] else kids
        newCharged = not arrivedToCorral && charged
    in (corrals, dirts, newKids, obstacles, deleteObject robot robots ++ [(newPos, newCharged)])

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
          | charged && length way > 2 = way !! 2
          | length way > 1 = way !! 1
          | otherwise = pos
        (newKids, newCharged) = checkFoundKid newPos kids
    in (corrals, dirts, newKids, obstacles, deleteObject robot robots ++ [(newPos, newCharged)])

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
          | charged && length way > 2 = way !! 2
          | length way > 1 = way !! 1
          | otherwise = pos
        newKids = if charged then deleteObject (pos, True) kids ++ [(newPos, True)] else kids
    in (corrals, dirts, newKids, obstacles, deleteObject robot robots ++ [(newPos, charged)])

checkFoundKid :: Position -> Kids -> (Kids, Bool)
checkFoundKid pos kids =
    let newKid = (pos, True)
        oldKid = (pos, False)
    in if findKid pos kids
        then (deleteObject oldKid kids ++ [newKid], True)
        else (kids, False)