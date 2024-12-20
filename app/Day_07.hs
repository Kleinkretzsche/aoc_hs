module Day_07 where

import Data.List (nub)
import Data.Either (fromRight)
import Text.Parsec 

type Parser = Parsec String ()

num :: Parser Int
num = do
    n  <- many digit
    return (read n)

fullLine :: Parser (Int, [Int])
fullLine = do 
    tval <- num
    _    <- string ": " 
    xs   <- num `sepBy` (char ' ')
    return (tval, xs)

selections :: Int -> [[Int]]
selections n = go (n-1) initial
    where 
        initial = [[0], [1]] 
        go 0 xs = xs
        go n' xs = go (n' - 1) (((\x -> 0:x) <$> xs) ++ ((\x -> 1:x) <$> xs))

selections3 :: Int -> [[Int]]
selections3 n = go (n-1) initial
    where 
        initial = [[0], [1], [2]] 
        go 0 xs = xs
        go n' xs = go (n' - 1) (((\x -> 0:x) <$> xs) ++ ((\x -> 1:x) <$> xs) ++ ((\x -> 2:x) <$> xs))

(<||>) :: Int -> Int -> Int
a <||> b = read ((show a) ++ (show b))

intToFun :: Int -> (Int -> Int -> Int)
intToFun 0 = (+)
intToFun 1 = (*)
intToFun 2 = (<||>)
intToFun _ = (\_ _ -> 0)

zipWithFun :: [Int] -> [(Int -> Int -> Int)] -> [Int]
zipWithFun []       []     = []
zipWithFun [x]      _      = [x]
zipWithFun (x:y:xs) (f:fs) = zipWithFun ((x `f` y):xs) fs
zipWithFun _        _      = []

possibilities :: Int -> [Int] -> Int
possibilities goal xs = sum $ 
                        nub $ 
                        fmap (\xs' -> if (xs' !! 0) == goal then goal else 0) $ 
                        ((\x -> zipWithFun xs (intToFun <$> x)) <$> selections l)
    where l = (length xs) - 1

possibilities3 :: Int -> [Int] -> Int
possibilities3 goal xs = sum $ 
                         nub $ 
                         fmap (\xs' -> if (xs' !! 0) == goal then goal else 0) $ 
                         ((\x -> zipWithFun xs (intToFun <$> x)) <$> selections3 l)
    where l = (length xs) - 1
    
parseInput :: String -> [(Int, [Int])]
parseInput = (fromRight []) . runParser (fullLine `sepEndBy` (char '\n')) () "" 

day_07_a :: String -> Integer
day_07_a s = fromIntegral $ sum $ (\x -> uncurry possibilities $ x) <$> parseInput s

day_07_b :: String -> Integer
day_07_b s = fromIntegral $ sum $ (\x -> uncurry possibilities3 $ x) <$> parseInput s

day_07 :: String -> (Integer, Integer)
day_07 s = (day_07_a s, -1)
