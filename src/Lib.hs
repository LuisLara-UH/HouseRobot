module Lib
    (
        start,
        nextTurn
    ) where

import Types
import Environment
import Utils
import EnvironmentCases

start :: (EnvironmentState, Activity) -> IO ()
start state = printState (nextTurn 5 state)

nextTurn :: Int -> (EnvironmentState, Activity) -> EnvironmentState
nextTurn 0 (state, _) = state
nextTurn turns (state, activity) =
    let newState = executeTurn (state, activity)
    in nextTurn (turns - 1) (newState, activity)