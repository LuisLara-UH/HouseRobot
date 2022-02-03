{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use foldr" #-}
module Corral
(
    findCorral
) where

import Types
import Utils

findCorral :: Corral -> Corrals -> Bool
findCorral pos [] = False
findCorral pos (head:tail) = pos == head || findCorral pos tail