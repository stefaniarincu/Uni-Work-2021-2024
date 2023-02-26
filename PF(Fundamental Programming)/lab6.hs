--1
data Fruct
  = Mar String Bool
  | Portocala String Int

listaFructe = [Mar "Ionatan" False,
                Portocala "Sanguinello" 10,
                Portocala "Valencia" 22,
                Mar "Golden Delicious" True,
                Portocala "Sanguinello" 15,
                Portocala "Moro" 12,
                Portocala "Tarocco" 3,
                Portocala "Moro" 12,
                Portocala "Valencia" 2,
                Mar "Golden Delicious" False,
                Mar "Golden" False,
                Mar "Golden" True]

--a
ePortocalaDeSicilia :: Fruct -> Bool
ePortocalaDeSicilia (Portocala soi x) = 
    if soi == "Sanguinello" || soi ==  "Tarocco" || soi == "Moro" then True
    else False
ePortocalaDeSicilia (Mar soi x) = False

--b 
nrFeliiSicilia :: [Fruct] -> Int
nrFeliiSicilia [] = 0
nrFeliiSicilia (Mar soi x : ls) = nrFeliiSicilia ls 
nrFeliiSicilia (Portocala soi x : ls) = 
    if (ePortocalaDeSicilia (Portocala soi x)) then x + nrFeliiSicilia ls 
    else nrFeliiSicilia ls 

--c
nrMereViermi :: [Fruct] -> Int
nrMereViermi [] = 0
nrMereViermi (Mar soi x : ls) = 
    if x then 1 + nrMereViermi ls
    else nrMereViermi ls
nrMereViermi (Portocala soi x : ls) = nrMereViermi ls

--2
type NumeA = String
type Rasa = String
data Animal = Pisica NumeA | Caine NumeA Rasa
            deriving Show

--a 
vorbeste :: Animal -> String
vorbeste (Pisica _) = "Meow!"
vorbeste (Caine _ _) = "Woof!"

--b 
rasa :: Animal -> Maybe String
rasa (Pisica _) = Nothing
rasa (Caine n r) = Just r

showrasa :: Maybe String -> String
showrasa Nothing = "-"
showrasa (Just r) = r

--3
data Linie = L [Int]
            deriving Show
data Matrice = M [Linie]
            deriving Show

--a 
verifica :: Matrice -> Int -> Bool
verifica (M linii) n = foldr (&&) True (map (\(L l) -> sum l == n) linii)

--test_veri1 = verifica (M[L[1,2,3], L[4,5], L[2,3,6,8], L[8,5,3]]) 10 == False
--test_verif2 = verifica (M[L[2,20,3], L[4,21], L[2,3,6,8,6], L[8,5,3,9]]) 25 == True

--alta varianta
verifica' :: Matrice -> Int -> Bool
verifica' (M m) n = foldr (&&) True [n == (foldr (+) 0 l) | L l <- m]

--b 
doarPozN :: Matrice -> Int -> Bool
--doarPozN (M linii) n = foldr (&&) True (map (\(L l) -> length l == length (filter (>0) l) && length l == n) linii)
doarPozN (M linii) n = foldr (&&) True (map (\(L l) -> length l == length (filter (>0) l)) (filter (\(L l) -> length l == n) linii))

--testPoz1 = doarPozN (M [L[1,2,3], L[4,5], L[2,3,6,8], L[8,5,3]]) 3 == True
--testPoz2 = doarPozN (M [L[1,2,-3], L[4,5], L[2,3,6,8], L[8,5,3]]) 3 == False

--alta varianta
doarPozN' :: Matrice -> Int -> Bool
doarPozN' (M m) n = foldr (&&) True [foldr (&&) True (map (> 0) l) | L l <- m, n == length l]

--c 
corect :: Matrice -> Bool
corect (M linii) = foldr (&&) True (map (\(L l) -> length l == n) linii)
                where lista = map (\(L l) -> length l) linii
                      n = lista !! 0
--testcorect1 = corect (M[L[1,2,3], L[4,5], L[2,3,6,8], L[8,5,3]]) == False
--testcorect2 = corect (M[L[1,2,3], L[4,5,8], L[3,6,8], L[8,5,3]]) == True

--alta varianta
corect' :: Matrice -> Bool
corect' (M m) =  let 
                    lista = [length l| L l <- m]
                    n = lista !! 0
                 in foldr (&&) True (map (== n) lista)