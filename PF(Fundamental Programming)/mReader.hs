
---Monada Reader

{-
*Main> runWriter ( logIncrement 5)
(6,["increment:5"])
*Main> runWriter ( logIncrement2 5)
(7,["increment:5","increment:6"])
*Main> runWriter ( logIncrementN 5 4)
(9,["increment:5","increment:6","increment:7","increment:8"])
*Main> lookup 'a' [('a', True), ('b', True)]
Just True
*Main> lookup 'b' [('a', True), ('b', True)]
Just True
*Main> lookup 'c' [('a', True), ('b', True)]
Nothing
*Main> fromMaybe False (lookup 'c' [('a', True), ('b', True)])

<interactive>:8:1: error:
    Variable not in scope: fromMaybe :: Bool -> Maybe Bool -> t
*Main> import Data.Maybe
*Main Data.Maybe> fromMaybe False (lookup 'c' [('a', True), ('b', True)])
False
*Main Data.Maybe> fromMaybe False (lookup 'a' [('a', True), ('b', True)])
True
-}

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

local :: (r -> r) -> Reader r a -> Reader r a
local f ma = Reader $ (\r -> (runReader ma)(f r))

-- Reader Person String

data Person = Person { name :: String, age :: Int }

showPersonN :: Person -> String
showPersonN p = let x = name p in ("NAME: " ++ x)
--showPersonN p =  "NAME: " ++ name p

showPersonA :: Person -> String
showPersonA p = let x = age p in ("AGE: " ++ show(x) )
--showPersonA p = "AGE: " ++ show( age p )


-- *Main> showPersonN $ Person "ada" 20
-- "NAME: ada"
-- *Main> showPersonA $ Person "ada" 20
-- "AGE: 20"
showPerson :: Person -> String
showPerson p = let
                x = showPersonN p
                y = showPersonA p
              in ("(" ++ x ++ "," ++ y ++")" )
-- *Main> showPerson $ Person "ada" 20
-- "(NAME: ada,AGE: 20)"
               
showPerson2 p = "(NAME: " ++ name p ++ "," ++ "AGE: " ++ show (age p) ++")"

 -- showPerson2 $ Person "ada" 20
-- "(NAME: ada,AGE: 20)"

-- newtype Reader env a = Reader { runReader :: env -> a }


-- instance Monad (Reader env) where
  -- return x = Reader (\_ -> x)
  -- ma >>= k = Reader f
    -- where f env = let a = runReader ma env
                  -- in  runReader (k a) env

-- ma:: Reader env a
-- k :: a -> Reader env b
-- runReader ma ::env -> a
-- runReader ma venv :: a -> va ::a
-- k va :: Reader env b
-- runReader (k va) :: env ->b
-- runReader(k va) venv :: b

mshowPersonN ::  Reader Person String
mshowPersonN = do   
                 p <- ask   -- p este de tipul Person
                 return ( "Name: " ++ ( name p) )
-- *Main> runReader mshowPersonN $ Person "ada" 20
-- "Name: ada"

mshowPersonA ::  Reader Person String
mshowPersonA = do   
                 p <- ask   -- p este de tipul Person
                 return ( "Age: " ++  show( age p) )
                 
-- showPerson :: Person -> String
-- showPerson p = let
                -- x = showPersonN p --x::String
                -- y = showPersonA p
              -- in ("(" ++ x ++ "," ++ y ++")" )
              
mshowPerson :: Reader Person String
mshowPerson = do    
                x <- mshowPersonN  --mshowPersonN ::Reader Person String  => x:: String
                y <- mshowPersonA
                return ("(" ++ x ++ "," ++ y ++")" ) 
                
-- *Main> runReader mshowPersonN $ Person "ada" 20
-- "Name: ada"
-- *Main> runReader mshowPersonA $ Person "ada" 20
-- "Age: 20"
-- *Main> runReader mshowPerson $ Person "ada" 20
-- "(Name: ada,Age: 20)"                

mshowPersonN1 :: Reader Person String
mshowPersonN1 = Reader $ showPersonN >>= \pers -> return pers

mshowPersonA1 :: Reader Person String
mshowPersonA1 = Reader $ showPersonA >>= \pers -> return pers

mshowPerson1 :: Reader Person String
mshowPerson1 = Reader $ showPerson >>= \pers -> return pers
-- *Main> runReader mshowPerson1 $ Person "ada" 20
-- "(NAME: ada,AGE: 20)"

mshowPersonN2 ::  Reader Person String
mshowPersonN2 = Reader showPersonN
 
mshowPersonA2 ::  Reader Person String
mshowPersonA2 = Reader showPersonA
 
mshowPerson2 :: Reader Person String
mshowPerson2 = Reader showPerson

-- *Main> runReader mshowPerson2 $ Person "ada" 20
-- "(NAME: ada,AGE: 20)"

-- mshowPersonN :: Reader Person String
-- mshowPersonN = Reader f
--                  where
--                      f (Person n a) = "NAME: " ++ n