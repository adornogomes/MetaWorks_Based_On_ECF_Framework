#!/bin/bash

# Function to verify and install a package with apt-get (Ubuntu) or dnf (Fedora)
VerifyAndInstallPackage() {
    package=$1

    # Check if the system is Ubuntu (based on the presence of /etc/apt/sources.list)
    if [ -f /etc/apt/sources.list ]; then
        if ! dpkg -s "$package" >/dev/null 2>&1; then
            echo "$package is not installed. Installing $package..."
            sudo apt-get update
            sudo apt-get install -y "$package"
            
            if [ $? -eq 0 ]; then
                echo "$package was installed successfully."
            else
                echo "Error during the installation of $package. Check error messages."
                exit 1
            fi
        else
            echo "$package is already installed."
        fi
    # Check if the system is Fedora (based on the presence of /etc/redhat-release)
    elif [ -f /etc/redhat-release ]; then
        if ! rpm -q "$package" >/dev/null 2>&1; then
            echo "$package is not installed. Installing $package..."
            sudo dnf install -y "$package"
            
            if [ $? -eq 0 ]; then
                echo "$package was installed successfully."
            else
                echo "Error during the installation of $package. Check error messages."
                exit 1
            fi
        else
            echo "$package is already installed."
        fi
    else
        echo "Unsupported distribution."
        exit 1
    fi
}

# Verify and install Vagrant based on the distribution
VerifyAndInstallPackage 'vagrant'

# Verify and install VirtualBox based on the distribution
VerifyAndInstallPackage 'VirtualBox'

# Download the scripts from Github
wget https://raw.githubusercontent.com/adornogomes/MetaWorks_Based_On_ECF_Framework/main/Vagrantfile -O Vagrantfile
wget https://raw.githubusercontent.com/adornogomes/MetaWorks_Based_On_ECF_Framework/main/metaworks_ecf.yml -O metaworks_ecf.yml

# Run vagrant up command
vagrant up

# Check the exit code of the command
if [ $? -eq 0 ]; then
    echo "The MetaWorks Pipeline is up and running."
else
    echo "vagrant up failed."
fi
