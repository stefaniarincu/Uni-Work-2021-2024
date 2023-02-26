import Data.Monoid

data BinaryTree a
  = Leaf a
  | Node (BinaryTree a) (BinaryTree a)
  deriving (Show)

foldTree :: (a -> b -> b) -> b -> BinaryTree a -> b
foldTree f i (Leaf x) = f x i
foldTree f i (Node l r) = foldTree f (foldTree f i r) l

myTree = Node (Node (Leaf 1) (Leaf 2)) (Node (Leaf 3) (Leaf 4))

instance Foldable BinaryTree where
  foldr = foldTree

-- foldMap :: Monoid m => (a -> m) -> t a -> m
-- foldr :: (a -> b -> b ) -> b -> [a] -> b

treeI = Node (Node (Leaf 1) (Leaf 2)) (Node (Leaf 3) (Leaf 4))

treeS = Node (Node (Leaf "1") (Leaf "2")) (Node (Leaf "3") (Leaf "4"))

{-
foldr (++) ( foldr (++) [] ((Node ( Leaf "3" ) ( Leaf "4" ) ) ) )   (Node( Leaf "1" ) ( Leaf "2" ) )
foldr (++) [] ((Node ( Leaf "3" ) ( Leaf "4" ) ) ) )  = foldr (++) (foldr (++) []  ( Leaf "4" )) ( Leaf "3" )
                                                                [4] ++ [] = [4]
                                                        foldr (++) [4] (Leaf "3")
                                                         =[3] ++ [4] = [3,4]
foldr (++) ( foldr (++) [] ((Node ( Leaf "3" ) ( Leaf "4" ) ) ) )   (Node( Leaf "1" ) ( Leaf "2" ) )
= foldr (++) [3,4] (Node( Leaf "1" ) ( Leaf "2" ) )
= foldr (++) (foldr (++) [3,4] (Leaf "2")) (Leaf "1")
= foldr (++) [2,3,4] (Leaf "1")
= [1,2,3,4]
\*Main> foldr (++) [] treeS
"1234"
\*Main> foldr (++) ['a'] treeS
"1234a"

\*Main> getSum $ foldMap Sum treeI
10
\*Main> getSum ( foldMap Sum treeI)
10
\*Main> foldMap Sum treeI
Sum {getSum = 10}

\*Main> foldMap ( Any . (== 1) ) treeI
Any {getAny = True}
\*Main> treeI
Node (Node (Leaf 1) (Leaf 2)) (Node (Leaf 3) (Leaf 4))
\*Main> foldMap ( Any . (== 91) ) treeI
Any {getAny = False}
\*Main> getAny $ foldMap ( Any . (== 91) ) treeI
False
-}


--1
elem1 :: (Foldable t, Eq a) => a -> t a -> Bool
elem1 x xs = foldr (\y acc -> x == y || acc) False xs

elem2 :: (Foldable t, Eq a) => a -> t a -> Bool
elem2 x xs = getAny $ foldMap (\a -> Any (a == x)) xs

elem3 x = getAny . foldMap (Any . (== x))

null1 :: (Foldable t) => t a -> Bool
null1 xs = foldr (\x acc -> False && acc) True xs

null2 :: (Foldable t) => t a -> Bool
null2 xs = getAll $ foldMap (\a -> All False) xs

null3 :: (Foldable t) => t a -> Bool
null3 = getAll . foldMap (All . (const False))

lenRec [] = 0
lenRec (x:xs) = 1 + lenRec xs

lenFoldr :: (Foldable t) => t a -> Int
lenFoldr xs = foldr (\ x acc -> 1 + acc) 0 xs

lenFoldMap :: (Foldable t) => t a -> Int
lenFoldMap xs = getSum $ foldMap (\a -> Sum 1) xs

length2 :: (Foldable t) => t a -> Int
length2 = getSum . foldMap (Sum . (const 1))

toList :: (Foldable t) => t a -> [a]
toList xs = foldMap (\a -> [a]) xs

toList1 :: (Foldable t) => t a -> [a]
toList1 xs = foldr (\x acc -> x : acc) [] xs

toList3 :: (Foldable t) => t a -> [a]
toList3 = foldMap (:[])


--2
data Constant a b = Constant b 
instance Foldable (Constant a) where
    foldMap f (Constant b) = f b

exConst = foldMap Sum (Constant 3)
exConst2 = foldMap Any (Constant False)
{-
*Main> exConst2
Any {getAny = False}
*Main> exConst
Sum {getSum = 3}
-}

data Two a b = Two a b 
instance Foldable (Two a) where
    foldMap f (Two a b) = f b

exTwo = foldMap Sum (Two 1 2)
{-
ghci> exTwo
Sum {getSum = 2}
-}

data Three a b c = Three a b c 
instance Foldable (Three a b) where
    foldMap f (Three a b c) =  f c

exThree = foldMap Sum (Three 1 2 3)
{-
ghci> exThree
Sum {getSum = 3}
-}

data Three' a b = Three' a b b
instance Foldable (Three' a) where
    foldMap f (Three' a b c) = f b <> f c

exThree' = foldMap Sum (Three' 1 2 3)
{-
ghci> exThree'
Sum {getSum = 5}
-}

data Four a b = Four a b b b 
instance Foldable (Four a) where
    foldMap f (Four a b c d) = f b <> f c <> f d

exFour = foldMap Sum (Four 4 5 6 7)
{-
ghci> exFour
Sum {getSum = 18}
-}

data GoatLord a = NoGoat | OneGoat a | MoreGoats (GoatLord a) (GoatLord a) (GoatLord a)
instance Foldable GoatLord where
    foldMap f NoGoat = mempty
    foldMap f (OneGoat g) = f g 
    foldMap f (MoreGoats g1 g2 g3) = foldMap f g1 <> foldMap f g2 <> foldMap f g3

exGoat = foldMap Sum (MoreGoats (OneGoat 4) NoGoat (MoreGoats (OneGoat 3) (OneGoat 6) NoGoat))
{-
ghci> exGoat
Sum {getSum = 13}
-}

exGoat2 = foldr (*) 1 (MoreGoats (OneGoat 4) NoGoat (MoreGoats (OneGoat 3) (OneGoat 6) NoGoat))
{-
ghci> exGoat2
72
-}


{-
class Semigroup c where
  (<>) :: c -> c -> c -- asociativa
class Semigroup m -> Monoid m where
  mempty :: m
  mconcat :: [m] -> m
-}