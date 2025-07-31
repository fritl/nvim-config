#!/bin/env bash
RED_FG="\033[0;31m"
GREEN_FG="\033[0;32m"
RESET="\033[0;0m"

function get_package_manager(){
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    else
        echo ""
    fi
}

function check_c_compiler(){
    if command -v gcc &> /dev/null; then
        echo 1
    elif command -v cc &> /dev/null; then
        echo 1
    else
        echo 0
    fi
}

function ask_yn(){
    local prompt="${1:-Would you like to continue: }"
    local default=$2

    local options="[y/n]"
    if [[ $default == y ]]; then
        options="[Y/n]"
    elif [[ $default == n ]]; then
        options="[y/N]"
    else
        default=""
    fi
    local reply
    while true; do
        read -rp "$prompt $options" reply
        local reply=${reply,,}
        if [[ $reply == y || $reply == yes ]]; then
            echo y
            return 0
        elif [[ $reply == n || $reply == no ]]; then
            echo n
            return 0
        elif [[ -z $reply &&  -n $default ]]; then
            echo $default
            return 0
        fi
    done
}

function get_missing_dependencies(){
    local -n _missing=$1
    shift

    local deps=("$@")
    _missing=()

    for dep in ${deps[@]}; do
        if declare -F ${dep}_check > /dev/null 2> /dev/null; then
            local exists=$(${dep}_check)
        else
            local exists=$(general_check $dep)
        fi
        if [[ $exists == 1 ]]; then
            echo -e "${GREEN_FG}[X] $dep installed$RESET"
        else
            echo -e "${RED_FG}[X] $dep not installed$RESET"
            missing_dependencies+=($dep)
        fi
    done
}

function install_missing_dependencies(){
    local missing_deps=("$@")
    for dep in ${missing_deps[@]}; do
        echo "Installing $dep..."
        if declare -F ${dep}_install > /dev/null 2> /dev/null; then
            ${dep}_install
        else
            general_install $dep
        fi
        if [[ $? == 0 ]]; then
            echo -e "${GREEN_FG}Installation of $dep successful$RESET"
        else
            echo -e "${RED_FG}Installation of $dep failed. Please install manually$RESET"
        fi
    done
}

#---
# Functions for checking if a package is isntalled
function general_check(){
    if command -v $1 > /dev/null 2>&1; then
        echo 1
    else
        echo 0
    fi
}

function c_compiler_check(){
    if command -v gcc> /dev/null 2>&1; then
        echo 1
    elif command -v cc> /dev/null 2>&1; then
        echo 1
    else
        echo 0
    fi
}

function venv_check(){
    python3 -m venv --help > /dev/null 2> /dev/null && echo 1 || echo 0
}

function ripgrep_check(){
    general_check rg
}

function fd_check(){
    if [[ $PACKAGE_MANAGER == apt ]]; then
        dpkg -s fd-find > /dev/null 2> /dev/null && echo 1 || echo 0
    else
        general_check fd
    fi
}

function pylatexenc_check(){
    general_check latex2text
}

function clipboard_manager_check(){
    if [[ -n $WAYLAND_DISPLAY ]]; then
        if [[ $(general_check wl-copy) == 1 || $(general_check  wayclip) == 1 ]]; then
            echo 1
            return 0
        fi
    fi

    if [[ -n $DISPLAY ]]; then
        if [[ $(general_check xsel) == 1 || $(general_check xclip) == 1 ]]; then
            echo 1
            return 0
        fi
    fi

    if [[ -n $TMUX ]]; then
        if [[ $(general_check tmux) == 1 ]]; then
            echo 1
            return 0
        fi
    fi

    if [[ $(general_check lemonade) == 1 || $(general_check doitclient) == 1 || $(general_check termux) == 1 ]]; then
        echo 1
        return 0
    fi
    echo 0
}
#---
# Functions for installing a package

