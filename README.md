# Nvim-config

Everything you need in a neovim config in my opinion

## Info
This branch includes a slimmer newer neovim config. This has lsp configured again from scratch. Some things are added compared to the old branch and some things have been discarded. The old config will still be available.
node, npm and a clipboard manager won't be installed by this script. Install [NodeJS + npm](https://nodejs.org/en/download) and for clipboard i recommend wl-clipboard if you are on wayland. Search for another clipboard manager if you are on x11.
>[!note]
> C lsp might not work on especially windows. There is a fix for this in the old config but since i don't code in c anymore there is no need to copy the fix right now. Might do later.

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
- `clipboard manager` necessary for copying from / to the clipboard with the `"` register. This is very likely already installed but if you use a distro like arch this might not be on your system.

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
