# Neovim config

## Installation

- Either install with [dotfiles](https://github.com/fritl/dotfiles) repo and **gnu stow**
- Or git clone this repo into _~/.config/nvim_

## Dependencies

- **Neovim**
- **npm**
- **fzf** to fuzzy find things with telescope live grep won't work without it
- **luarocks** A package manager for lua
- **ripgrep** Recursively search directories
- **nerdfont**
- **git**
- There might be **additional dependencies** that I am not aware of right now.

---

## Installation
This installation guide assumes you have a freshly installed windows machine, but can also be applied to linux
1. Install a nerd font. I like to choose [JetBrainsMonoNerd](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Iosevka.zip). Download the zip file and install all the fonts you want. Select your prefered font in the windows terminal
1. Install [Neovim](https://neovim.io/). This should be quite clear.
1. Install [NodeJS](https://nodejs.org/en). This also installs npm which is required
1. Install [Git](https://git-scm.com/).
1. Install [MinGW](https://github.com/niXman/mingw-builds-binaries/releases).
    <details>
        <summary>How to install</summary>

    1. Download the pre-built package from [GitHub](https://github.com/niXman/mingw-builds-binaries/releases). Usually u want to download the `x86_64-<version>-release-posix-seh-ucrt-...`.
    2. Extract the folder to `C:\mingw64`.
    3. Add the Path `C:\mingw64\bin` to PATH
   </details>

> [!Important]
> In order for this to work you need to rename the `mingw-make.exe` to `make.exe`

6. Clone this repo into the neovim config directory. Usually this is `C:\Users\<Username>\Local\nvim`
    <details>
        <summary>Show code to clone</summary>

    - Powershell
        ```powershell
        git clone  https://github.com/fritl/nvim-config.git $env:LOCALAPPDATA\nvim
        ```
    - CMD
        ```cmd
        git clone  https://github.com/fritl/nvim-config.git %LOCALAPPDATA%\nvim
        ```
    </details>
1. Open neovim
1. You might get an error about telescope fzf. Run `:Lazy build telescope-fzf-native.nvim` in neovim

> [!Note]
> After opening neovim one might think that the colorscheme was not installed or configured properly because the screen is just black. This is simply because the background color is transparent by default. You can press <kbd>\<leader>\<A-t></kbd> which translates to pressing <kbd>Space</kbd> shortly then <kbd>Alt</kbd> and <kbd>t</kbd> at the same time. You can change whether your neovim is transparent when opening by changing the variable `transparent` `config/remap.lua` and changing the variable `opts.transparent_background` in `/config/plugins/catppuccin.lua`


## Todo: List of plugins and keymaps
