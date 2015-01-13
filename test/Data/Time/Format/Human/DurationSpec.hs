module Data.Time.Format.Human.DurationSpec
    ( main
    , spec
    ) where

import Test.Hspec
import Data.Time.Format.Human.Duration

import Data.Maybe (fromJust)
import Data.Time (UTCTime)
import Data.Time.Format (parseTime)
import System.Locale (defaultTimeLocale)

main :: IO ()
main = hspec spec

spec :: Spec
spec = describe "Duration" $ do
    it "produces zero duration for near values" $ do
        let n = parseTime' "2015-01-01 01:00:00"
            t = parseTime' "2015-01-01 01:00:00.1"

        durationValue (toDuration n t) `shouldBe` 0

    it "produces seconds for duration of less than a minute" $ do
        let n = parseTime' "2015-01-01 01:00:59"
        let t = parseTime' "2015-01-01 01:00:00"

        toDuration n t `shouldBe` Duration Past Seconds 59
        toDuration t n `shouldBe` Duration Future Seconds 59

    it "produces minutes for duration of less than an hour" $ do
        let n = parseTime' "2015-01-01 01:59:00"
        let t = parseTime' "2015-01-01 01:00:00"

        toDuration n t `shouldBe` Duration Past Minutes 59
        toDuration t n `shouldBe` Duration Future Minutes 59

    it "produces hours for duration of less than one day" $ do
        let n = parseTime' "2015-01-01 23:59:00"
        let t = parseTime' "2015-01-01 01:00:00"

        toDuration n t `shouldBe` Duration Past Hours 22
        toDuration t n `shouldBe` Duration Future Hours 22

    it "produces day of week if less than 5 days" $ do
        pendingWith "At X on Y"

    it "produces days for duration of less than 10 days" $ do
        let n = parseTime' "2015-01-10 01:00:00"
        let t = parseTime' "2015-01-01 01:00:00"

        toDuration n t `shouldBe` Duration Past Days 9
        toDuration t n `shouldBe` Duration Future Days 9

    it "produces weeks if less than 5 weeks" $ do
        let n = parseTime' "2015-01-30 01:00:00"
        let t = parseTime' "2015-01-01 01:00:00"

        toDuration n t `shouldBe` Duration Past Weeks 4
        toDuration t n `shouldBe` Duration Future Weeks 4

parseTime' :: String -> UTCTime
parseTime' = fromJust . parseTime defaultTimeLocale "%F %T%Q"
