--Modelo de domínio do Sudoku.
module Model
  ( -- * Tipos
    Celula (..)
  , Posicao
  , Tabuleiro (..)
  , Jogada (..)
  , Erro (..)
    -- * Constantes
  , tamanho
  , tamanhoBloco
  , valoresPossiveis
  ) where

--Uma célula do tabuleiro.
data Celula
  = Vazia
  | Fixa Int
  | Preenchida Int
  deriving (Eq, Show)

--Posição no tabuleiro: (linha, coluna), ambas com índices de 0 a 8.
type Posicao = (Int, Int)

--Tabuleiro como lista de linhas (cada linha é uma lista de células).
newtype Tabuleiro = Tabuleiro [[Celula]]
  deriving (Eq, Show)

--Uma jogada: colocar um valor numa posição.
data Jogada = Jogada Posicao Int
  deriving (Eq, Show)

--Erros possíveis do domínio.
data Erro
  = ForaDosLimites
  | CelulaFixa
  | ValorInvalido
  | ConflitoLinha
  | ConflitoColuna
  | ConflitoBloco
  | FormatoInvalido
  deriving (Eq, Show)

--Dimensão do tabuleiro (número de linhas e de colunas).
tamanho :: Int
tamanho = 9

--Dimensão de cada bloco (3x3).
tamanhoBloco :: Int
tamanhoBloco = 3

--Valores que podem ser colocados numa célula: de 1 a 9.
valoresPossiveis :: [Int]
valoresPossiveis = [1 .. tamanho]
