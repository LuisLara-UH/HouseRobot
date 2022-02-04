module Corral
(
    findCorral
) where

import Types
import Utils

findCorral :: Corral -> Corrals -> Bool
findCorral pos = foldr (\ head -> (||) (pos == head)) False