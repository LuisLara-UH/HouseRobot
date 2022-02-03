module Kid
(
    findKid,
    chargedKid,
    movableKid
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

movableKid :: Kid -> Direction -> [Position] -> Obstacles  -> Bool 
movableKid (pos, charged) dir busyPos obstacles =
    let newPos = getCoords pos dir 
    in not charged && if findObstacle newPos obstacles
        then pusheableObstacle newPos obstacles dir busyPos
        else not(findItem newPos busyPos)

moveKid :: Kid -> Kids -> Direction -> Kids 
moveKid (pos, charged) kids dir =
    let newPos = getCoords pos dir 
    in deleteObject (pos, charged) kids ++ [(newPos, charged)] 

chargeKid :: Kid -> Kids -> Kids 
chargeKid (pos, charged) kids = deleteObject (pos, charged) kids ++ [(pos, True)] 