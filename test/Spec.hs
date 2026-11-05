-- | Testes da Fase 1.
--
-- Sem dependências externas: cada teste é um par (descrição, resultado) e o
-- programa termina com erro se algum falhar. Executar com @cabal test@.
module Main (main) where

import Board
import Model
import Parsing
import Render
import System.Exit (exitFailure, exitSuccess)
import Utils

type Teste = (String, Bool)

-- ---------------------------------------------------------------------------
-- Dados de teste

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
    Nothing -> error ("Tabuleiro de teste invalido:\n" ++ texto)

puzzle :: Tabuleiro
puzzle = carregar textoPuzzle

solucao :: Tabuleiro
solucao = carregar textoSolucao

-- | Texto do puzzle sem mudanças de linha (81 caracteres).
textoCorrido :: String
textoCorrido = filter (/= '\n') textoPuzzle

pontoPorZero :: Char -> Char
pontoPorZero '.' = '0'
pontoPorZero ch = ch

-- ---------------------------------------------------------------------------
-- Testes

testesUtils :: [Teste]
testesUtils =
  [ ("comprimento de lista com 3 elementos", comprimento [1, 2, 3 :: Int] == 3)
  , ("comprimento de lista vazia", comprimento "" == 0)
  , ("contem: elemento presente", contem (2 :: Int) [1, 2, 3])
  , ("contem: elemento ausente", not (contem (9 :: Int) [1, 2, 3]))
  , ("semDuplicados: sem repetidos", semDuplicados [1, 2, 3 :: Int])
  , ("semDuplicados: com repetidos", not (semDuplicados [1, 2, 1 :: Int]))
  , ("semDuplicados: lista vazia", semDuplicados ([] :: [Int]))
  , ("diferenca", diferenca [1 .. 5] [2, 4 :: Int] == [1, 3, 5])
  , ("diferenca com lista vazia", diferenca [1, 2 :: Int] [] == [1, 2])
  , ("elementoEm: indice valido", elementoEm 1 "abc" == Just 'b')
  , ("elementoEm: indice fora da lista", elementoEm 3 "abc" == Nothing)
  , ("elementoEm: indice negativo", elementoEm (-1) "abc" == Nothing)
  , ("substituirEm: indice valido", substituirEm 1 'x' "abc" == "axc")
  , ("substituirEm: indice fora da lista", substituirEm 5 'x' "abc" == "abc")
  , ("fatia", fatia 1 2 [1, 2, 3, 4 :: Int] == [2, 3])
  , ("dividir em pedacos de 3", dividir 3 [1 .. 7 :: Int] == [[1, 2, 3], [4, 5, 6], [7]])
  , ("transpor matriz 2x3", transpor [[1, 2, 3], [4, 5, 6 :: Int]] == [[1, 4], [2, 5], [3, 6]])
  , ("transpor lista vazia", transpor ([] :: [[Int]]) == [])
  ]

testesParsing :: [Teste]
testesParsing =
  [ ("lerTabuleiro: puzzle valido", lerTabuleiro textoPuzzle /= Nothing)
  , ("lerTabuleiro: 0 equivale a ponto", lerTabuleiro (map pontoPorZero textoCorrido) == lerTabuleiro textoPuzzle)
  , ("lerTabuleiro: texto com 80 celulas", lerTabuleiro (take 80 textoCorrido) == Nothing)
  , ("lerTabuleiro: texto com 82 celulas", lerTabuleiro (textoCorrido ++ "1") == Nothing)
  , ("lerTabuleiro: carater invalido", lerTabuleiro ('x' : drop 1 textoCorrido) == Nothing)
  , ("lerTabuleiro: texto vazio", lerTabuleiro "" == Nothing)
  , ("celulaDeChar: pista", celulaDeChar '7' == Just (Fixa 7))
  , ("celulaDeChar: vazia", celulaDeChar '.' == Just Vazia)
  , ("celulaDeChar: invalido", celulaDeChar 'a' == Nothing)
  ]

testesAcesso :: [Teste]
testesAcesso =
  [ ("celulaEm: pista", celulaEm (0, 0) puzzle == Just (Fixa 5))
  , ("celulaEm: vazia", celulaEm (0, 2) puzzle == Just Vazia)
  , ("celulaEm: linha fora do tabuleiro", celulaEm (9, 0) puzzle == Nothing)
  , ("celulaEm: coluna negativa", celulaEm (0, -1) puzzle == Nothing)
  , ("posicaoValida: limites", posicaoValida (0, 0) && posicaoValida (8, 8))
  , ("posicaoValida: fora dos limites", not (posicaoValida (9, 0)) && not (posicaoValida (0, -1)))
  , ("linha 0", valoresDe (linha 0 puzzle) == [5, 3, 7])
  , ("coluna 2", valoresDe (coluna 2 puzzle) == [8])
  , ("linha invalida", linha 9 puzzle == [])
  , ( "bloco (0,0)"
    , bloco (0, 0) puzzle
        == [Fixa 5, Fixa 3, Vazia, Fixa 6, Vazia, Vazia, Vazia, Fixa 9, Fixa 8]
    )
  , ("bloco e igual para posicoes do mesmo bloco", bloco (1, 2) puzzle == bloco (0, 0) puzzle)
  , ( "bloco (8,8)"
    , bloco (8, 8) puzzle
        == [Fixa 2, Fixa 8, Vazia, Vazia, Vazia, Fixa 5, Vazia, Fixa 7, Fixa 9]
    )
  , ("bloco de posicao invalida", bloco (9, 9) puzzle == [])
  , ("linhas, colunas e blocos: 9 de cada", map comprimento [linhas puzzle, colunas puzzle, blocos puzzle] == [9, 9, 9])
  , ("primeiro bloco de blocos", take 1 (blocos puzzle) == [bloco (0, 0) puzzle])
  , ("celulasVazias do puzzle: 51", comprimento (celulasVazias puzzle) == 51)
  , ("celulasVazias: primeira posicao", take 1 (celulasVazias puzzle) == [(0, 2)])
  , ("celulasVazias do tabuleiro vazio: 81", comprimento (celulasVazias tabuleiroVazio) == 81)
  , ("celulasVazias da solucao", celulasVazias solucao == [])
  ]

