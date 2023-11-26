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

VerifyAndInstallVirtualbox7() {
    package='VirtualBox'

    # Check if the system is Ubuntu (based on the presence of /etc/apt/sources.list)
    if [ -f /etc/apt/sources.list ]; then
        if ! dpkg -s "$package" >/dev/null 2>&1; then
            echo "$package is not installed. Installing $package..."
            
            # Install required packages to enable VirtualBox installation
            sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

            # Download and add the Oracle VirtualBox repository key
            curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -

            # Add the VirtualBox repository to your system
            sudo add-apt-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"

            # Update the package lists again to include the VirtualBox repository
            sudo apt-get update

            # Install VirtualBox 7
            sudo apt-get install -y virtualbox-7.0

            # Optionally, you can add a user to the 'vboxusers' group to enable access to USB and other devices
            # Replace 'username' with your actual username
            sudo usermod -aG vboxusers username
            
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
VerifyAndInstallVirtualbox7

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
