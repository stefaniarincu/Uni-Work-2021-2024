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

