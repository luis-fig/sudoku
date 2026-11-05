-- | Modelo de domínio do Sudoku (Fase 1).
module Model
  ( Celula (..)
  , Posicao
  , Tabuleiro
  ) where

-- | Uma célula do tabuleiro: vazia, uma pista do puzzle (não alterável)
-- ou um valor colocado pelo jogador.
data Celula
  = Vazia
  | Fixa Int
  | Preenchida Int
  deriving (Eq, Show)

-- | Posição (linha, coluna), com índices de 0 a 8.
type Posicao = (Int, Int)

-- | Tabuleiro 9x9: lista de 9 linhas, cada uma com 9 células.
type Tabuleiro = [[Celula]]
