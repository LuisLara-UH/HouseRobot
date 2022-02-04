module Environment
(
    executeTurn
) where
    
import Types
import Robot
import Dirt
import Kid

executeTurn :: EnvironmentState -> EnvironmentState
executeTurn state = 
    let stateAfterRobotsActions = executeRobotsActions state
        stateAfterDirty = executeDirty stateAfterRobotsActions
        stateAfterMoveKids = executeMoveKids stateAfterDirty
    in stateAfterMoveKids

executeRobotsActions :: EnvironmentState -> EnvironmentState 
executeRobotsActions state = 
    let (_, _, _, _, robots) = state
    in moveRobots robots state

executeDirty :: EnvironmentState -> EnvironmentState 
executeDirty state = 
    let (corrals, dirts, kids, obstacles, robots) = state
        busyPos = dirtBusyPos state
        newDirts = makeDirts kids busyPos
    in (corrals, dirts ++ newDirts, kids, obstacles, robots)

executeMoveKids :: EnvironmentState -> EnvironmentState 
executeMoveKids state = 
    let (_, _, kids, _, _) = state
    in  moveKids kids state