testesRegras :: [Teste]
testesRegras =
  [ ("candidatos em (0,2)", candidatos puzzle (0, 2) == [1, 2, 4])
  , ("candidatos em (4,4): unico", candidatos puzzle (4, 4) == [5])
  , ("candidatos de celula preenchida", candidatos puzzle (0, 0) == [])
  , ("candidatos de posicao invalida", candidatos puzzle (9, 9) == [])
  , ("candidatos no tabuleiro vazio", candidatos tabuleiroVazio (4, 4) == [1 .. 9])
  , ("semConflitos: linha do puzzle", semConflitos (linha 0 puzzle))
  , ("semConflitos: grupo com repetidos", not (semConflitos [Fixa 1, Vazia, Preenchida 1]))
  , ("tabuleiro vazio e bem formado e valido", tabuleiroBemFormado tabuleiroVazio && tabuleiroValido tabuleiroVazio)
  , ("puzzle e valido mas nao resolvido", tabuleiroValido puzzle && not (tabuleiroResolvido puzzle))
  , ("solucao esta resolvida", tabuleiroResolvido solucao)
  , ("tabuleiro sem linhas nao e bem formado", not (tabuleiroBemFormado (Tabuleiro [])))
  , ("valor fora de 1..9 nao e bem formado", not (tabuleiroBemFormado (substituirCelula (0, 2) (Preenchida 10) puzzle)))
  , ("conflito numa linha", not (tabuleiroValido (substituirCelula (0, 2) (Preenchida 5) puzzle)))
  , ( "conflito numa coluna (sem conflito de linha)"
    , let t = substituirCelula (0, 3) (Preenchida 8) puzzle
       in semConflitos (linha 0 t) && not (semConflitos (coluna 3 t)) && not (tabuleiroValido t)
    )
  , ( "conflito num bloco (sem conflito de linha nem coluna)"
    , let t = substituirCelula (1, 1) (Preenchida 8) puzzle
       in semConflitos (linha 1 t)
            && semConflitos (coluna 1 t)
            && not (semConflitos (bloco (1, 1) t))
            && not (tabuleiroValido t)
    )
  ]

testesSubstituir :: [Teste]
testesSubstituir =
  [ ("substituirCelula: coloca valor", celulaEm (0, 2) (substituirCelula (0, 2) (Preenchida 4) puzzle) == Just (Preenchida 4))
  , ("substituirCelula: original nao e alterado", celulaEm (0, 2) puzzle == Just Vazia)
  , ("substituirCelula: valor correto mantem validade", tabuleiroValido (substituirCelula (0, 2) (Preenchida 4) puzzle))
  , ("substituirCelula: posicao invalida", substituirCelula (9, 9) (Preenchida 1) puzzle == puzzle)
  , ("substituirCelula: so uma celula muda", comprimento (celulasVazias (substituirCelula (0, 2) (Preenchida 4) puzzle)) == 50)
  ]

testesRender :: [Teste]
testesRender =
  [ ("mostrarCelula", map mostrarCelula [Vazia, Fixa 5, Preenchida 7] == [".", "5", "7"])
  , ("mostrarLinha da primeira linha", mostrarLinha (linha 0 puzzle) == "5 3 . | . 7 . | . . .")
  , ("mostrarTabuleiro tem 11 linhas", length (lines (mostrarTabuleiro puzzle)) == 11)
  ]

testes :: [Teste]
testes =
  concat
    [ testesUtils
    , testesParsing
    , testesAcesso
    , testesRegras
    , testesSubstituir
    , testesRender
    ]

-- ---------------------------------------------------------------------------

main :: IO ()
main = do
  let falhados = [nome | (nome, ok) <- testes, not ok]
  putStrLn ("Testes executados: " ++ show (length testes))
  case falhados of
    [] -> do
      putStrLn "Todos os testes passaram."
      exitSuccess
    _ -> do
      putStrLn "Testes falhados:"
      mapM_ (putStrLn . ("  - " ++)) falhados
      exitFailure
