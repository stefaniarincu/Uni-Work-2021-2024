import Data.List 
import Data.Char 

{-
palindrom :: [String] -> Bool
palindrom str = 
    if reverse str == str then True
    else False
-}

--1
palindrom :: String -> Bool
palindrom str =  reverse str == str 

isVowel :: Char -> Bool
isVowel c = c `elem` "AEIOUaeiou"

countVowels :: String -> Int
countVowels "" = 0
countVowels (c:s) = (if isVowel c then 1 else 0) + countVowels s

nrVocale :: [String] -> Int
nrVocale [] = 0
nrVocale (s : ss)
    | palindrom s = countVowels s + nrVocale ss
    | otherwise = nrVocale ss

doarPalindr :: [String] -> [String]
doarPalindr [] = []
doarPalindr (s : ss)
    | palindrom s = [s]  ++ doarPalindr ss
    | otherwise = doarPalindr ss

--alta varianta
nrVocale' :: [String] -> Int
nrVocale' l = sum [1 | cuv <- l, lit <- cuv, reverse cuv == cuv && (elem lit "aeiouAEIOU")]

--2
f :: Int -> [Int] -> [Int]
f n [] = []
f n (h : t) 
    | even h = [h] ++ [n] ++ f n t
    | otherwise = [h] ++ f n t

f' :: Int -> [Int] -> [Int]
f' v [] = []
f' v (x : xs) = if even x 
                    then x : v : f' v xs
                else
                    x : f' v xs

--3
divizori :: Int -> [Int]
divizori n = [i | i <- [1..n],  mod n i == 0]

--4
listadiv :: [Int] -> [[Int]]
listadiv l = [divizori i | i <- l]

ldiv :: [Int] -> [[Int]]
ldiv l = [[d | d <- [1..x], mod x d == 0] | x <- l]

--5a
inIntervalRec :: Int -> Int -> [Int] -> [Int]
inIntervalRec li ls [] = []
inIntervalRec li ls (h : t) 
    | h >= li && h <= ls = [h] ++ inIntervalRec li ls t
    | otherwise = inIntervalRec li ls t

inIntRec :: Int -> Int -> [Int] -> [Int]
inIntRec i s [] = []
inIntRec i s (x : xs) = if (x >= i && x <= s)
                                then x : inIntRec i s xs
                             else inIntRec i s xs

--5b
inIntervalComp :: Int -> Int -> [Int] -> [Int]
inIntervalComp li ls l = [x | x <- l, x >= li, x <= ls]

--6a
pozitiveRec :: [Int] -> Int
pozitiveRec [] = 0
pozitiveRec (h : t)
    | h > 0 = 1 + pozitiveRec t
    | otherwise = pozitiveRec t

--6b
pozitiveComp :: [Int] -> Int
pozitiveComp l = length [ x | x <- l, x > 0]

pozComp :: [Int] -> Int
pozComp l = sum [1 | x <- l, x > 0]

--7a
pozitiiImpareRec :: Int -> [Int] -> [Int]
pozitiiImpareRec _ [] = []
pozitiiImpareRec poz (h : t)
    | odd h = [poz] ++ pozitiiImpareRec (poz + 1) t
    | otherwise = pozitiiImpareRec (poz + 1) t

pozImpRec :: Int -> [Int] -> [Int]
pozImpRec _ [] = []
pozImpRec poz (x : xs) 
    | odd x = poz : pozImpRec (poz + 1) xs
    | otherwise = pozImpRec (poz + 1) xs

--7b
pozitiiImpareComp :: [Int] -> [Int]
pozitiiImpareComp l = [ fst (x) | x <- zip [0..length l] l, odd (snd (x)) ]

pozImpComp :: [Int] -> [Int]
pozImpComp l = [fst p | p <- zip [0..] l, odd (snd p)]

--8a

multDigitsRec :: String -> Int
multDigitsRec "" = 1
multDigitsRec (h : t) 
    | isDigit h = digitToInt h * multDigitsRec t
    | otherwise = multDigitsRec t

--8b
multDigitsComp :: String -> Int
multDigitsComp s = product [digitToInt x| x <- s, isDigit x]