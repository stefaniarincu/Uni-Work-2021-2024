{-
class Functor f where
fmap : : ( a -> b ) -> f a -> f b


*Main> ( fmap . fmap ) ( + 1 ) [ Just 1 , Just 2 , Just 3]
[Just 2,Just 3,Just 4]
*Main> fmap  ( + 1 ) [ Just 1 , Just 2 , Just 3]

<interactive>:2:1: error:

*Main> fmap  ( + 1 ) [ 1 , 2 , 3]
[2,3,4]
*Main> ( fmap . map ) ( + 1 ) [ Just 1 , Just 2 , Just 3]

<interactive>:4:26: error:

*Main> ( map . fmap ) ( + 1 ) [ Just 1 , Just 2 , Just 3]
[Just 2,Just 3,Just 4]
////////////////////////////////////////////////////////

*Main> fmap (*2) (Identity 10)

<interactive>:6:1: error:
    * No instance for (Show (Identity Integer))
	
*Main> fmap (*2) (Identity 10)
Identity 20

*Main> fmap ("Luam " ++) (Identity "10 la PF")
Identity "Luam 10 la PF"
-}


newtype Identity a = Identity a
    deriving Show
instance Functor Identity where
    fmap f (Identity a) = Identity (f a)


data Pair a = Pair a a
    deriving Show
instance Functor Pair where 
    fmap f (Pair a1 a2) = Pair (f a1) (f a2)

{-
*Main> fmap ("luam " ++) (Pair "vacanta" "10 la PF")
Pair "luam vacanta" "luam 10 la PF"

*Main> :t Pair "vacanta" "10 la PF"
Pair "vacanta" "10 la PF" :: Pair [Char]

*Main> :t Pair 10 20
Pair 10 20 :: Num a => Pair a

*Main> fmap (+2) (Pair 10 20)
Pair 12 22
-}


data Constant a b = Constant b
    deriving Show
instance Functor (Constant a) where
    fmap f (Constant b) = Constant (f b)

data Two a b = Two a b
    deriving Show
instance Functor (Two a) where 
    fmap f (Two a b) = Two a (f b)

{-  
*Main> fmap (+2) (Two 10 20)
Two 10 22

*Main>   fmap (+2) (Two [10,20,30] 20)
Two [10,20,30] 22

*Main>   fmap (+2) (Two "PF" 20)
Two "PF" 22

*Main> fmap ("luam " ++) (Two "vacanta" "10 la PF")
Two "vacanta" "luam 10 la PF"

*Main> fmap ("luam " ++) (Two [1] "10 la PF")
Two [1] "luam 10 la PF"
-}


data Three a b c = Three a b c
    deriving Show
instance Functor (Three a b) where 
    fmap f (Three a b c) = Three a b (f c)

data Three' a b = Three' a b b
    deriving Show
