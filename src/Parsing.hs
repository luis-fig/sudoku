--Leitura de um tabuleiro a partir de texto.
-- Formato: 81 caracteres. Os dígitos de 1 a 9 são pistas; "." ou "0" são células vazias. Espaços e mudanças de linha são ignorados.
module Parsing (lerTabuleiro) where

import Data.Char (digitToInt, isSpace)
import Model

celulaDeChar :: Char -> Maybe Celula
celulaDeChar ch
  | ch == '.' || ch == '0' = Just Vazia
  | ch `elem` ['1' .. '9'] = Just (Fixa (digitToInt ch))
  | otherwise = Nothing

--'Nothing' se houver caracteres inválidos ou se o número de células não for 81.
lerTabuleiro :: String -> Maybe Tabuleiro
lerTabuleiro texto = do
  cels <- mapM celulaDeChar (filter (not . isSpace) texto)
  if length cels == 81 then Just (dividir cels) else Nothing
  where
    dividir [] = []
    dividir xs = take 9 xs : dividir (drop 9 xs)
