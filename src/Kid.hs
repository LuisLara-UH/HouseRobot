module Kid
(
    findKid,
    chargedKid,
    movableKid,
    kidBusyPos,
    moveKid,
    moveKids,
    walkingKids,
    corralKids
) where

import Types
import Utils
import Obstacle

findKid :: Position -> Kids -> Bool
findKid pos [] = False
findKid pos (head:tail) =
    let (actualPos, charged) = head
    in pos == actualPos || findKid pos tail

chargedKid :: Position -> Kids -> Bool
chargedKid pos [] = False
chargedKid pos (head:tail) =
    let (actualPos, charged) = head
    in (pos == actualPos && charged) || chargedKid pos tail

corralKids :: [Position] -> [Position] -> [Position]
corralKids [] _ = []
corralKids (firstKid:otherKids) corrals =
    let nextCorralKids = corralKids otherKids corrals
    in if firstKid `elem` corrals
        then firstKid : nextCorralKids
        else nextCorralKids

movableKid :: Kid -> Direction -> [Position] -> Obstacles  -> Bool
movableKid (pos, charged) dir busyPos obstacles =
    let newPos = getCoords pos dir
    in validPos newPos && not charged && if findObstacle newPos obstacles
        then pusheableObstacle newPos obstacles dir busyPos
        else not(findItem newPos busyPos)

moveKid :: Kid -> Kids -> Direction -> Kids
moveKid (pos, charged) kids dir =
    let newPos = getCoords pos dir
    in deleteObject (pos, charged) kids ++ [(newPos, charged)]

directions = ["north", "east", "west", "south"]

moveKids :: Kids -> EnvironmentState -> EnvironmentState
moveKids [] state = state
moveKids (firstKid:otherKids) state =
    let (posFirstKid, chargedFirstKid) = firstKid
        (corrals, dirts, kids, obstacles, robots) = state
        busyPos = kidBusyPos state
        movingDirection = directions !! randomNum 0 3
        (movedKid, movedObstacles) =
            (
                if movableKid firstKid movingDirection busyPos obstacles
                    then (let newPos = getCoords posFirstKid movingDirection
                            in if findObstacle newPos obstacles
                                then ((newPos, False), pushObstacle newPos movingDirection obstacles)
                                else ((newPos, False), obstacles))
                    else (firstKid, obstacles)
            )
        movedKids = deleteObject firstKid kids ++ [movedKid]
        movedState = (corrals, dirts, movedKids, movedObstacles, robots)
    in  moveKids otherKids movedState

chargeKid :: Kid -> Kids -> Kids
chargeKid (pos, charged) kids = deleteObject (pos, charged) kids ++ [(pos, True)]

kidBusyPos :: EnvironmentState -> [Position]
kidBusyPos state =
    let (_, dirts, kids, obstacles, robots) = state
    in dirts ++ getPositions kids ++ getPositions robots

walkingKids :: Kids -> Bool
walkingKids [] = False
walkingKids ((posKid, charged):otherKids) = not charged || walkingKids otherKids