function general_install(){
    if [[ $PACKAGE_MANAGER == apt ]]; then
        sudo apt -qy install $1
    elif [[ $PACKAGE_MANAGER == pacman ]]; then
        sudo pacman -Syy $1 --noconfirm
    fi
    return $?
}
function fd_install(){
    if [[ $PACKAGE_MANAGER == apt ]]; then
        sudo apt -qy install fd-find
    elif [[ $PACKAGE_MANAGER == pacman ]]; then
        sudo pacman -Syy fd
    fi
}

function node_install(){
    echo "Node can currently not be installed automatically. Please install manually and continue." >&2
    return 1
}

function npm_install(){
    echo "npm can currently not be installed automatically. Please install manually and continue." >&2
    return 1
}

function tree-sitter_install(){
    sudo npm install -g tree-sitter-cli
    if [[ $? != 0 ]]; then
        npm install -g tree-sitter-cli
    fi
}

function pylatexenc_install(){
    if [[ $PACKAGE_MANAGER == apt ]]; then
        sudo apt -qy install python3-pylatexenc
    elif [[ $PACKAGE_MANAGER == pacman ]]; then
        sudo pacman -Syy python-pylatexenc
    fi
}

function clipboard_manager_install() {
    echo -e "${RED_FG}You have to install a clipboard manager yourself!$RESET"
}

function lua_install(){
    if [[ $PACKAGE_MANAGER == apt ]]; then
        sudo apt install lua5.1 
    elif [[ $PACKAGE_MANAGER == pacman ]]; then
        sudo pacman -S lua51
    fi
}

function c_compiler_install() {
    general_install gcc
}

function venv_install(){
    if [[ $PACKAGE_MANAGER == apt ]]; then
        sudo apt install python3-venv
    fi
}

#---
PACKAGE_MANAGER=$(get_package_manager)
dependencies=("unzip" "wget" "curl" "gzip" "tar" "sh" "git" "c_compiler" "nvim" "node" "npm" "make" "python3" "pip" "venv" "lua" "luarocks" "tree-sitter" "ripgrep" "fd" "pylatexenc" "clipboard_manager")
missing_dependencies=()

# If no package manager was found
if [[ -z $PACKAGE_MANAGER ]]; then
    echo -e "${RED_FG}Only apt and pacman are currently supported by this script. The installer might not detect missing dependencies correctly${RESET}"
elif [[ $(ask_yn "$PACKAGE_MANAGER found. Is this the package manager you use?" y) == n ]]; then
    PACKAGE_MANAGER=""
    echo "${RED_FG}Only apt and pacman are currently supported by this script. The installer might not detect missing dependencies correctly${RESET}"
fi

get_missing_dependencies missing_dependencies ${dependencies[@]}
if [[ -n $missing_dependencies ]]; then
    echo "${#missing_dependencies[@]} missing dependencies."
        echo "${missing_dependencies[@]}"
        if [[ $(ask_yn "Should the script try to automatically install those missing dependencies" y) == n ]]; then
            echo "Please install the missing dependencies yourself"
            exit 1
        fi
        install_missing_dependencies ${missing_dependencies[@]}
        echo "Checking missing dependencies again"
        get_missing_dependencies missing_dependencies ${dependencies[@]}
        if [[ -n $missing_dependencies ]]; then
            echo -e "${RED_FG}Error. Could not install all dependencies. Please review and install missing dependencies manually$RESET"
        fi
fi

if [[ -n $missing_dependencies ]]; then
    if [[ $(ask_yn "Not all dependencies installed. Install config anyway" n) == n ]]; then
        exit 0
    fi
else
    echo "All dependencies installed"
fi

if [[ -n $(ls ~/.config/nvim/) ]]; then
    if [[ $(ask_yn "There seems to already be a config installed on your system. Should it be backuped? Otherwise it will be overwritten." y) == y ]]; then
        mv ~/.config/nvim ~/.config/nvim.bak
    fi
fi
echo "Installing new config"
rm -rf ~/.config/nvim
mkdir -p ~/.config/nvim
git clone https://github.com/fritl/nvim-config.git ~/.config/nvim --depth 1 --branch slim
exit 0
