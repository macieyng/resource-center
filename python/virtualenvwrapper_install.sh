#!/bin/bash
printf "Hello to virtualenvwrapper Install Script\n"
printf "by macieyn - http://github.com/macieyn \n\n"

install () {
    printf "# Begining $1 installation...\n\n"
    sudo apt install $1 -y
    printf "\n\n+ $1 Installation Complete\n"
}

terminate () {
    printf "$1\n"
    printf "Good bye!"
    exit
}

# look for python 3
printf "? Looking for python3\n"
python=$(which python3)

if [ -z $python ]
then
    printf "! python3 is not installed...\n"
    printf "Do you want to install python3? (y/n) \n> "
    read choice
    if [ $choice == 'y' ]
    then 
        install python3
    else
        terminate "Virtualenv can be installed only when you have python3 installed." 
    fi
else
    printf "+ python3 found...\n\n"
fi

# look for pip3
printf "? Looking for python3-pip\n"
pip=$(which pip3)

if [ -z $pip ]
then
    printf "! python3-pip is not installed...\n"
    printf "Do you want to install python3-pip? (y/n) \n> "
    read choice
    if [ $choice == 'y' ]
    then 
        install python3-pip
    else
        terminate "Virtualenv can be installed only when you have python3-pip installed."
    fi
else
    printf "+ python3-pip found...\n\n"
fi


printf "? Looking for virtualenvwrapper\n"
virtualenvwrapper=$(pip3 freeze | grep virtualenvwrapper)
if [ -z $virtualenvwrapper ]
then 
    printf "# Installing virtualenvwrapper and other dependencies...\n"
    pip3 install virtualenvwrapper
    pip3 install virtualenv
    printf "+ Installation complete...\n\n"
else 
    printf "+ virtualenvwrapper found... \n\n"
fi


printf "+ Creating folder for virtualenvs \n"
workon=$(cat ~/.bashrc | grep WORKON_HOME)
if [ -z workon ]
then
    echo "export WORKON_HOME=$HOME/.virtualenvs" >> ~/.bashrc
fi
printf "? Your virtualenvs location: $HOME/.virtualenvs \n\n"


printf "+ Choosing python for virtualenvwrapper \n\n"
virtual_python=$(cat ~/.bashrc | grep VIRTUALENVWRAPPER_PYTHON)
if [ -z virtual_python ]
then
    echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.bashrc
fi

sourcing=$(cat ~/.bashrc | grep "source $HOME/.local/bin/virtualenvwrapper.sh" )
if [ -z virtual_python ]
then
    echo "source $HOME/.local/bin/virtualenvwrapper.sh" >> ~/.bashrc
fi

printf "Sourcing ~/.bashrc... \n\n"
. ~/.bashrc
terminate "Enjoy!"
