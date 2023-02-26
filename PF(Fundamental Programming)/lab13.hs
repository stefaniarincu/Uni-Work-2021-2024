{- Monada Maybe este definita in GHC.Base 

instance Monad Maybe where
  return = Just
  Just va  >>= k   = k va
  Nothing >>= _   = Nothing


instance Applicative Maybe where
  pure = return
  mf <*> ma = do
    f <- mf
    va <- ma
    return (f va)       

instance Functor Maybe where              
  fmap f ma = pure f <*> ma   
-}

{-
ghci> return 3 :: Maybe Int
Just 3

ghci> (Just 3) >>= (\ x -> if (x>0) then Just (x*x) else Nothing)
Just 9
-}

--1
pos :: Int -> Bool
pos  x = if (x>=0) then True else False

fct :: Maybe Int ->  Maybe Bool
fct  mx =  mx  >>= (\x -> Just (pos x))

--2.2
fctDo :: Maybe Int -> Maybe Bool
fctDo mx = do   
                x <- mx
                Just (pos x)

fct3 :: Maybe Int ->  Maybe Bool
fct3 mx = do
    x <- mx
    return (pos x)

--2
--2.1
addM :: Maybe Int -> Maybe Int -> Maybe Int
addM Nothing _ = Nothing
addM _ Nothing = Nothing
addM (Just x) (Just y) = Just (x + y)

addM1 :: Maybe Int -> Maybe Int -> Maybe Int
addM1 (Just x) (Just y) = Just (x + y)
addM1 _ _ = Nothing

--2.2
addMDo :: Maybe Int -> Maybe Int -> Maybe Int
addMDo mx my = do
                    x <- mx
                    y <- my
                    Just (x + y)

addM4 :: Maybe Int -> Maybe Int -> Maybe Int
addM4 mx my = mx >>= (\x -> (my >>= (\y -> Just (x + y))))

--3
cartesian_product xs ys = xs >>= ( \x -> (ys >>= \y-> return (x,y)))

cartesian_productDo xs ys = do
                                x <- xs
                                y <- ys
                                return (x, y)

prod f xs ys = [f x y | x <- xs, y<-ys]

prodDo f xs ys = do
                    x <- xs
                    y <- ys
                    return (f x y)

myGetLine :: IO String
myGetLine = getChar >>= \x ->
      if x == '\n' then
          return []
      else
          myGetLine >>= \xs -> return (x:xs)

myGetLine1 :: IO String
myGetLine1 = do
                x <- getChar
                if x == '\n' then
                    return []
                else
                    do
                        xs <- myGetLine1
                        return (x:xs)

--4
prelNo noin =  sqrt noin
ioNumber = do
     noin  <- readLn :: IO Float
     putStrLn $ "Intrare\n" ++ (show noin)
     let  noout = prelNo noin
     putStrLn $ "Iesire"
     print noout

ioNumberS = (readLn :: IO Float) >>= (\noin -> (putStrLn $ ("Intrare\n" ++ (show noin))) >> (let noout = prelNo noin in (putStrLn $ "Iesire") >> print noout))

--6
data Person = Person { name :: String, age :: Int }

--6.1
showPersonN :: Person -> String
showPersonN (Person n a) = "NAME: " ++ n

showPersonA :: Person -> String
showPersonA (Person n a) = "AGE: " ++ show a

{-
showPersonN $ Person "ada" 20
"NAME: ada"
showPersonA $ Person "ada" 20
"AGE: 20"
-}

--6.2
showPerson :: Person -> String
showPerson (Person n a) = "(" ++ showPersonN (Person n a) ++ ", " ++ showPersonA (Person n a) ++ ")"

{-
showPerson $ Person "ada" 20
"(NAME: ada, AGE: 20)"
-}

--6.3
newtype Reader env a = Reader { runReader :: env -> a }

instance Monad (Reader env) where
  return x = Reader (\_ -> x)
  ma >>= k = Reader f
    where f env = let a = runReader ma env
                  in  runReader (k a) env

