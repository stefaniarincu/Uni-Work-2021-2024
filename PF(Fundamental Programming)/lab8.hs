--1
--a
data Punct = Pt [Int]
instance Show Punct where
   show (Pt []) = "( )"
   show (Pt (x : xs))  = "(" ++ showSep x (Pt xs) ++ ")"
            where 
                showSep x (Pt []) = show x
                showSep x (Pt (y : ys)) = show x ++ ", " ++ showSep y (Pt ys)
--b
data Arb = Vid | F Int | N Arb Arb
        deriving Show
class ToFromArb a where
    toArb :: a -> Arb
    fromArb :: Arb -> a

instance ToFromArb Punct where
    toArb :: Punct -> Arb
    toArb (Pt []) = Vid
    toArb (Pt (x : xs)) = N (F x) (toArb (Pt xs))
    
    fromArb :: Arb -> Punct
    fromArb Vid = (Pt [])
    fromArb (F x) = Pt[x]
    fromArb (N l r) = Pt (p1++p2)
            where 
                Pt p1 = fromArb l 
                Pt p2 = fromArb r

--2
data Geo a = Square a | Rectangle a a | Circle a
        deriving Show
    
class GeoOps g where
    perimeter :: (Floating a) => g a -> a
    area :: (Floating a) => g a -> a

--a
instance GeoOps Geo where
    perimeter (Square l) = 2 * l 
    perimeter (Rectangle a b) = a + b 
    perimeter (Circle r) = 2 * pi * r

    area (Square l) = l^2
    area (Rectangle a b) = a * b 
    area (Circle r) = pi * r^2

--b 
instance (Floating a, Eq a) => Eq (Geo a) where
    fig1 == fig2 = perimeter fig1 == perimeter fig2