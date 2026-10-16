# Nvim-config

Everything you need in a neovim config in my opinion

## Info
This branch includes a slimmer newer neovim config. This has lsp configured again from scratch. Some things are added compared to the old branch and some things have been discarded. The old config will still be available.
>[!note]
> C lsp might not work on especially windows. There is a fix for this in the old config but since i don't code in c anymore there is no need to copy the fix right now. Might do later.

## Custom commands
- `:LightMode` — toggles between catppuccin **mocha** (dark) and **latte** (light)
- `:ToggleTransparency` — toggles catppuccin's transparent background on/off
- `:DBERD <schema>` — generates an ER diagram (Mermaid) from the current PostgreSQL connection and opens it in the browser. Also writes a raw `.mmd` file to `~/.local/share/nvim/erd/` that you can render offline with e.g. `mmdc` or any mermaid renderer

## SQL
SQL is handled by [vim-dadbod](https://github.com/tpope/vim-dadbod) plus [dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui) and [dadbod-completion](https://github.com/kristijanhusak/vim-dadbod-completion).
- Requires the `psql` CLI (package `postgresql-client` / `postgresql-libs`).
- Connections are stored in a gitignored `lua/dbs.lua` — copy `dbs.lua.example` and fill in your URLs. Credentials never enter the repo.
- Each SQL buffer remembers its own connection, so multiple lesson files can use different databases at once.
- **Schema selection (DBeaver-style):** each `psql` execution is a fresh session, so a `SET search_path` in one query won't persist to the next. The workaround that *does* persist: put the schema in the connection URL (`?options=-csearch_path%3Dmyschema`) and add one `lua/dbs.lua` entry per schema. Pick it per-buffer with `<leader>dc` — SQL completion for unqualified names follows the same search_path. Alternatively just qualify names (`schema.table`) or run `SET search_path` in the same execution as the query that needs it.
- Queries in a file are separated by blank lines, so "query around cursor" is just paragraph selection.
- Completion in SQL buffers is schema-aware (tables/columns from the live connection), provided by blink.cmp through dadbod-completion.
- Queries are never executed on save (`db_ui_execute_on_save = 0`); execution is always explicit. Saving only formats (via conform → sqlfluff, `dialect` from the local `.sqlfluff` / `pyproject.toml` if present).

### SQL keymaps (buffer-local in SQL files)
- `<leader>dc` — pick the connection for this buffer
- `<leader>dx` — execute query around cursor (blank-line separated); in visual mode executes the selection
- `<leader>dX` — execute whole file
- `<leader>dE` — generate the ER diagram (`:DBERD`)
- `<leader>du` — toggle the database UI sidebar

## Formatting
Formatting happens automatically on every save (`BufWritePre`) and is handled by [conform.nvim](https://github.com/stevearc/conform.nvim).
- Every filetype is formatted (including those without an entry in `conform.lua` via the LSP fallback).
- Formatters run as real binaries, so **local project configs are respected**: `.prettierrc` / `.editorconfig` (prettierd), `rustfmt.toml`, `.clang-format`, `pyproject.toml` (ruff), `.stylua.toml`, etc.
- Formatter binaries are installed through Mason (`ensure_installed` in `lsp/mason.lua`).

## Installation

If you are lazy you can use the install.sh script. It will check for missing dependencies. Try to install missing dependencies. Backup your old neovim config and install the new one.
Either with wget
```bash
bash <(wget -qO- https://raw.githubusercontent.com/fritl/nvim-config/refs/heads/slim/install.sh)
```
or with curl
```bash
bash <(curl -s https://raw.githubusercontent.com/fritl/nvim-config/refs/heads/slim/install.sh)
```
>[!NOTE]
> The script is only compatible with pacman (arch linux) and apt (debian based distros)

>[!NOTE]
>node, npm and a clipboard manager won't be installed by this script. Install [NodeJS + npm](https://nodejs.org/en/download). For clipboard manager I recommend wl-clipboard if you are on wayland. Search for another clipboard manager if you are on x11.
>The script also won't install a nerd font. I recommend [JetBrainsMono Nerd Font](https://www.programmingfonts.org/#jetbrainsmono). But feel free to choose any [Nerdfont](https://www.nerdfonts.com/)
### Prerequisites

**Important dependencies** Things that neovim won't work at all without
- `Neovim >= 0.11.0`
- `Git`
- `C compiler` (for example gcc)
- `Node`
- `make`
> [!note]
> If you have mingw installed on windows. You have to rename make. It probably is called
> mingw-64_make.exe.  

**Dependencies** If you don't have this installed the config might work but might break in the future if you want to install lsp servers using mason.
- `python`
- `pip`
- `luarocks`
- `tree-sitter-cli`

**Recommended** Things that are not really necessary but will give you more features / performance
- `Nerd font` (I recommend [JetBrainsMono Nerd Font](https://www.programmingfonts.org/#jetbrainsmono)) This is needed for displaying icons
- `ripgrep` for live grep with telescope
- `fd` finder used by telescope probably improves performance
- `pylatexenc` used by render-markdown.nvim to transform latex strings to appropriate unicode using latex2text
- `clipboard manager` necessary for copying from / to the clipboard with the `"` register. This is very likely already installed but if you use a distro like arch this might not be on your system.\


Packages in this category below this point are not yet in the install script and need to be installed manually.
- If you want jupyter notebook support via [Jupynium](github.com/kiyoon/jupynium.nvim/) you need to install some additional things
  - `firefox` Only firefox provides the special api for this to work
  - `mozilla geckodriver` Might be installed already. Check with `geckodriver -v`
  - `Jupyter Notebook >=6.2, <7`
  - More pip packages
    - `notebook`
    - `nbclassic`
    - `jupyter-console`

**Probably already installed** Things that are very likely already installed on your system
<details>

- `unzip`
- `wget`
- `curl`
- `gzip`
- `tar`
- `bash`
- `sh`
</details>

### Installation
1. Create the nvim config directory. `mkdir -p ~/.config/nvim`
1. Clone this repository into the config folder `git clone --depth 1 https://github.com/fritl/nvim-config.git ~/.config/nvim`
