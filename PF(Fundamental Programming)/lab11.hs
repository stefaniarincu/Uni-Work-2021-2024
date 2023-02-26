{-
class Functor f where
    fmap :: (a -> b) -> f a -> f b

class Functor f => Applicative f where
    pure :: a -> f a
    (<*>) :: f (a -> b) -> f a -> f b

ghci> Just length <*> Just "world"
Just 5

ghci> Just (++" world") <*> Just "hello,"
Just "hello, world"

ghci> pure (+) <*> Just 3 <*> Just 5
Just 8

ghci> pure (+) <*> Just 3 <*> Nothing
Nothing

ghci> (++) <$> ["ha","heh"] <*> ["?","!"]
["ha?","ha!","heh?","heh!"]
-}

--1
data List a = Nil
    | Cons a (List a)
    deriving (Eq, Show)

instance Functor List where
    fmap f Nil = Nil
    fmap f (Cons a list) = Cons (f a) (fmap f list)

instance Applicative List where
    pure a = Cons a Nil
    Nil <*> listElem = Nil
    Cons f listf <*> listElem = lappend (fmap f listElem) (listf <*> listElem)
        where
            lappend Nil list = list
            lappend (Cons a list1) list2 = Cons a (lappend list1 list2)

f = Cons (+1) (Cons (*2) Nil)
v = Cons 1 (Cons 2 Nil)
test1 = (f <*> v) == Cons 2 (Cons 3 (Cons 2 (Cons 4 Nil)))

{-
Expected result:
Prelude> let f = Cons (+1) (Cons (*2) Nil)
Prelude> let v = Cons 1 (Cons 2 Nil)
Prelude> f <*> v
Cons 2 (Cons 3 (Cons 2 (Cons 4 Nil)))

NU IN consola mea :)
Pt consola:
ghci
:l main.hs
-}

--2
data Cow = Cow {
    name :: String
    , age :: Int
    , weight :: Int
    } deriving (Eq, Show)

--a
noEmpty :: String -> Maybe String
noEmpty "" = Nothing
noEmpty s = Just s

noNegative :: Int -> Maybe Int
noNegative nr 
        | nr < 0 = Nothing
        | otherwise = Just nr

test21 = noEmpty "abc" == Just "abc"
test22 = noNegative (-5) == Nothing
test23 = noNegative 5 == Just 5

--b
cowFromString :: String -> Int -> Int -> Maybe Cow
cowFromString n v g = if noEmpty n == Just n && noNegative v == Just v && noNegative g == Just g then Just (Cow {name = n, age = v, weight = g}) else Nothing

{-
cowFromString :: String -> Int -> Int -> Maybe Cow
cowFromString nume an kg 
    | noEmpty nume == Nothing || noNegative an == Nothing || noNegative kg == Nothing = Nothing
    | otherwise = Just (Cow nume an kg)
-}

-- Validating to get rid of empty
-- strings, negative numbers
cowFromString1 :: String -> Int -> Int -> Maybe Cow
cowFromString1 name' age' weight' =
    case noEmpty name' of
        Nothing -> Nothing
        Just nammy -> case noNegative age' of
                        Nothing -> Nothing
                        Just agey -> case noNegative weight' of
                                        Nothing -> Nothing
                                        Just weighty -> Just (Cow nammy agey weighty)

--c
cowFromString' :: String -> Int -> Int -> Maybe Cow
cowFromString' n v g = Cow <$> noEmpty n <*> noNegative v <*> noNegative g

{-
*Main> cowFromString "jdhal" 10 (-10)
Nothing

*Main> cowFromString "" 10 (-10)
Nothing

*Main> cowFromString' "" 10 (-10)
Nothing

*Main> cowFromString' "" 10 10
Nothing

*Main> cowFromString' "dada" 10 (-10)
Nothing

*Main> cowFromString' "dada" 10 10
Just (Cow {name = "dada", age = 10, weight = 10})

*Main> :t Cow <$> noEmpty "shka"
Cow <$> noEmpty "shka" :: Maybe (Int -> Int -> Cow)

*Main> :t Cow <$> noEmpty "shka" <*> noNegative 10
Cow <$> noEmpty "shka" <*> noNegative 10 :: Maybe (Int -> Cow)

*Main> :t Cow <$> noEmpty "shka" <*> noNegative 10 <*> noNegative 100
Cow <$> noEmpty "shka" <*> noNegative 10 <*> noNegative 100 :: Maybe Cow

*Main> Cow <$> noEmpty "shka" <*> noNegative 10 <*> noNegative 100
Just (Cow {name = "shka", age = 10, weight = 100})
-}


--3
newtype Name = Name String deriving (Eq, Show)
newtype Address = Address String deriving (Eq, Show)
data Person = Person Name Address
    deriving (Eq, Show)

--a
validateLength :: Int -> String -> Maybe String
validateLength x s = if length s < x then Just s else Nothing

test31 = validateLength 5 "abc" == Just "abc"

--b
mkName :: String -> Maybe Name
mkName s = if validateLength 25 s == Just s then Just (Name s) else Nothing

mkName1 :: String -> Maybe Name
mkName1 s = case validateLength 25 s of 
           Nothing -> Nothing 
           Just s -> Just (Name s)

{-
mkName :: String -> Maybe Name
mkName n 
    | validateLength 25 n == Nothing = Nothing
    | otherwise = Just (Name n) 
-}

mkAddress :: String -> Maybe Address
mkAddress s = if validateLength 100 s == Just s then Just (Address s) else Nothing

mkAddress1 :: String -> Maybe Address
mkAddress1 a = case validateLength 100 a of 
                Nothing -> Nothing 
                Just a -> Just (Address a)

{-
mkAddress :: String -> Maybe Address
mkAddress a
    | validateLength 10 a == Nothing = Nothing
    | otherwise = Just (Address a) 
-}

test32 = mkName "Gigel" == Just (Name "Gigel")
test33 = mkAddress "Str Academiei" == Just (Address "Str Academiei")

--c
mkPerson :: String -> String -> Maybe Person
mkPerson n a = if mkName n == Just (Name n) && mkAddress a == Just (Address a) then Just (Person (Name n, Address a)) else Nothing

mkPerson1 :: String -> String -> Maybe Person
mkPerson1 n a =
    case mkName n of
        Nothing -> Nothing
        Just n' -> case mkAddress a of
                    Nothing -> Nothing
                    Just a' -> Just $ Person n' a'

{-
mkPerson :: String -> String -> Maybe Person
mkPerson n a 
    | mkName n == Nothing || mkAddress a == Nothing = Nothing
    | otherwise = Just (Person (Name n) (Address a))
-}

test34 = mkPerson "Gigel" "Str Academiei" == Just (Person (Name "Gigel") (Address "Str Academiei"))

--d 
mkName' :: String -> Maybe Name
mkName' n = Name <$> (validateLength 26 n)

mkName2 :: String -> Maybe Name
mkName2 s = fmap Name $ validateLength 25 s

mkAddress' :: String -> Maybe Address
mkAddress' a = Address <$> (validateLength 101 a)

mkAddress2 :: String -> Maybe Address
mkAddress2 a = fmap Address $ validateLength 100 a

mkPerson' :: String -> String -> Maybe Person
mkPerson' n a = Person <$> (mkName' n) <*> (mkAddress' a)

mkPersonApp :: String -> String -> Maybe Person
mkPersonApp n a = Person <$> mkName2 n <*> mkAddress2 a