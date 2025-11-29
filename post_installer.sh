#!/bin/bash
source setup.settings

main() {
    #perform update
    sudo apt update
    sudo apt upgrade -y
    #install importaint apt packages
    sudo apt install -y build-essential
    sudo apt install -y curl
    sudo apt install -y wget
    sudo apt install -y xclip

    ### Setup Git ###
    echo -e "${CYAN}### Setting up git ###"
    git config --global user.name $GIT_USER_NAME
    git config --global user.email $GIT_USER_EMAIL
    git config --list --global

    script_install "generate_ssh"
    script_install "install_jdk"
    script_install "install_go"
    script_install "install_node"
    script_install "install_utility_apts"
    script_install "install_nvim"
    script_install "install_glance"
    script_install "set_shell_color_scripts"

    ### move scripts to bin ###
    echo -e "${CYAN}Moving scripts to /usr/local/bin"
    sudo cp -a ./bin/. /usr/local/bin/

    echo -e "${CYAN}Installing Nerd fonts"
    install_nerd_font.sh "JetBrainsMono"
    install_nerd_font.sh "IBMPlexMono"

    ### Setup PATH ###
    sudo printf "export PATH=\$PATH:/usr/sbin\n" | tee -a /etc/profile

    ### Run offline installers ###
    echo -e "${CYAN}### Running Offline Installers ###"
    if [ -d "./installers" ]; 
    then
        for file in ./installers/*
        do
            echo "### Installing $file"
            sudo dpkg -i "$file"
        done
    fi

    ### Extracting portable software ###
    echo -e "${CYAN}### Extracting Portable Software to HOME ###"
    if [ -d "./portable" ]; 
    then
        for file in ./portable/*.tar
        do
            echo "### Extracting $file to HOME"
            tar xvf $file -C ~ || echo "extracting $file failed" > /dev/stderr
        done
        for file in ./portable/*.tar.gz
        do
            echo "### Extracting $file to HOME"
            tar xvzf $file -C ~ || echo "extracting $file failed" > /dev/stderr
        done
    fi


    ### Fix if some installs were broken ###
    sudo apt --fix-broken install -y
    sudo apt autoremove -y

    ### TODO check what you want for terminal for now just coppy alacritty conf
    mkdir -p $HOME/.config/alacritty/ && cp ./alacritty/* $_
}

#run install script if set to true in setup.settings
function script_install() {
    local var_name="$1"
    local var_value="${!var_name}"

    if [ "$var_value" = true ]; then
        bash "./setup_scripts/${var_name}.sh"
    fi
}

main
