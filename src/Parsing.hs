--Leitura de tabuleiros a partir de texto.
module Parsing
  ( celulaDeChar
  , lerTabuleiro
  ) where

import Data.Char (digitToInt, isSpace)
import Model
import Utils (comprimento, dividir)

--Converte um carácter numa célula; 'Nothing' se o carácter for inválido.
celulaDeChar :: Char -> Maybe Celula
celulaDeChar '.' = Just Vazia
celulaDeChar '0' = Just Vazia
celulaDeChar ch
  | ch >= '1' && ch <= '9' = Just (Fixa (digitToInt ch))
  | otherwise = Nothing

--Converte o texto em células, ignorando espaços e mudanças de linha.
celulasDeTexto :: String -> Maybe [Celula]
celulasDeTexto [] = Just []
celulasDeTexto (ch : resto)
  | isSpace ch = celulasDeTexto resto
  | otherwise =
      case celulaDeChar ch of
        Nothing -> Nothing
        Just cel ->
          case celulasDeTexto resto of
            Nothing -> Nothing
            Just cels -> Just (cel : cels)

--Lê um tabuleiro completo. Devolve 'Nothing' se existirem caracteres inválidos ou se o número de células não for 81.
lerTabuleiro :: String -> Maybe Tabuleiro
lerTabuleiro texto =
  case celulasDeTexto texto of
    Just cels
      | comprimento cels == tamanho * tamanho ->
          Just (Tabuleiro (dividir tamanho cels))
    _ -> Nothing
