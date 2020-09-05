#!/bin/bash
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

printf "\nUpdating...\n\n"
sudo apt update -y

printf "\nUpgrade...\n\n"
sudo apt upgrade

printf "\nRunning with sudo privilages...\n\n"

printf "Installing GIT...\n"
sudo apt install git -y
printf "\nGIT Installed...\n\n"

printf "Installing VS Code...\n"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install code -y
sudo rm packages.microsoft.gpg
printf "\nVS Code Installed... \n\n"

printf "Installing vim...\n"
sudo apt install vim -y
printf "\nVim Installed... \n\n"

printf "Running autoremove...\n"
sudo apt autoremove -y
printf "\nDONE!\n\n"

echo "export PS1='⌚ \t\[\033[0;32m\]\[\033[0m\033[0;32m\] 🧙‍♂️\u\[\033[0;36m\] 💻\[\033[0;36m\]\h 📁\w\[\033[0;32m\] $(__git_ps1 "🎸(%s)")\n\[\033[0;32m\]\[\033[0m\033[0;32m\]\[\033[0m\033[0;32m\]🚩\[\033[0m\] '" >> ~/.bashrc
bash

exit
