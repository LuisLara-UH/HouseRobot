module Environment
(
    executeTurn
) where
    
import Types
import Robot
import Dirt
import Kid

executeTurn :: (EnvironmentState, Activity) -> EnvironmentState
executeTurn (state, activity) = 
    let stateAfterRobotsActions = executeRobotsActions (state, activity)
        stateAfterDirty = executeDirty stateAfterRobotsActions
        stateAfterMoveKids = executeMoveKids stateAfterDirty
    in stateAfterMoveKids

executeRobotsActions :: (EnvironmentState, Activity) -> EnvironmentState 
executeRobotsActions (state, activity) = 
    let (_, _, _, _, robots) = state
    in moveRobots robots (state, activity)

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