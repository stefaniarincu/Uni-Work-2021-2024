--1
data Expr = Const Int -- integer constant
            | Expr :+: Expr -- addition
            | Expr :*: Expr -- multiplication
            deriving Eq

data Operation = Add | Mult deriving (Eq, Show)

data Tree = Lf Int -- leaf
            | Node Operation Tree Tree -- branch
            deriving (Eq, Show)

--1.1
instance Show Expr where
    show (Const a) = show a
    show (e1 :+: e2) = "(" ++ show e1 ++ " + " ++ show e2 ++ ")"
    show (e1 :*: e2) = "(" ++ show e1 ++ " * " ++ show e2 ++ ")"
    

--exp1 = ((Const 2 :*: Const 3) :+: (Const 0 :*: Const 5))
--exp2 = (Const 2 :*: (Const 3 :+: Const 4))
--exp3 = (Const 4 :+: (Const 3 :*: Const 3))
--exp4 = (((Const 1 :*: Const 2) :*: (Const 3 :+: Const 1)) :*: Const 2)

--1.2
evalExp :: Expr -> Int
evalExp (Const a) = a 
evalExp (e1 :+: e2) = evalExp e1 + evalExp e2
evalExp (e1 :*: e2) = evalExp e1 * evalExp e2 

--evalExp exp1 == 6
--evalExp exp2 == 14
--evalExp exp3 == 13
--evalExp exp4 == 16

--1.3
evalArb :: Tree -> Int
evalArb (Lf a) = a 
evalArb (Node Mult t1 t2) = evalArb t1 * evalArb t2
evalArb (Node Add t1 t2) = evalArb t1 + evalArb t2

--arb1 = Node Add (Node Mult (Lf 2) (Lf 3)) (Node Mult (Lf 0)(Lf 5))
--arb2 = Node Mult (Lf 2) (Node Add (Lf 3)(Lf 4))
--arb3 = Node Add (Lf 4) (Node Mult (Lf 3)(Lf 3))
--arb4 = Node Mult (Node Mult (Node Mult (Lf 1) (Lf 2)) (Node Add (Lf 3)(Lf 1))) (Lf 2)
--test21 = evalArb arb1 == 6
--test22 = evalArb arb2 == 14
--test23 = evalArb arb3 == 13
--test24 = evalArb arb4 == 16

--1.4
expToArb :: Expr -> Tree
expToArb (Const a) = Lf a
expToArb (e1 :+: e2) = Node Mult (expToArb e1) (expToArb e2)
expToArb (e1 :*: e2) = Node Add (expToArb e1) (expToArb e2) 

--2
class Collection c where
    empty :: c key value
    singleton :: key -> value -> c key value
    insert :: Ord key => key -> value -> c key value -> c key value
    clookup :: Ord key => key -> c key value -> Maybe value
    delete :: Ord key => key -> c key value -> c key value
    keys :: c key value -> [key]
    values :: c key value -> [value]
    toList :: c key value -> [(key, value)]
    fromList :: Ord key => [(key,value)] -> c key value

--2.1
    keys c = [fst p | p <- toList c]
    values c = [snd p | p <- toList c]
    fromList [] = empty
    fromList ((k, v) : es) = insert k v (fromList es)

--2.2
newtype PairList k v = PairList {getPairList :: [(k, v)]}

{-
--NU
instance Show PairList where
    show (PairList l) = "PairList " ++ (show l)
-}

instance (Show k, Show v) => Show (PairList k v) where
    show (PairList l) = "PairList " ++ (show l)

instance Collection PairList where
    empty = PairList []
    singleton k v = PairList [(k, v)]
    insert k v (PairList l) = PairList $ (k, v) : filter ((/= k).fst) l
    clookup k = lookup k . getPairList 
    --Atentie la lookup predefinit
    delete k (PairList l) = PairList $ filter ((/=k).fst) l
    toList = getPairList

--2.3
data SearchTree key value = Empty
                          | BNode 
                                (SearchTree key value) -- elemente cu cheia mai mica 
                                key -- cheia elementului
                                (Maybe value) -- valoarea elementului
                                (SearchTree key value) -- elemente cu cheia mai mare
                            
instance Collection SearchTree where
    empty = Empty
    singleton k v = BNode Empty k (Just v) Empty
    insert k v s = inserare s 
                where 
                    inserare Empty = singleton k v
                    inserare (BNode arb_st k1 v1 arb_dr)
                        | k == k1 = BNode arb_st k (Just v) arb_dr
                        | k < k1 = BNode (inserare arb_st) k1 v1 arb_dr
                        | otherwise = BNode arb_st k1 v1 (inserare arb_dr)
    delete k s = sterge s 
                where
                    sterge Empty = Empty
                    sterge (BNode arb_st k1 v1 arb_dr)
                        | k == k1 = BNode arb_st k Nothing arb_dr
                        | k < k1 = BNode (sterge arb_st) k1 v1 arb_dr
                        | otherwise = BNode arb_st k1 v1 (sterge arb_dr)
    clookup k s = cauta s 
                where
                    cauta Empty = Nothing
                    cauta (BNode arb_st k1 v1 arb_dr)
                        | k == k1 = v1
                        | k < k1 = cauta arb_st
                        | otherwise = cauta arb_dr
    toList Empty = []
    toList (BNode arb_st k1 v1 arb_dr) = (toList arb_st) ++ (lista_din k1 v1) ++ (toList arb_dr)
                where
                    lista_din k (Just v) = [(k, v)]
                    lista_din _ _ = []