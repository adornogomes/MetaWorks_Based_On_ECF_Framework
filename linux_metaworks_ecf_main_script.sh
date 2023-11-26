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

VerifyAndInstallVirtualbox6() {
    package='virtualBox'

    # Check if the system is Ubuntu (based on the presence of /etc/apt/sources.list)
    if [ -f /etc/apt/sources.list ]; then
        if ! dpkg -l | grep "$package" >/dev/null 2>&1; then
            echo "$package is not installed. Installing $package..."
            
            # Add the following line to your /etc/apt/sources.list
            line_to_add="deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian <mydist> contrib"
            echo "$line_to_add" | sudo tee -a /etc/apt/sources.list > /dev/null

            # Download and register the Oracle public key for verifying the signatures
            wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg

            # Update the package lists again to include the VirtualBox repository
            sudo apt-get update

            # Install VirtualBox 6
            sudo apt-get install -y virtualbox-6.1

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
        if ! rpm -qa | grep "$package" >/dev/null 2>&1; then
            echo "$package is not installed. Installing $package..."
            
            # Download and register the Oracle public key for verifying the signatures
            wget -q https://www.virtualbox.org/download/oracle_vbox.asc
            sudo rpm --import oracle_vbox.asc
            # wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | rpm --import -

            echo "[VirtualBox]" | sudo tee -a /etc/yum.repos.d/virtualbox.repo > /dev/null
            echo "name=Fedora $releasever - $basearch - VirtualBox" | sudo tee -a /etc/yum.repos.d/virtualbox.repo > /dev/null
            echo "baseurl=http://download.virtualbox.org/virtualbox/rpm/fedora/$releasever/$basearch" | sudo tee -a /etc/yum.repos.d/virtualbox.repo > /dev/null
            echo "enabled=1" | sudo tee -a /etc/yum.repos.d/virtualbox.repo > /dev/null
            echo "gpgcheck=1" | sudo tee -a /etc/yum.repos.d/virtualbox.repo > /dev/null
            echo "repo_gpgcheck=1" | sudo tee -a /etc/yum.repos.d/virtualbox.repo > /dev/null
            echo "gpgkey=https://www.virtualbox.org/download/oracle_vbox.asc" | sudo tee -a /etc/yum.repos.d/virtualbox.repo > /dev/null

            # Install VirtualBox 6
             sudo dnf install VirtualBox-6.1 -y
            
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
