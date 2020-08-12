#!/bin/bash

###############################################################################
#
# Change History 
# July-12-2020 - Emanuel Acosta - Creation
# July-14-2020 - Emanuel Acosta - Added command line flags 
# July-18-2020 - Emanuel Acosta - Set Environment Varible for Anaconda
# August-11-2020 - Emanuel Acosta - Fix Environment variable problem
###############################################################################
###############################################################################
###############################################################################
# Copyright (c) 2020, Emanuel Acosta
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
################################################################################
################################################################################
################################################################################

INSTALL_ANACONDA="False"
USAGE="
This script installs gcc,g++,make,git,python3,and optionally Anaconda.

-A           Anaconda will be installed 
-h           print this help message and exit
"

cd $HOME
## tell bash that it should exit the script if any statement returns a non-true return value
set -e

# get the linux distribution

get_linux_distro(){

        os_release=$(cat /etc/os-release)

        ##Check if it's an ubuntu release
        if echo -e "$os_release" | grep -q "Ubuntu"
        then
                echo -e "Ubuntu"
      
        ##Check if uses yum
        elif echo -e "$os_release" | grep -q "rhel"
        then
                echo -e "Red_Hat"

	else 
		echo -e "Unidientified"
        fi
	return
}


linux_dist=$(get_linux_distro)
if [[ $linux_dist = "Unidientified" ]]
then 
	echo -e "OS could not be identified"
	exit
fi


# Let's parse flags with getopts


while getopts ":hA" opt; do
  case ${opt} in
    h ) # process option h
        echo "$USAGE"
	exit 0
      ;;
    A ) # process option A
        INSTALL_ANACONDA="True"
      ;;
    \? ) echo "Usage: cmd [-h] [-A]"
      ;;
  esac
done

shift $((OPTIND -1))

## update command updates the list of available packages
## and their versions 

## dist-upgrade installs newer versions of the packages and handles
## changing dependincies with newer versions of the packages.

## autoremove will remove dependencies that were installed
## with applications that are no longer used by anything on the system

echo -e "Updating and Upgrading the system \n"
if [[ $linux_dist = "Ubuntu" ]]
then

        sudo apt-get update -y 
	
	sudo apt-get dist-upgrade -y 

	sudo apt-get autoremove -y
elif [[    $linux_dist = "Red_Hat"    ]]
then
	sudo yum update -y

	sudo yum upgrade -y

	sudo yum autoremove -y
fi

## Install The newest version of some essential libraries
## gcc,GNU C libraries,g++, and make

if [[ $linux_dist = "Ubuntu" ]]
then
	echo -e "Installing essential development tools with build-essential"
	echo -e "Latest versions of gcc,g++,make,etc will be installed \n \n"
	sudo apt-get install build-essential -y

elif [[    $linux_dist = "Red_Hat"    ]]
then
        echo -e "Installing essential development tools with /"Development Tools/" Group Install "
        echo -e "Latest versions of gcc,g++,make,etc will be installed \n \n"
	sudo yum groups install "Development Tools" -y

fi



gcc_version=$(gcc --version | head -n 1)
echo -e "\nThe gcc version is"
echo -e $gcc_version

make_version=$(make --version | head -n 1)
echo -e "\nThe version of make is"
echo -e $make_version

gplus_version=$(g++ --version | head -n 1)
echo -e "\nThe version of g++ is"
echo -e $gplus_version


## Next we're going to have to install git

echo -e "\n \ngit will now be installed"
if [[ $linux_dist = "Ubuntu" ]]
then
	sudo apt-get install git -y

elif [[    $linux_dist = "Red_Hat"    ]]
then
	sudo yum install git -y
fi


git_version=$(git --version)
echo -e "\nThe version of git is "
echo -e $git_version


## Need to install python 3
echo -e "\nInstalling python 3\n"
if [[ $linux_dist = "Ubuntu" ]]
then
	sudo apt install python3.8-dev python3-pip -y


elif [[    $linux_dist = "Red_Hat"    ]]
then
	sudo yum install python38-devel.x86_64 -y


fi

if [[ $INSTALL_ANACONDA = "True" ]]
then

## Time to install Anaconda
## We need to make sure we have either wget or curl 



if [[ $linux_dist = "Ubuntu" ]]
then
        sudo apt-get install wget -y
elif [[    $linux_dist = "Red_Hat"    ]]
then
        sudo yum install wget -y
fi



##Anaconda bash script
FILE=Anaconda3-2020.02-Linux-x86_64.sh

## Complete list of hashes can be found at 
## https://docs.anaconda.com/anaconda/install/hashes/all/
HASH="2b9f088b2022edb474915d9f69a803d6449d5fdb4c303041f60ac4aefcc208bb"

# Path to which Anaconda will be installed
PREFIX=${HOME}/anaconda3

wget -v https://repo.anaconda.com/archive/$FILE

## Time to verify data integrity
echo -e "Verifying data integrity. The SHA-256 hash should be "
echo -e $HASH
## Complete list of hashes can be found at 
## https://docs.anaconda.com/anaconda/install/hashes/all/

if sha256sum Anaconda3-2020.02-Linux-x86_64.sh | grep -q $HASH
then
        echo "Hash was OK"
else
        echo "Hash was NOK"
fi

## Explanation of the flags
## -b           run install in batch mode (without manual intervention),
##              it is expected the license terms are agreed upon
##-p PREFIX    install prefix, defaults to $PREFIX, must not contain spaces.
bash $FILE -b -p $PREFIX


## Adding conda to the .bashrc
source $PREFIX/bin/activate
conda init
conda update conda -y --update-all

rm ${FILE}

echo -e "Anaconda Successfully Installed"
echo -e "In order to enable conda related commands please run"
echo -e "source ~/.bashrc \n"



fi

exit 0
