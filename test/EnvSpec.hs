module EnvSpec
(
  spec,
  main
) where

import SpecHelper
import Lib (nextTurn)
import Dirt (makeDirt)
import Robot (followKid)

spec :: Spec
spec =
  describe "meh" $ do
    context "findCorral" $
      it "should be True" $
        findCorral (1, 8) [(0,0), (0, 5), (1, 8)]
          `shouldBe` True

    context "findCorral" $
      it "should be False" $
        findCorral (1, 8) [(0,0), (0, 5), (1, 9)]
          `shouldBe` False 

    context "build way" $
      it "the way to walk" $
        buildWay [(-1,(0,0)),(0,(0,1)),(0,(1,0)),(1,(0,2)),(1,(1,1)),(2,(2,0)),(3,(0,3)),(3,(1,2))] 4
          `shouldBe` [(0, 0), (0, 1), (1, 1)]

    context "bfs" $
      it "check bfs result" $
        bfs [(-1, (0, 0))] 0 [(0, 1)] [(1, 0), (0, 2), (1, 1)]
          `shouldBe` (True, [(-1, (0, 0)), (0, (0, 1))], 1)

    context "bfs to kid" $
      it "check bfs result" $
        bfs [(-1, (0, 0))] 0 [(1, 1)] [(0, 0)]
          `shouldBe` (True,[(-1,(0,0)),(0,(0,1)),(0,(1,0)),(1,(0,2)),(1,(1,1)),(2,(2,0)),(3,(0,3)),(3,(1,2))],4)

    context "make dirt" $
      it "check makeDirt result" $
        makeDirt ((0, 0), False) [(0, 1), (1, 1)] 
          `shouldBe` (1, 0)

    context "free spaces" $
      it "check valid free spaces" $
        aroundFreeSpaces (1, 1) []  
          `shouldBe` [(2, 2), (2, 1), (2, 0), (1, 2), (1, 0), (0, 2), (0, 1), (0, 0)]

    context "kids corrals" $
      it "check kids corrals return" $
      corralKids [(1, 1)] [(0, 0)] 
          `shouldBe` []

    context "follow kid" $
      it "check robot follows kid" $
      followKid ((0, 0), False) state1  
          `shouldBe` ([(0, 0)], [], [((1, 1), False)], [], [((0, 1), False)])

main :: IO ()
main = hspec spec