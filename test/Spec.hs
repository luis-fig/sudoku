-- | Testes da Fase 1. Sem dependências externas: cada teste é um par
-- (descrição, resultado). Executar com @cabal test@.
module Main (main) where

import Board
import Model
import Parsing
import System.Exit (exitFailure, exitSuccess)

textoPuzzle :: String
textoPuzzle =
  unlines
    [ "53..7...."
    , "6..195..."
    , ".98....6."
    , "8...6...3"
    , "4..8.3..1"
    , "7...2...6"
    , ".6....28."
    , "...419..5"
    , "....8..79"
    ]

textoSolucao :: String
textoSolucao =
  unlines
    [ "534678912"
    , "672195348"
    , "198342567"
    , "859761423"
    , "426853791"
    , "713924856"
    , "961537284"
    , "287419635"
    , "345286179"
    ]

carregar :: String -> Tabuleiro
carregar texto =
  case lerTabuleiro texto of
    Just t -> t
    Nothing -> error "Tabuleiro de teste invalido"

puzzle :: Tabuleiro
puzzle = carregar textoPuzzle

solucao :: Tabuleiro
solucao = carregar textoSolucao

testes :: [(String, Bool)]
testes =
  [ -- Parsing
    ("lerTabuleiro: puzzle valido", lerTabuleiro textoPuzzle /= Nothing)
  , ("lerTabuleiro: 80 celulas", lerTabuleiro (take 80 (filter (/= '\n') textoPuzzle)) == Nothing)
  , ("lerTabuleiro: carater invalido", lerTabuleiro ('x' : drop 1 textoPuzzle) == Nothing)
  , -- Acesso
    ("celulaEm: pista", celulaEm (0, 0) puzzle == Just (Fixa 5))
  , ("celulaEm: vazia", celulaEm (0, 2) puzzle == Just Vazia)
  , ("celulaEm: fora do tabuleiro", celulaEm (9, 0) puzzle == Nothing)
  , ("linha 0", valoresDe (linha 0 puzzle) == [5, 3, 7])
  , ("coluna 2", valoresDe (coluna 2 puzzle) == [8])
  , ("bloco (0,0)", valoresDe (bloco (0, 0) puzzle) == [5, 3, 6, 9, 8])
  , ("bloco: mesma resposta para posicoes do mesmo bloco", bloco (1, 2) puzzle == bloco (0, 0) puzzle)
  , ("celulasVazias: 51 no puzzle", length (celulasVazias puzzle) == 51)
  , ("celulasVazias: nenhuma na solucao", null (celulasVazias solucao))
  , -- Candidatos
    ("candidatos em (0,2)", candidatos puzzle (0, 2) == [1, 2, 4])
  , ("candidatos em (4,4)", candidatos puzzle (4, 4) == [5])
  , ("candidatos: celula ja preenchida", null (candidatos puzzle (0, 0)))
  , ("candidatos: posicao invalida", null (candidatos puzzle (9, 9)))
  , -- Validacao
    ("semDuplicados: sem repetidos", semDuplicados [1, 2, 3 :: Int])
  , ("semDuplicados: com repetidos", not (semDuplicados [1, 2, 1 :: Int]))
  , ("puzzle: valido mas nao resolvido", tabuleiroValido puzzle && not (tabuleiroResolvido puzzle))
  , ("solucao: resolvida", tabuleiroResolvido solucao)
  , ("tabuleiro sem linhas: mal formado", not (bemFormado []))
  , ("conflito na linha", not (tabuleiroValido (substituir (0, 2) (Preenchida 5) puzzle)))
  , ("conflito na coluna", not (tabuleiroValido (substituir (0, 3) (Preenchida 8) puzzle)))
  , ("conflito no bloco", not (tabuleiroValido (substituir (1, 1) (Preenchida 8) puzzle)))
  , -- Substituir
    ("substituir: coloca o valor", celulaEm (0, 2) (substituir (0, 2) (Preenchida 4) puzzle) == Just (Preenchida 4))
  , ("substituir: original nao muda", celulaEm (0, 2) puzzle == Just Vazia)
  , ("substituir: valor correto mantem a validade", tabuleiroValido (substituir (0, 2) (Preenchida 4) puzzle))
  ]

main :: IO ()
main = do
  let falhados = [nome | (nome, ok) <- testes, not ok]
  putStrLn ("Testes executados: " ++ show (length testes))
  if null falhados
    then putStrLn "Todos os testes passaram." >> exitSuccess
    else do
      putStrLn "Testes falhados:"
      mapM_ (putStrLn . ("  - " ++)) falhados
      exitFailure
