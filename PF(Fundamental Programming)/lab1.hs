import Data.List
 
myInt = 5555555555555555555555555555555555555555555555555555555555555555555555555555555555555
 
double :: Integer -> Integer
double x = x + x
 
triple :: Integer -> Integer
triple x = x + x + x
 
-- sau asa:
 
fact2 n
     |n == 0 = 1
     |n == 1 = 1
     |otherwise = n * fact2(n-1)
 
-- sau asa:
 
fact1 0 = 1
fact1 1 = 1
fact1 n = n * fact1(n-1)
 
verif :: Integer -> Integer -> String
verif a b = if (a > 2 * b)
               then "da"
          else
               "nu"

maxim :: Integer -> Integer -> Integer
maxim x y =
    if (x > y)
        then x
        else y

maxim3 x y z =
    let
        u = maxim x y
    in
        maxim u z

maxim4 x y z t =
    let
        u = maxim3 x y z
    in
        maxim u t
    
--6
--a
sumapatrata p q = 
     let
        a = p*p
        b = q*q
     in 
        a+b

sumaPatrata p q = p ^ 2 + q ^ 2
 
--b
parimpar x = if (mod x 2 == 0)
                    then "par"
          else
               "impar"

parImp a 
    | mod a 2 == 0 = "par"
    | otherwise = "impar"
 
--c
factorial :: Integer -> Integer
factorial n = 
     if(n == 0)
          then 1
     else
          let 
            u = n - 1
          in 
            n * factorial u

fact n 
    | n == 0 = 1
    | n == 1 = 1
    | otherwise = n * fact (n - 1)

--d
comp a b = 
    if(a > 2*b)
        then "da"
    else "nu"
    
verifDublu a b = a > (2 * b)