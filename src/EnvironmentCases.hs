module EnvironmentCases
(
    state1,
    state2,
    state3,
    state4,
    state5,
    state6,
    state7,
    state8,
    state9
) where

import Types

state1 :: (EnvironmentState, Activity) 
state1 = (([(0, 0)], [], [((1, 1), False)], [], [((0, 0), False)]), "pro-reactive")

state2 :: (EnvironmentState, Activity) 
state2 = (([(0, 0)], [], [((1, 1), False)], [(0, 2)], [((0, 0), False), ((0, 1), False)]), "pro-reactive")

state3 :: (EnvironmentState, Activity)
state3 = (([(5, 5)], [(4, 4)], [((1, 1), False)], [(0, 2)], [((0, 0), False), ((0, 1), False)]), "pro-reactive")

state4 :: (EnvironmentState, Activity) 
state4 = (([(0, 0)], [], [((1, 1), False)], [], [((0, 0), False)]), "reactive")

state5 :: (EnvironmentState, Activity) 
state5 = (([(0, 0)], [], [((1, 1), False)], [(0, 2)], [((0, 0), False), ((0, 1), False)]), "reactive")

state6 :: (EnvironmentState, Activity)
state6 = (([(5, 5)], [(4, 4)], [((1, 1), False)], [(0, 2)], [((0, 0), False), ((0, 1), False)]), "reactive")

state7 :: (EnvironmentState, Activity) 
state7 = (([(0, 0)], [], [((1, 1), False)], [], [((0, 0), False)]), "proactive")

state8 :: (EnvironmentState, Activity) 
state8 = (([(0, 0)], [], [((1, 1), False)], [(0, 2)], [((0, 0), False), ((0, 1), False)]), "proactive")

state9 :: (EnvironmentState, Activity)
state9 = (([(5, 5)], [(4, 4)], [((1, 1), False)], [(0, 2)], [((0, 0), False), ((0, 1), False)]), "proactive")