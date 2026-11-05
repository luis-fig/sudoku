# Sudoku em Haskell

Trabalho prático de Programação Funcional (UTAD) — **Fase 1: modelação e núcleo funcional**.

Grupo: _preencher com os nomes e números dos elementos_

## Como usar

Na raiz do projeto (precisa de GHC e Cabal):

```bash
cabal build         # compilar
cabal run sudoku    # demonstração (lê data/puzzle.txt)
cabal test          # testes
```

## Estrutura

| Ficheiro | Conteúdo |
|---|---|
| `src/Model.hs` | Tipos: `Celula` (`Vazia`, `Fixa`, `Preenchida`), `Posicao`, `Tabuleiro` |
| `src/Board.hs` | Funções puras: acesso a linhas, colunas e blocos, candidatos, validação |
| `src/Parsing.hs` | Leitura de um tabuleiro a partir de texto (81 caracteres) |
| `app/Main.hs` | Demonstração (único módulo com IO) |
| `test/Spec.hs` | Testes |
| `data/` | Puzzle de exemplo e a sua solução |

## O que está feito

- Modelo de domínio com um tipo algébrico próprio (`Celula`), que distingue as pistas do puzzle dos valores do jogador.
- Funções puras: `linha`, `coluna`, `bloco`, `celulaEm`, `celulasVazias`, `substituir`, `candidatos`, `tabuleiroValido`, `tabuleiroResolvido`.
- Recursão explícita em `valoresDe` e `semDuplicados`.
- `Maybe` em `celulaEm` e em `lerTabuleiro`.

## Fases seguintes

- **Fase 2:** jogadas com `Either`, *solver* com *backtracking*, estatísticas.
- **Fase 3:** menu no terminal, guardar e carregar jogo, relatório.
