--Núcleo funcional do tabuleiro de Sudoku.
module Board
  ( -- * Construção e acesso
    tabuleiroVazio
  , linhas
  , colunas
  , blocos
  , linha
  , coluna
  , bloco
  , posicaoValida
  , celulaEm
  , valorCelula
  , valoresDe
  , celulasVazias
  , substituirCelula
    -- * Regras
  , candidatos
  , semConflitos
  , tabuleiroBemFormado
  , tabuleiroValido
  , tabuleiroResolvido
  ) where

import Data.Maybe (fromMaybe)
import Model
import Utils

--Tabuleiro 9x9 sem nenhum valor.
tabuleiroVazio :: Tabuleiro
tabuleiroVazio = Tabuleiro (replicate tamanho (replicate tamanho Vazia))

--Todas as linhas do tabuleiro.
linhas :: Tabuleiro -> [[Celula]]
linhas (Tabuleiro ls) = ls

--Todas as colunas do tabuleiro (transposta das linhas).
colunas :: Tabuleiro -> [[Celula]]
colunas = transpor . linhas

--Os nove blocos 3x3, da esquerda para a direita e de cima para baixo.
blocos :: Tabuleiro -> [[Celula]]
blocos t = [bloco (l, c) t | l <- origens, c <- origens]
  where
    origens = [0, tamanhoBloco .. tamanho - 1]

--Linha @i@ (vazia se o índice for inválido).
linha :: Int -> Tabuleiro -> [Celula]
linha i t = fromMaybe [] (elementoEm i (linhas t))

--Coluna @j@ (vazia se o índice for inválido).
coluna :: Int -> Tabuleiro -> [Celula]
coluna j t = fromMaybe [] (elementoEm j (colunas t))

--Células do bloco 3x3 que contém a posição dada, por ordem de leitura.
bloco :: Posicao -> Tabuleiro -> [Celula]
bloco p@(l, c) (Tabuleiro ls)
  | not (posicaoValida p) = []
  | otherwise = concatMap (fatia c0 tamanhoBloco) (fatia l0 tamanhoBloco ls)
  where
    l0 = tamanhoBloco * (l `div` tamanhoBloco)
    c0 = tamanhoBloco * (c `div` tamanhoBloco)

--Verifica se a posição está dentro do tabuleiro (índices de 0 a 8).
posicaoValida :: Posicao -> Bool
posicaoValida (l, c) = dentro l && dentro c
  where
    dentro n = n >= 0 && n < tamanho

--Célula numa posição, se a posição existir.
celulaEm :: Posicao -> Tabuleiro -> Maybe Celula
celulaEm (l, c) (Tabuleiro ls) =
  case elementoEm l ls of
    Nothing -> Nothing
    Just cs -> elementoEm c cs

--Valor numérico de uma célula; 'Nothing' se estiver vazia.
valorCelula :: Celula -> Maybe Int
valorCelula Vazia = Nothing
valorCelula (Fixa n) = Just n
valorCelula (Preenchida n) = Just n

--Valores presentes numa lista de células (ignora as vazias).
valoresDe :: [Celula] -> [Int]
valoresDe [] = []
valoresDe (cel : cels) =
  case valorCelula cel of
    Nothing -> valoresDe cels
    Just n -> n : valoresDe cels

--Posições das células vazias, por ordem de leitura (linha a linha).
celulasVazias :: Tabuleiro -> [Posicao]
celulasVazias (Tabuleiro ls) = vaziasDasLinhas 0 ls

vaziasDasLinhas :: Int -> [[Celula]] -> [Posicao]
vaziasDasLinhas _ [] = []
vaziasDasLinhas i (r : rs) = vaziasDaLinha i 0 r ++ vaziasDasLinhas (i + 1) rs

vaziasDaLinha :: Int -> Int -> [Celula] -> [Posicao]
vaziasDaLinha _ _ [] = []
vaziasDaLinha i j (Vazia : cs) = (i, j) : vaziasDaLinha i (j + 1) cs
vaziasDaLinha i j (_ : cs) = vaziasDaLinha i (j + 1) cs

--Devolve um novo tabuleiro com a célula da posição dada substituída.
substituirCelula :: Posicao -> Celula -> Tabuleiro -> Tabuleiro
substituirCelula p@(l, c) nova t@(Tabuleiro ls)
  | not (posicaoValida p) = t
  | otherwise = Tabuleiro (substituirNaLinha l c nova ls)

substituirNaLinha :: Int -> Int -> Celula -> [[Celula]] -> [[Celula]]
substituirNaLinha _ _ _ [] = []
substituirNaLinha i c nova (r : rs)
  | i == 0 = substituirEm c nova r : rs
  | otherwise = r : substituirNaLinha (i - 1) c nova rs

--Regras
candidatos :: Tabuleiro -> Posicao -> [Int]
candidatos t p@(l, c) =
  case celulaEm p t of
    Just Vazia -> diferenca valoresPossiveis usados
    _ -> []
  where
    usados = valoresDe (linha l t ++ coluna c t ++ bloco p t)

--Um grupo de células (linha, coluna ou bloco) não tem valores repetidos.
semConflitos :: [Celula] -> Bool
semConflitos = semDuplicados . valoresDe

gruposSemConflitos :: [[Celula]] -> Bool
gruposSemConflitos [] = True
gruposSemConflitos (g : gs) = semConflitos g && gruposSemConflitos gs

--O tabuleiro tem 9 linhas de 9 células e todos os valores estão entre 1 e 9.
tabuleiroBemFormado :: Tabuleiro -> Bool
tabuleiroBemFormado (Tabuleiro ls) =
  comprimento ls == tamanho && linhasBemFormadas ls

linhasBemFormadas :: [[Celula]] -> Bool
linhasBemFormadas [] = True
linhasBemFormadas (r : rs) =
  comprimento r == tamanho
    && valoresNoIntervalo (valoresDe r)
    && linhasBemFormadas rs

valoresNoIntervalo :: [Int] -> Bool
valoresNoIntervalo [] = True
valoresNoIntervalo (n : ns) = contem n valoresPossiveis && valoresNoIntervalo ns

--O tabuleiro está bem formado e não tem valores repetidos em nenhuma linha, coluna ou bloco (mesmo que ainda tenha células vazias).
tabuleiroValido :: Tabuleiro -> Bool
tabuleiroValido t =
  tabuleiroBemFormado t
    && gruposSemConflitos (linhas t ++ colunas t ++ blocos t)

--O tabuleiro é válido e não tem células vazias.
tabuleiroResolvido :: Tabuleiro -> Bool
tabuleiroResolvido t = tabuleiroValido t && null (celulasVazias t)
