--As funções assumem um tabuleiro 9x9.
module Board
  ( -- * Acesso
    linha
  , coluna
  , bloco
  , celulaEm
  , celulasVazias
  , substituir
    -- * Regras
  , valoresDe
  , semDuplicados
  , candidatos
  , bemFormado
  , tabuleiroValido
  , tabuleiroResolvido
  ) where

import Data.List (transpose)
import Model

-- Acesso
--Linha i (0 a 8).
linha :: Int -> Tabuleiro -> [Celula]
linha i t = t !! i

--Coluna j (0 a 8).
coluna :: Int -> Tabuleiro -> [Celula]
coluna j t = map (!! j) t

--As 9 células do bloco 3x3 que contém a posição dada.
bloco :: Posicao -> Tabuleiro -> [Celula]
bloco (l, c) t = [t !! i !! j | i <- [l0 .. l0 + 2], j <- [c0 .. c0 + 2]]
  where
    l0 = 3 * (l `div` 3)
    c0 = 3 * (c `div` 3)

--Célula numa posição; 'Nothing' se a posição estiver fora do tabuleiro.
celulaEm :: Posicao -> Tabuleiro -> Maybe Celula
celulaEm (l, c) t
  | l < 0 || l > 8 || c < 0 || c > 8 = Nothing
  | otherwise = Just (t !! l !! c)

--Posições das células vazias, por ordem de leitura.
celulasVazias :: Tabuleiro -> [Posicao]
celulasVazias t =
  [(l, c) | (l, r) <- zip [0 ..] t, (c, x) <- zip [0 ..] r, x == Vazia]

--Novo tabuleiro com a célula da posição dada substituída.
substituir :: Posicao -> Celula -> Tabuleiro -> Tabuleiro
substituir (l, c) nova t =
  [ [if (i, j) == (l, c) then nova else x | (j, x) <- zip [0 ..] r]
  | (i, r) <- zip [0 ..] t
  ]

-- Regras
--Valores numéricos de uma lista de células (ignora as vazias).
valoresDe :: [Celula] -> [Int]
valoresDe [] = []
valoresDe (Vazia : cs) = valoresDe cs
valoresDe (Fixa n : cs) = n : valoresDe cs
valoresDe (Preenchida n : cs) = n : valoresDe cs

--A lista não tem elementos repetidos.
semDuplicados :: Eq a => [a] -> Bool
semDuplicados [] = True
semDuplicados (x : xs) = x `notElem` xs && semDuplicados xs

--Valores que ainda se podem colocar numa célula vazia: os que não aparecem na sua linha, coluna nem bloco. Lista vazia se a célula já tem valor ou se a posição é inválida.
candidatos :: Tabuleiro -> Posicao -> [Int]
candidatos t p@(l, c) =
  case celulaEm p t of
    Just Vazia -> [n | n <- [1 .. 9], n `notElem` usados]
    _ -> []
  where
    usados = valoresDe (linha l t ++ coluna c t ++ bloco p t)

--9 linhas de 9 células, com valores entre 1 e 9.
bemFormado :: Tabuleiro -> Bool
bemFormado t =
  length t == 9
    && all ((== 9) . length) t
    && all (`elem` [1 .. 9]) (concatMap valoresDe t)

--Bem formado e sem valores repetidos em nenhuma linha, coluna ou bloco (pode ter células vazias).
tabuleiroValido :: Tabuleiro -> Bool
tabuleiroValido t =
  bemFormado t && all (semDuplicados . valoresDe) grupos
  where
    blocos = [bloco (l, c) t | l <- [0, 3, 6], c <- [0, 3, 6]]
    grupos = t ++ transpose t ++ blocos

--Válido e sem células vazias.
tabuleiroResolvido :: Tabuleiro -> Bool
tabuleiroResolvido t = tabuleiroValido t && null (celulasVazias t)
