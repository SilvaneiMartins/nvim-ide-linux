# IDE Neovim para Linux - Arch Linux

Configuracao pessoal do **Neovim** para uso como IDE no **Linux**, com foco em **Arch Linux**. A estrutura e os comandos deste README assumem que o projeto esta instalado em:

```bash
~/.config/nvim
```

A configuracao usa **lazy.nvim** para gerenciar plugins e organiza tudo em modulos Lua dentro de `lua/martins`.

## Recursos

- Dashboard inicial com `alpha-nvim`
- Gerenciador de plugins com `lazy.nvim`
- LSP com `nvim-lspconfig`, `mason.nvim` e `mason-lspconfig.nvim`
- Autocomplete com `blink.cmp` e suporte legado a `nvim-cmp`
- Syntax highlight e indentacao com `nvim-treesitter`
- Busca de arquivos/texto com `telescope.nvim`
- Explorador de arquivos com `nvim-tree.lua`
- Formatacao com `conform.nvim`
- Lint com `nvim-lint`
- Git com `gitsigns.nvim`, `git-blame.nvim` e `lazygit.nvim`
- UI com `lualine.nvim`, `bufferline.nvim`, `noice.nvim`, `notify.nvim` e `which-key.nvim`
- Suporte para Lua, TypeScript/JavaScript, HTML, CSS, Tailwind, Svelte, GraphQL, Prisma, Python, Rust, C/C++, Go e CMake

## Estrutura

```text
~/.config/nvim
├── init.lua
├── lazy-lock.json
├── README.md
└── lua
    └── martins
        ├── core
        │   ├── init.lua
        │   ├── options.lua
        │   ├── keymaps.lua
        │   ├── theme.lua
        │   └── highlights.lua
        ├── lazy.lua
        └── plugins
            ├── alpha.lua
            ├── treesitter.lua
            ├── telescope.lua
            ├── nvim-tree.lua
            ├── formatting.lua
            ├── linting.lua
            ├── lsp
            │   ├── mason.lua
            │   ├── lspconfig.lua
            │   ├── lspsaga.lua
            │   └── rust.lua
            └── ...
```

## Requisitos no Arch Linux

Instale primeiro as dependencias principais do sistema:

```bash
sudo pacman -Syu
sudo pacman -S --needed neovim git base-devel cmake unzip curl wget ripgrep fd nodejs npm python python-pip lazygit
```

Para clipboard no Wayland:

```bash
sudo pacman -S --needed wl-clipboard
```

Para clipboard no X11:

```bash
sudo pacman -S --needed xclip
```

Para icones corretos no terminal, instale e selecione uma Nerd Font no seu emulador de terminal:

```bash
sudo pacman -S --needed ttf-jetbrains-mono-nerd
```

Se voce nao usar Nerd Font, altere em `lua/martins/core/options.lua`:

```lua
vim.g.have_nerd_font = false
```

## Linguagens opcionais

Algumas ferramentas so sao instaladas pelo Mason quando a linguagem existe no sistema.

### Go

Para usar `gopls`, `go.nvim` e ferramentas Go:

```bash
sudo pacman -S --needed go
```

Depois abra o Neovim e rode:

```vim
:MasonInstall gopls
```

Sem o executavel `go` no `PATH`, a configuracao nao tenta instalar `gopls` automaticamente para evitar erro ao abrir o Neovim.

### Rust

Para projetos Rust:

```bash
sudo pacman -S --needed rustup
rustup default stable
```

O `rust-analyzer` pode ser instalado pelo Mason.

### Python

Python ja entra pelo pacote `python`. Servidores e ferramentas como `pyright`, `black`, `isort` e `pylint` sao gerenciados pelo Mason.

Observacao: algumas ferramentas Python ainda podem nao aceitar Python muito novo. Se algum pacote falhar no Mason, confira:

```vim
:MasonLog
```

### C e C++

Para C/C++:

```bash
sudo pacman -S --needed clang
```

O `clangd` e ferramentas relacionadas podem ser instalados pelo Mason.

## Instalacao

Clone o repositorio diretamente para a pasta de configuracao do Neovim:

```bash
git clone git@github.com:SilvaneiMartins/nvim-ide-linux.git ~/.config/nvim
```

Abra o Neovim:

```bash
nvim
```

Na primeira execucao, o `lazy.nvim` sera instalado automaticamente e os plugins serao baixados.

Depois rode:

```vim
:Lazy sync
:MasonUpdate
```

