--Funções auxiliares genéricas sobre listas.
module Utils
  ( comprimento
  , contem
  , semDuplicados
  , diferenca
  , elementoEm
  , substituirEm
  , tomar
  , largar
  , fatia
  , dividir
  , transpor
  ) where

--Número de elementos de uma lista.
comprimento :: [a] -> Int
comprimento [] = 0
comprimento (_ : xs) = 1 + comprimento xs

--Indica se um elemento pertence à lista.
contem :: Eq a => a -> [a] -> Bool
contem _ [] = False
contem x (y : ys) = x == y || contem x ys

--Indica se a lista não tem elementos repetidos.
semDuplicados :: Eq a => [a] -> Bool
semDuplicados [] = True
semDuplicados (x : xs) = not (contem x xs) && semDuplicados xs

--Elementos da primeira lista que não pertencem à segunda (mantém a ordem da primeira lista).

diferenca :: Eq a => [a] -> [a] -> [a]
diferenca [] _ = []
diferenca (x : xs) ys
  | contem x ys = diferenca xs ys
  | otherwise = x : diferenca xs ys

--Elemento na posição @n@ (a contar de 0), se existir.
elementoEm :: Int -> [a] -> Maybe a
elementoEm _ [] = Nothing
elementoEm n (x : xs)
  | n < 0 = Nothing
  | n == 0 = Just x
  | otherwise = elementoEm (n - 1) xs

--Substitui o elemento na posição @n@.
substituirEm :: Int -> a -> [a] -> [a]
substituirEm _ _ [] = []
substituirEm n novo (x : xs)
  | n < 0 = x : xs
  | n == 0 = novo : xs
  | otherwise = x : substituirEm (n - 1) novo xs

--Primeiros @n@ elementos da lista.
tomar :: Int -> [a] -> [a]
tomar n _ | n <= 0 = []
tomar _ [] = []
tomar n (x : xs) = x : tomar (n - 1) xs

--A lista sem os primeiros @n@ elementos.
largar :: Int -> [a] -> [a]
largar n xs | n <= 0 = xs
largar _ [] = []
largar n (_ : xs) = largar (n - 1) xs

-- @fatia inicio n xs@ devolve @n@ elementos a partir da posição @inicio@.
fatia :: Int -> Int -> [a] -> [a]
fatia inicio n xs = tomar n (largar inicio xs)

--Divide a lista em pedaços de tamanho @n@ (o último pode ser menor).
dividir :: Int -> [a] -> [[a]]
dividir _ [] = []
dividir n xs
  | n <= 0 = [xs]
  | otherwise = tomar n xs : dividir n (largar n xs)

--Transposta de uma matriz (lista de linhas) retangular.
transpor :: [[a]] -> [[a]]
transpor [] = []
transpor ([] : _) = []
transpor xss = primeiros xss : transpor (restantes xss)
  where
    primeiros [] = []
    primeiros ((y : _) : yss) = y : primeiros yss
    primeiros ([] : yss) = primeiros yss

    restantes [] = []
    restantes ((_ : ys) : yss) = ys : restantes yss
    restantes ([] : yss) = restantes yss
