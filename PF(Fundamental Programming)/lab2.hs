import Data.List 
--1
poly2 :: Double -> Double -> Double -> Double -> Double
poly2 a b c x = a * x^2 + b * x + c

--2
eeny :: Integer -> String
eeny x = if mod x 2 == 0
        then "eeny"
        else "meeny"

eeny' :: Integer -> String
eeny' a 
    | even a  = "eeny"
    | otherwise = "meeny"

--3
fizzbuzz :: Integer -> String
fizzbuzz x = if mod x 3 == 0  
            then "fizz"
            else if mod x 5 == 0 
            then "buzz"
            else if mod x 15 == 0
            then "fizzbuzz"
            else " "

fizzbuzz1 :: Integer -> String
fizzbuzz1 x 
    | mod x 15 == 0 = "FizzBuzz"
    | mod x 3 == 0 = "Fizz"
    | mod x 5 == 0 = "Buzz"
    | otherwise = ""

fizzbuzz2 :: Integer -> String
fizzbuzz2 x = if (mod x 15 == 0)
                then "FizzBuzz"
              else 
                if (mod x 3 == 0)
                    then "Fizz"
                else 
                    if (mod x 5 == 0)
                        then "Buzz"
                    else ""

fibonacciCazuri :: Integer -> Integer
fibonacciCazuri n
    | n < 2 = n
    | otherwise = fibonacciCazuri (n - 1) + fibonacciCazuri (n - 2)

--fibonacciEcuational :: Integer -> Integer
--fibonacciEcuational 0 = 0
--fibonacciEcuational 1 = 1
--fibonacciEcuational n =
--fibonacciEcuational (n - 1) + fibonacciEcuational (n - 2)

--4
tribonacciCazuri :: Integer -> Integer
tribonacciCazuri n 
    | n == 1 = 1
    | n == 2 = 1
    | n == 3 = 2
    | otherwise = tribonacciCazuri (n - 1) + tribonacciCazuri (n - 2) + tribonacciCazuri (n - 3)

tribonacciEq :: Integer -> Integer
tribonacciEq 1 = 1 
tribonacciEq 2 = 1 
tribonacciEq 3 = 2
tribonacciEq n = tribonacciEq (n - 1) + tribonacciEq (n - 2) + tribonacciEq (n - 3)

--5
binomial :: Integer -> Integer -> Integer
binomial n k
    | k == 0 = 1
    | n == 0 = 0
    | otherwise = binomial (n-1) k + binomial (n-1) (k-1)

binomial' :: Integer -> Integer -> Integer
binomial' n 0 = 1
binomial' 0 k = 0
binomial' n k = binomial (n-1) k + binomial (n-1) (k-1)

--6
--a
verifL :: [Int] -> Bool
verifL n
    | even(length[n]) = even(length[n])
    | otherwise = even(length[n]) 

verifL' :: [Int] -> Bool
verifL' l = mod (length l) 2 == 0  

--b
takefinal :: [Int] -> Int -> [Int]
takefinal l n
    | length l > n = drop (length l - n) l
    | otherwise = l

--c
remove l n = (take (n-1) l) ++ (drop n l)


semiPareRec :: [Int] -> [Int]
semiPareRec [] = []
semiPareRec (h : t)
    | even h = h `div` 2 : t'
    | otherwise = t'
    where t' = semiPareRec t

--7
--a
myreplicate :: Int -> Int -> [Int]
myreplicate 0 v = []
myreplicate n v = [v] ++ myreplicate (n-1) v

myreplicate' :: Int -> Int -> [Int]
myreplicate' n v = [ v | i <- [1..n]]

--b
sumImp :: [Int] -> Int
sumImp l = sum [x | x <- l, mod x 2 == 1]

sumaImp :: [Int] -> Int
sumaImp [] = 0
sumaImp (h : t)
    | odd h = h + sumaImp t
    | otherwise = sumaImp t

--c
totalLen :: [String] -> Int
totalLen [] = 0
totalLen (h : t)
    | h !! 0 == 'A' = length h + totalLen t
    | otherwise = totalLen t

totalLen' :: [String] -> Int
totalLen' l = sum [length ls | ls <- l, head ls == 'A']

