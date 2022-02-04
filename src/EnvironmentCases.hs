module EnvironmentCases
(
    state1,
    state2
) where

import Types

state1 :: EnvironmentState 
state1 = ([(0, 0)], [], [((1, 1), False)], [], [((0, 0), False)])

state2 :: EnvironmentState 
state2 = ([(0, 0)], [], [((1, 1), False)], [(0, 2)], [((0, 0), False), ((0, 1), False)])

state3 :: EnvironmentState
state3 = ([(5, 5)], [(4, 4)], [((1, 1), False)], [(0, 2)], [((0, 0), False), ((0, 1), False)]) 