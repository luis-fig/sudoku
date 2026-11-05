-- Todo o IO fica neste módulo: lê um puzzle de um ficheiro e mostra o
-- resultado das funções puras do núcleo (módulos em @src/@).
--
-- Executar a partir da raiz do projeto: @cabal run sudoku@
module Main (main) where

import Board
import Model (Celula (..), Tabuleiro)
import Parsing (lerTabuleiro)
import Render (mostrarTabuleiro)

ficheiroExemplo :: FilePath
ficheiroExemplo = "data/puzzle_facil.txt"

main :: IO ()
main = do
  conteudo <- readFile ficheiroExemplo
  case lerTabuleiro conteudo of
    Nothing -> putStrLn ("Erro: formato invalido em " ++ ficheiroExemplo)
    Just t -> demonstrar t

demonstrar :: Tabuleiro -> IO ()
demonstrar t = do
  putStrLn "Tabuleiro carregado:"
  putStr (mostrarTabuleiro t)
  putStrLn ""
  putStrLn ("Bem formado:     " ++ show (tabuleiroBemFormado t))
  putStrLn ("Valido:          " ++ show (tabuleiroValido t))
  putStrLn ("Resolvido:       " ++ show (tabuleiroResolvido t))
  putStrLn ("Celulas vazias:  " ++ show (length (celulasVazias t)))
  putStrLn ("Candidatos em (0,2): " ++ show (candidatos t (0, 2)))
  putStrLn ("Candidatos em (4,4): " ++ show (candidatos t (4, 4)))
  putStrLn ""
  let t' = substituirCelula (0, 2) (Preenchida 4) t
  putStrLn "Depois de colocar 4 em (0,2):"
  putStr (mostrarTabuleiro t')
  putStrLn ("Valido: " ++ show (tabuleiroValido t'))
