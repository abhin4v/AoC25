{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE LambdaCase #-}
import Control.Monad.State.Strict
import Data.Char (digitToInt)
import Data.Map.Strict qualified as Map
import Data.Text qualified as Text

main :: IO ()
main = do
  input <- map Text.pack . lines <$> getContents
  print $ solve 2 input
  print $ solve 12 input
  where
    solve k = sum. map (fst. maxSubsequence k)

maxSubsequence :: Int -> Text.Text -> (Int, Int)
maxSubsequence k' xs' = evalState (maxSubsequence' k' xs') Map.empty
  where
    maxSubsequence' 0 _ = pure (0, 0)
    maxSubsequence' _ Text.Empty = pure (0, 0)
    maxSubsequence' k (x Text.:< xs) = do
      (av, al) <- lookupOrCache (k - 1) xs
      (bv, bl) <- lookupOrCache k xs
      let av' = digitToInt x * floor (10 ** realToFrac @_ @Double al) + av
      pure $ if av' > bv then (av', al + 1) else (bv, bl)

    lookupOrCache k xs = gets (Map.lookup (k, xs)) >>= \case
      Nothing -> do
        res <- maxSubsequence' k xs
        modify' $ Map.insert (k, xs) res
        pure res
      Just res -> pure res
