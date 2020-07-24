#!/bin/sh
if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

printf "Updating...\n\n"
sudo apt update -y

printf "Upgrade...\n\n"
sudo apt upgrade

printf "Running with sudo privilages...\n\n"

printf "Installing GIT...\n"
sudo apt install git -y
printf "GIT Installed...\n\n"

printf "Installing VS Code...\n"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install code -y # or code-insiders
sudo rm packages.microsoft.gpg
printf "VS Code Installed... \n\n"

sudo apt autoremove -y

exit