instance Applicative (Reader env) where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)       

instance Functor (Reader env) where              
  fmap f ma = pure f <*> ma    

ask :: Reader env env
ask = Reader id

mshowPersonN ::  Reader Person String
mshowPersonN = do
                  (Person n a) <- ask
                  return ("NAME: " ++ n)

mshowPersonA ::  Reader Person String
mshowPersonA = do
                  (Person n a) <- ask
                  return ("AGE: " ++ show a)

mshowPerson ::  Reader Person String
mshowPerson = do 
                  name <- mshowPersonN
                  age <- mshowPersonA
                  return ("(" ++ name ++ ", " ++ age ++ ")")

{-
ghci> runReader mshowPersonN  $ Person "ada" 20
"NAME: ada"

ghci> runReader mshowPersonA  $ Person "ada" 20
"AGE: 20"

ghci> runReader mshowPerson  $ Person "ada" 20
"(NAME: ada, AGE: 20)"
-}





----- Monada Writer

{-
--5.1
newtype WriterS a = Writer { runWriter :: (a, String) } 

instance Monad WriterS where
  return va = Writer (va, "")
  ma >>= k = let (va, log1) = runWriter ma
                 (vb, log2) = runWriter (k va)
             in  Writer (vb, log1 ++ log2)

instance Applicative WriterS where
  pure = return 
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)       

instance Functor WriterS where              
  fmap f ma = pure f <*> ma   

tell :: String -> WriterS () 
tell log = Writer ((), log)

--5.1.1
{-
logIncrement :: Int  -> WriterS Int
logIncrement x = do     
                    tell ("increment:" ++ (show x) ++ "\n")
                    return (x+1)

logIncrement2  :: Int  -> WriterS Int    
logIncrement2 x = do
                    y <- logIncrement x
                    logIncrement y

logIncrement_1 :: Int -> WriterS Int
logIncrement_1 x = Writer (x+1, ("increment:" ++ show(x) ))

logIncrement2_1 :: Int -> WriterS Int
logIncrement2_1 x = logIncrement_1 x >>= logIncrement_1
-}
{-
*Main> runWriter $ logIncrement 5
(6,"increment:5\n")

*Main> runWriter $ logIncrement2 5
(7,"increment:5\nincrement:6\n")

*Main> runWriter $ logIncrement_1 13
(14,"increment:13")

*Main> runWriter $ logIncrement2_1 13
(15,"increment:13increment:14")
-}

logIncrement :: Int -> WriterS Int
logIncrement x = Writer (x+1, ("increment:" ++ show(x) ++ " "))

logIncrement2 :: Int -> WriterS Int
logIncrement2 x = logIncrement x >>= logIncrement

--5.1.2
logIncrementN :: Int -> Int -> WriterS Int
logIncrementN x 0 = Writer (x, "")
logIncrementN x n = do
                        y <- logIncrement x
                        logIncrementN y (n - 1)
-}

--5.2
newtype WriterS a = Writer { runWriter :: (a, [String]) } 

instance  Monad WriterS where
  return va = Writer (va, [])
  ma >>= k = let (va, log1) = runWriter ma
                 (vb, log2) = runWriter (k va)
             in  Writer (vb, log1 ++ log2)


instance  Applicative WriterS where
  pure = return
  mf <*> ma = do
    f <- mf
    a <- ma
    return (f a)       

instance  Functor WriterS where              
  fmap f ma = pure f <*> ma     

tell :: String -> WriterS () 
tell log = Writer ((), [log])

logIncrement :: Int -> WriterS Int
logIncrement x = Writer (x+1, ["increment:" ++ show(x) ++ " "])

logIncrement2 :: Int -> WriterS Int
logIncrement2 x = logIncrement x >>= logIncrement

logIncrementN :: Int -> Int -> WriterS Int
logIncrementN x 0 = Writer(x, [])
logIncrementN x n = do
                        y <- logIncrement x
                        logIncrementN y (n - 1)

