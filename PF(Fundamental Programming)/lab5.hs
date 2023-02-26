--1
sumImp :: [Int] -> Int
sumImp l = foldr (+) 0 (map (^2) (filter odd l))

--2
verif :: [Bool] -> Bool
verif l = foldr (&&) True l

--3
allVerifies :: (Int -> Bool) -> [Int] -> Bool
--propr :: Int -> Bool
--propr x = odd x
--allVerifies propr l = foldl (&&) True (map propr l)
allVerifies prop l = foldl (&&) True (map prop l)

--4
anyVerifies :: (Int -> Bool) -> [Int] -> Bool
anyVerifies prop l = foldl (||) False (map prop l)

--5
mapFoldr :: (a -> b) -> [a] -> [b]
mapFoldr f [] = []
mapFoldr f (x:xs) = foldr (\x xs -> (f x):xs) [] xs

filterFoldr :: (a -> Bool) -> [a] -> [a]
filterFoldr f [] = []
filterFoldr f (x:xs)  = foldr (\x xs -> if f x then x:xs else xs ) [] xs

--6
listToInt :: [Integer] -> Integer
listToInt l = snd $ foldl (\(poz, a) b -> (poz + 1, a + b * 10 ^ (len - poz))) (1, 0) l
            where len = length l

--7 
--a
rmChar :: Char -> String -> String
rmChar c "" = ""
rmChar c (s:ss) 
    | s /= c = [s] ++ rmChar c ss 
    | otherwise = rmChar c ss 

--b 
rmCharsRec :: String -> String -> String
rmCharsRec s "" = ""
rmCharsRec s (l:ls)
    | elem l s = rmCharsRec s ls
    | otherwise = [l] ++ rmCharsRec s ls

--c 
rmCharsFold :: String -> String -> String
rmCharsFold s l = foldr (\s acc -> rmChar s acc) l s
