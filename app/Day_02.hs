module Day_02 where

parseInput :: String -> [[Int]]
parseInput = map (map read) . map words . lines

view2 :: (a -> a -> a) -> [a] -> [a]
view2 _ [] = []
view2 f l = map (uncurry f) $ zip (init l) (drop 1 l)

atMost :: Int -> (Int -> Bool) -> [Int] -> Bool
atMost i f l  = count f l <= i

count :: (Int -> Bool) -> [Int] -> Int
count f xs = length $ filter f xs

getSublists :: [Int] -> [[Int]]
getSublists xs = map (\(x, y) -> x ++ tail y) $ 
                 map (\x -> splitAt x xs) [0..(length xs)-1]

checkValidity_a :: [Int] -> Bool
checkValidity_a l = (all (\x -> x > 0 && x <= 3)  $ view2 (-) l) || 
                    (all (\x -> x < 0 && x >= -3) $ view2 (-) l)

checkValidity_b :: [Int] -> Bool
checkValidity_b = any (checkValidity_a) . getSublists 

day_02_a :: [[Int]] -> Int
day_02_a = length . filter checkValidity_a

day_02_b :: [[Int]] -> Int
day_02_b = length . filter checkValidity_b

day_02 :: String -> (Int, Int)
day_02 s = (day_02_a input, day_02_b input)
    where input = parseInput s