instance Functor (Three' a) where 
    fmap f (Three' a b1 b2) = Three' a (f b1) (f b2)

{-
*Main> fmap (+2) (Three 10 20 30)
Three 10 20 32

*Main> fmap (+2) (Three' 10 20 30)
Three' 10 22 32

*Main> fmap (+2) (Three' "PF" 20 30)
Three' "PF" 22 32

*Main> fmap (+2) (Three "PF" [20,50] 30)
Three "PF" [20,50] 32

*Main> fmap ("luam " ++) (Three [1,2] "vacanta" "10 la PF")
Three [1,2] "vacanta" "luam 10 la PF"

*Main> fmap ("luam " ++) (Three' [1,2] "vacanta" "10 la PF")
Three' [1,2] "luam vacanta" "luam 10 la PF"

*Main> fmap (++ [100,200]) (Three "PF" 20 [30,40])
Three "PF" 20 [30,40,100,200]

*Main> (fmap.fmap) (+2) (Three "PF" 20 [30,40])  ---atentie
Three "PF" 20 [32,42]
-}


data Four a b c d = Four a b c d
    deriving Show
instance Functor (Four a b c) where 
    fmap f (Four a b c d) = Four a b c (f d)

data Four'' a b = Four'' a a a b
    deriving Show
instance Functor (Four'' a) where 
    fmap f (Four'' a1 a2 a3 b) = Four'' a1 a2 a3 (f b)

{- 
*Main> fmap ("luam " ++) ( Four [1,2] 10 "vacanta" "10 la PF")
Four [1,2] 10 "vacanta" "luam 10 la PF"

*Main> fmap ("luam " ++) ( Four'' [1,2] [10] [1,2,3] "10 la PF")
Four'' [1,2] [10] [1,2,3] "luam 10 la PF"
-}


data Quant a b = Finance | Desk a | Bloor b
    deriving Show
instance Functor (Quant a) where
    fmap _ Finance = Finance
    fmap _ (Desk a) = Desk a
    fmap f (Bloor b) = Bloor (f b)

{-
*Main> fmap (+2) (Desk 10)
Desk 10
*Main> fmap (+2) Finance
Finance
*Main> fmap (+2) (Bloor 10)
Bloor 12
-}


data LiftItOut f a = LiftItOut (f a)
    deriving Show
instance Functor f  => Functor (LiftItOut f) where
    fmap f (LiftItOut fa) = LiftItOut (fmap f fa)

{-
*Main> fmap (+2) (LiftItOut (Pair 1 2))
LiftItOut (Pair 3 4)

*Main> fmap (++ [100]) (LiftItOut (Pair [1,2,3] [10,20,30]))
LiftItOut (Pair [1,2,3,100] [10,20,30,100])

*Main> (fmap.fmap) (+2) (LiftItOut (Pair [1,2,3] [10,20,30]))
LiftItOut (Pair [3,4,5] [12,22,32])
-}    

data Parappa f g a = DaWrappa (f a) (g a)
    deriving Show
instance (Functor f, Functor g) => Functor (Parappa f g) where
    fmap f (DaWrappa fa ga) = DaWrappa (fmap f fa) (fmap f ga)

{-
-- fmap (++ [100]) (DaWrappa (Pair [1,2,3] [10,20]) [1,2])  
		--- nu merge map (++ [100]) [1,2]
		-- merge map  (++ [100]) [[1],[2]]
		---[[1,100],[2,100]]
-}
{-
*Main> fmap (+10) (DaWrappa (Pair 10 20) (Pair 10 20))
DaWrappa (Pair 20 30) (Pair 20 30)

*Main> fmap (+10) (DaWrappa (Pair 10 20) [1,2])
DaWrappa (Pair 20 30) [11,12]

*Main> fmap (++ [100,200]) (DaWrappa (Pair [10,20] [30, 40] ) [[1,2], [3,4]])
DaWrappa (Pair [10,20,100,200] [30,40,100,200]) [[1,2,100,200],[3,4,100,200]]
-}


data IgnoreOne f g a b = IgnoringSomething (f a) (g b)
    deriving Show
instance Functor g => Functor (IgnoreOne f g a) where
    fmap f (IgnoringSomething fa gb) = IgnoringSomething fa (fmap f gb)

{-
*Main>  fmap (+10) (IgnoringSomething (Pair 10 20) [1,2])
IgnoringSomething (Pair 10 20) [11,12]
-}


data Notorious g o a t = Notorious (g o) (g a) (g t)
    deriving Show
instance Functor g => Functor (Notorious g o a) where
    fmap f (Notorious go ga gt) = Notorious go ga (fmap f gt)

{-
*Main>  fmap (+10) (Notorious "ceva" [10,20] [1,2])
Notorious "ceva" [10,20] [11,12]
-}


data GoatLord a = NoGoat | OneGoat a | MoreGoats (GoatLord a) (GoatLord a) (GoatLord a)
    deriving Show
instance Functor GoatLord where
    fmap f NoGoat = NoGoat
    fmap f (OneGoat a) = OneGoat (f a)
    fmap f (MoreGoats g1 g2 g3) = MoreGoats (fmap f g1) (fmap f g2) (fmap f g3)

{-
*Main> fmap (*2) ( MoreGoats NoGoat (OneGoat 10) (OneGoat 90))
MoreGoats NoGoat (OneGoat 20) (OneGoat 180)
-}


data TalkToMe a = Halt | Print String a | Read (String -> a)
{-
instance Show a => Show (TalkToMe a) where
    show Halt = "Halt"
    show (Print s a) = "Print String " ++ show a
    show (Read sa) = "Read " 
-}

getVal (Read f) str = f str
getHalt (Halt) = "Halt"
getPrint (Print s x) = show s ++" " ++ show x

instance Functor TalkToMe where
    fmap f Halt = Halt
    fmap f (Print s a) = Print s (f a)
    fmap f (Read sa) = Read (f . sa)

{-
*Main> getVal (fmap (+1) (Read length)) "ceva"
5
*Main> getVal (fmap (*2) (Read length)) "ceva"
8
*Main> getVal (fmap ("inceput "++) (Read (++" final"))) "ceva"
"inceput ceva final"
-}