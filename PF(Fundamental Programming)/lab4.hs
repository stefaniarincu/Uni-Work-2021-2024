
--1
factori :: Int -> [Int]
factori n = [i | i <- [1..n], mod n i == 0]

--2
prim :: Int -> Bool
prim n = length (factori n) == 2

--3
numerePrime :: Int -> [Int]
numerePrime n = [x | x <- [2..n], prim x]

--4
myzip3 :: [Int] -> [Int] -> [Int] -> [(Int, Int, Int)]
myzip3 l1 l2 l3 = [(x1, x2, x3) | ((x1, x2), x3) <- zip (zip l1 l2) l3]
--myzip3 l1 l2 l3 = [(fst(li), snd(li), lf)| li <- zip l1 l2, let lf = (l3 !! length(li))]

--5
firstEl :: [(Char, Int)] -> [Char]
firstEl l =  map fst l

--FE :: [(Char, Int)] -> [Char]
--FE l = map (\(a, b) -> a) l

--6
sumList :: [[Int]] -> [Int]
sumList l = map sum l

--7
prel2 :: [Int] -> [Int]
prel2 l = map (\ x -> if mod x 2 == 0 then div x 2 else x * 2) l 

--8
cauta :: Char -> [[Char]] -> [[Char]]
cauta c l = filter (c `elem`) l

--9
listPI :: [Int] -> [Int]
listPI l = map (^2) (filter odd l)

--10
pI :: [Int] -> [Int]
pI l = map pat (filter poz (zip l [1..]))
    where poz x = odd(snd(x))
          pat x = fst(x) ^ 2

--11
numaiVocale :: [[Char]] -> [[Char]]
numaiVocale l = map concat l
    where concat "" = []
          concat (c:cs) = if c `elem` "aeiouAEIOU" then [c] ++ concat cs
                          else concat cs
                          
--12
mymap :: (a -> b) -> [a] -> [b]
mymap f [] = []
mymap f l = (f (head l)) : mymap f (tail l)

myfilter :: (a -> Bool) -> [a] -> [a]
myfilter f [] = []
myfilter f l
    | f (head l) = head l : (myfilter f (tail l))
    | otherwise = myfilter f (tail l)
