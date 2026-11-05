-- | Representação textual do tabuleiro (função pura, sem IO).
module Render
  ( mostrarCelula
  , mostrarLinha
  , mostrarTabuleiro
  ) where

import Data.List (intercalate)
import Model
import Utils (dividir)

--Texto de uma célula: o dígito, ou @.@ se estiver vazia.
mostrarCelula :: Celula -> String
mostrarCelula Vazia = "."
mostrarCelula (Fixa n) = show n
mostrarCelula (Preenchida n) = show n

--Texto de uma linha, com separadores entre blocos.
mostrarLinha :: [Celula] -> String
mostrarLinha cs =
  intercalate " | " (map (unwords . map mostrarCelula) (dividir tamanhoBloco cs))

-- | Texto do tabuleiro completo, com separadores entre blocos (11 linhas de texto: 9 do tabuleiro e 2 separadores).
mostrarTabuleiro :: Tabuleiro -> String
mostrarTabuleiro (Tabuleiro ls) =
  unlines (intercalate [separador] (map (map mostrarLinha) (dividir tamanhoBloco ls)))
  where
    separador = "------+-------+------"
