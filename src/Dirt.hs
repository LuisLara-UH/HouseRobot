{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use foldr" #-}
module Dirt
(
    findDirt,
    cleanDirt
) where

import Types
import Utils

findDirt :: Dirt -> Dirts -> Bool
findDirt pos [] = False
findDirt pos (head:tail) = pos == head || findDirt pos tail

cleanDirt :: Dirt -> Dirts -> Dirts
cleanDirt = deleteObject