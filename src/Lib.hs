module Lib
    ( 
        start,
        nextTurn
    ) where

import Types
import Environment
import Utils
import EnvironmentCases

start :: String -> IO ()
start _ = let state = nextTurn 4 state1 
        in printState state

nextTurn :: Int -> EnvironmentState -> EnvironmentState 
nextTurn 0 state = state
nextTurn turns state =
    let newState = executeTurn state
    in nextTurn (turns - 1) newState