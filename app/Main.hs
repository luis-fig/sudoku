-- | Demonstração da Fase 1. É o único módulo com IO.
--
-- Executar a partir da raiz do projeto: @cabal run sudoku@
module Main (main) where

import Board
import Data.Char (intToDigit)
import Model
import Parsing (lerTabuleiro)

mostrarCelula :: Celula -> Char
mostrarCelula Vazia = '.'
mostrarCelula (Fixa n) = intToDigit n
mostrarCelula (Preenchida n) = intToDigit n

mostrarTabuleiro :: Tabuleiro -> String
mostrarTabuleiro = unlines . map (map mostrarCelula)

main :: IO ()
main = do
  conteudo <- readFile "data/puzzle.txt"
  case lerTabuleiro conteudo of
    Nothing -> putStrLn "Erro: ficheiro invalido."
    Just t -> do
      putStr (mostrarTabuleiro t)
      putStrLn ("Valido: " ++ show (tabuleiroValido t))
      putStrLn ("Resolvido: " ++ show (tabuleiroResolvido t))
      putStrLn ("Celulas vazias: " ++ show (length (celulasVazias t)))
      putStrLn ("Candidatos em (0,2): " ++ show (candidatos t (0, 2)))
