module SpecEnv where

import SpecHelper

spec :: Spec
spec = describe "meh" $ do
    context "findCorral" $
      it "should be True" $
        findCorral (1, 8) [(0,0), (0, 5), (1, 8)]
          `shouldBe` True

    context "findCorral" $
      it "should be False" $
        findCorral (1, 8) [(0,0), (0, 5), (1, 9)]
          `shouldBe` False 

main :: IO ()
main = hspec spec