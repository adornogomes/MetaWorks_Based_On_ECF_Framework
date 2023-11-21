# This function verifies and install a package with Chocolatey
function VerifyAndInstallPackage {
    param(
        [string]$package
    )

    if (-not (Get-Command $package -ErrorAction SilentlyContinue)) {
        Write-Host "$package is not installed. Installing $package..."
        choco install $package -y
        
        if ($?) {
            Write-Host "$package was installed with success."
        } else {
            Write-Host "Error during the instalation of the $package. Verify the error messages returned."
			break
        }
    } else {
        Write-Host "$package is already installed."
    }
}

# Verify and install Chocolatey
if (-not (Test-Path 'C:\ProgramData\chocolatey\choco.exe')) {
    Write-Host "Chocolatey is not installed. Starting the process of installation..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    if ($?) {
        Write-Host "Chocolatey was installed with success."
    } else {
        Write-Host "Error during the instalation of the Chocolatey. Verify the error messages returned."
		break
    }
} else {
    Write-Host "Chocolatey is already installed."
}

# Verify and install Vagrant
VerifyAndInstallPackage 'vagrant'

# Verify and install VirtualBox
VerifyAndInstallPackage 'virtualbox'

# Download the scripts from Github
Invoke-RestMethod -Uri https://raw.githubusercontent.com/adornogomes/MetaWorks_Based_On_ECF_Framework/main/Vagrantfile -OutFile Vagrantfile
Invoke-RestMethod -Uri https://raw.githubusercontent.com/adornogomes/MetaWorks_Based_On_ECF_Framework/main/metaworks_ecf.yml -OutFile metaworks_ecf.yml

# Run vagrant up command
$result = Invoke-Expression -Command "vagrant up"

# Check the exit code of the command
if ($LASTEXITCODE -eq 0) {
    Write-Host "The MetaWorks Pipeline is up and running."
} else {
    Write-Host "vagrant up failed."
}