Se quiser instalar manualmente ferramentas comuns:

```vim
:Mason
```

## Arquivos principais

### `init.lua`

Ponto de entrada da configuracao. Tambem ajusta o shell conforme o sistema operacional:

- `cmd.exe` somente no Windows
- `bash` no Linux quando disponivel
- `sh` como fallback

Isso evita erros como:

```text
Process failed to start: no such file or directory: "cmd.exe"
```

### `lua/martins/lazy.lua`

Inicializa o `lazy.nvim`, importa os plugins de `lua/martins/plugins` e configura comportamento global do gerenciador.

### `lua/martins/core/options.lua`

Define opcoes do editor:

- Numeracao relativa e absoluta
- Indentacao com 4 espacos
- Clipboard integrado com o sistema
- `termguicolors`
- `cursorline`
- `undofile`
- Splits abrindo para direita/baixo
- `swapfile` desabilitado
- Flag `vim.g.have_nerd_font`

### `lua/martins/core/keymaps.lua`

Atalhos globais principais:

```text
<Space>         leader
jk              sair do modo insert
<Esc>           limpar highlight da busca
<leader>sv      split vertical
<leader>sh      split horizontal
<leader>sx      fechar split
<C-h/j/k/l>     navegar entre janelas
<leader>to      nova aba
<leader>tx      fechar aba
```

### `lua/martins/plugins/lsp/mason.lua`

Configura:

- `mason.nvim`
- `mason-lspconfig.nvim`
- `mason-tool-installer.nvim`

Instala automaticamente servidores e ferramentas quando as dependencias do sistema existem. Go e CMake recebem tratamento condicional para evitar erros de inicializacao em ambientes incompletos.

### `lua/martins/plugins/lsp/lspconfig.lua`

Configura os servidores LSP, capacidades, diagnostics e keymaps por linguagem.

### `lua/martins/plugins/treesitter.lua`

Configura `nvim-treesitter` na branch `master`, compativel com a API:

```lua
require("nvim-treesitter.configs")
```

Se houver problemas com parsers:

```vim
:TSUpdate
```

### `lua/martins/plugins/alpha.lua`

Dashboard inicial. Usa Nerd Font quando `vim.g.have_nerd_font = true` e fallback simples quando estiver `false`.

### `lua/martins/plugins/telescope.lua`

Configura busca de arquivos, texto, buffers, ajuda e TODOs.

Atalhos principais:

```text
<leader>ff      buscar arquivos
<leader>fg      buscar texto
<leader>fb      buffers abertos
<leader>fh      help tags
<leader>fo      arquivos recentes
<leader>fk      keymaps
<leader>ft      TODOs
```

## Comandos uteis

```vim
:Lazy           gerenciar plugins
:Lazy sync      sincronizar plugins
:Lazy update    atualizar plugins
:Mason          gerenciar LSPs e ferramentas
:MasonLog       ver logs do Mason
:checkhealth    diagnostico geral do Neovim
:TSUpdate       atualizar parsers do Treesitter
```

## Solucao de problemas

### Icones aparecem como quadrados

Instale uma Nerd Font e selecione essa fonte no terminal:

```bash
sudo pacman -S --needed ttf-jetbrains-mono-nerd
```

Ou desative os icones Nerd Font:

```lua
vim.g.have_nerd_font = false
```

### Mason falha ao instalar `gopls`

Instale Go:

```bash
sudo pacman -S --needed go
```

Depois:

```vim
:MasonInstall gopls
```

### Erro com `cmd.exe` no Linux

Verifique se `init.lua` nao esta forcando `vim.o.shell = "cmd.exe"` sem condicao. Nesta configuracao, o shell e definido automaticamente para `bash` no Linux.

### Treesitter nao encontra `nvim-treesitter.configs`

Esta configuracao fixa o `nvim-treesitter` na branch `master`. Se voce atualizar manualmente para `main`, a API antiga pode quebrar.

Para restaurar:

```vim
:Lazy restore nvim-treesitter
```

Ou confira `lua/martins/plugins/treesitter.lua`.

## Atualizacao recomendada

Para atualizar a IDE:

```bash
cd ~/.config/nvim
git pull
nvim
```

Dentro do Neovim:

```vim
:Lazy sync
:MasonUpdate
:checkhealth
```

## Observacoes

Este repositorio e voltado para Linux/Arch Linux. Ele pode funcionar em outras distribuicoes, mas os comandos de instalacao deste README foram escritos para `pacman` e ambiente Linux.
