module Lib
    (
        start,
        nextTurn
    ) where

import Types
import Environment
import Utils
import EnvironmentCases

start :: EnvironmentState -> IO ()
start = printState

nextTurn :: Int -> EnvironmentState -> EnvironmentState
nextTurn 0 state = state
nextTurn turns state =
    let newState = executeTurn state
    in nextTurn (turns - 1) newState