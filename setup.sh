#!/usr/bin/bash
FIRST_ARG=$1
SECOND_ARG=$2
ALL_ARG=$@
DEF_PATH="$PREFIX/bin"
GRAY="\033[1;90m"
RED="\033[1;91m"
GREEN="\033[1;92m"
YELLOW="\033[1;93m"
BLUE="\033[1;94m"
MAGENTA="\033[1;95m"
CYAN="\033[1;96m"
RESET="\033[1;99M"
set -e
function error_handler()
{ 
     printf "$RED Error happened!"
     exit 1
}

trap error_handler ERR

function display_help()
{
    printf "$GREEN  ### Help Info\n"
    printf "Add any script in path :$MAGENTA $DEF_PATH\n"
    printf "$CYAN The following positional arguments are available...\n$BLUE"
    echo "--help  -h  : Display this help message and exit"
    printf "SCRIPT - Script to be added in path\n"
    printf "PATH-NAME - Script name in path\n"
    exit 0
}

function  add_file_to_path()
{
     NEW_PATH=$DEF_PATH/$SECOND_ARG
     printf "$GREEN Moving '$FIRST_ARG' to '$NEW_PATH'\n"
     cp $FIRST_ARG $NEW_PATH
     printf "$MAGENTA Adding execute permission\n"
     chmod +x $DEF_PATH/$SECOND_ARG
     install_dependencies
     printf "$CYAN Process done successfully!\n"
     exit 0
}

function install_dependencies()
{
    req_file="requirements.txt"
    if [[ -f $req_file ]]; then
       printf "$GREEN Installing dependencies\n"
       pip3 install -r $req_file
    fi
}

function add_python_path()
{
    printf "$YELLOW Installing python  package\n$RESET"
    #pip3 install .
    install_dependencies
    python3 setup.py install
    printf "$GREEN Installation done successfully!\n"
}

if [[ $FIRST_ARG == "--help" || $FIRST_ARG == "-h" ]] then
   display_help
fi

# Install from setup.py 
if [[ -f "setup.py" ]]; then
   add_python_path
   exit 0
fi

# Handles single standalone script
printf "$BLUE"
if [[ -z $FIRST_ARG ]]; then
  read -p "[#] Enter file  name:"  FIRST_ARG
fi
if [[ -z $SECOND_ARG ]]; then
  read -p "[#] Enter PATH name:" SECOND_ARG
fi
add_file_to_path
