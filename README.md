# Sudoku em Haskell

Trabalho prático de Programação Funcional (UTAD) — **Fase 1: modelação e núcleo funcional**.

Aplicação em Haskell para trabalhar com tabuleiros de Sudoku 9x9: representar um
puzzle, consultar linhas, colunas e blocos, calcular os valores possíveis de cada
célula e validar o tabuleiro.

> Grupo: _preencher com os nomes e números dos elementos_

## Estado do projeto

| Fase | Objetivo | Estado |
|------|----------|--------|
| 1 | Modelação e núcleo funcional | **Esta versão** |
| 2 | Jogadas com `Either`, *solver* com *backtracking*, pipelines e estatísticas | Por fazer |
| 3 | Menu em terminal, guardar/carregar jogo, gerador de puzzles, relatório | Por fazer |

## Requisitos

- GHC 9.2 ou superior e `cabal` 3.x (por exemplo, instalados com [GHCup](https://www.haskell.org/ghcup/)).
- Não há dependências além da biblioteca `base`.

## Compilar, executar e testar

Na raiz do projeto:

```bash
cabal build          # compilar
cabal run sudoku     # executar a demonstração (lê data/puzzle_facil.txt)
cabal test           # executar os testes
```

A demonstração tem de ser executada a partir da raiz do projeto, porque lê o
ficheiro `data/puzzle_facil.txt` com um caminho relativo.

## Estrutura

```
sudoku/
├── README.md
├── cabal.project
├── sudoku.cabal
├── src/
│   ├── Model.hs      -- tipos de dados e constantes do domínio
│   ├── Utils.hs      -- funções recursivas genéricas sobre listas
│   ├── Board.hs      -- regras do tabuleiro (funções puras)
│   ├── Parsing.hs    -- leitura de texto para Tabuleiro
│   └── Render.hs     -- Tabuleiro para texto
├── app/
│   └── Main.hs       -- demonstração (único módulo com IO)
├── test/
│   └── Spec.hs       -- testes sem dependências externas
└── data/
    ├── puzzle_facil.txt     -- puzzle com 30 pistas
    ├── resolvido.txt        -- o mesmo puzzle, resolvido
    └── invalido_linha.txt   -- puzzle com um valor repetido numa linha
```

## Modelo de domínio

```haskell
data Celula = Vazia | Fixa Int | Preenchida Int   -- pista, ou valor do jogador
type Posicao = (Int, Int)                          -- (linha, coluna), de 0 a 8
newtype Tabuleiro = Tabuleiro [[Celula]]
data Jogada = Jogada Posicao Int                   -- usada na Fase 2
data Erro = ForaDosLimites | CelulaFixa | ValorInvalido
          | ConflitoLinha | ConflitoColuna | ConflitoBloco
          | FormatoInvalido                        -- usado na Fase 2
```

`Fixa` e `Preenchida` distinguem as pistas do puzzle dos valores colocados pelo
jogador, para que, a partir da Fase 2, as pistas não possam ser alteradas.

## Funcionalidades da Fase 1

- **Acesso**: `linha`, `coluna`, `bloco`, `celulaEm`, `linhas`, `colunas`, `blocos`.
- **Células vazias**: `celulasVazias` devolve as posições por preencher.
- **Candidatos**: `candidatos` devolve os valores que ainda se podem colocar numa
  célula vazia (os que não aparecem na sua linha, coluna nem bloco).
- **Validação**: `tabuleiroBemFormado`, `tabuleiroValido` (sem repetidos) e
  `tabuleiroResolvido` (válido e sem células vazias).
- **Atualização**: `substituirCelula` devolve um novo tabuleiro; o original não muda.
- **Leitura e apresentação**: `lerTabuleiro` (81 caracteres, `.` ou `0` para vazio)
  e `mostrarTabuleiro`.

## Decisões de conceção

- **Núcleo puro, IO nas extremidades.** Só `app/Main.hs` faz IO. Todos os módulos
  em `src/` são funções puras, o que facilita os testes.
- **Recursão explícita.** Nesta fase, as funções sobre listas (`comprimento`,
  `semDuplicados`, `transpor`, etc.) estão definidas por recursão e *pattern
  matching* em `Utils.hs`. Nas fases seguintes serão substituídas por funções de
  ordem superior (`map`, `filter`, folds) onde isso simplificar o código.
- **Funções totais.** Em vez de usar `!!` (que pode falhar), os acessos usam `Maybe`
  (`celulaEm`, `elementoEm`) ou devolvem uma lista vazia (`linha`, `bloco`) quando o
  índice é inválido.
- **Lista de listas** como representação do tabuleiro: é simples e suficiente para
  esta UC. Pode ser reavaliada se o desempenho do *solver* o exigir.

## Testes

`test/Spec.hs` cobre as funções de `Utils`, `Parsing`, `Board` e `Render`, incluindo
casos limite (índices fora do tabuleiro, texto com 80 ou 82 células, caracteres
inválidos) e os três tipos de conflito (linha, coluna e bloco).

## Próximos passos (Fase 2)

- `jogar :: Jogada -> Tabuleiro -> Either Erro Tabuleiro`, que rejeita jogadas em
  pistas, fora dos limites ou que criem conflitos.
- *Solver* com *backtracking*, escolhendo a célula com menos candidatos.
- Contagem de soluções e estatísticas do tabuleiro.
- Reforçar a separação entre lógica pura e IO.
