# Reproducing Bioinformatics Experiments: A Case Study Using the Environment Code-First Framework

This repository contains the source code produced during our experiments that supported the development of the paper: "Reproducing Bioinformatics Experiments: A Case Study Using the Environment Code-First Framework".
The preprint of the paper can be downloaded from https://www.preprints.org/manuscript/202310.0102/v1

## Abstract

Verifying published findings in bioinformatics through independent validation is challenging, mainly when accounting for differences in software and hardware to recreate computational environments. Reproducing a computational environment that closely mimics the original proves intricate and demands a significant investment of time. In this paper, we present a case study on how a recently proposed reproducibility framework named Environment Code-First (ECF) based on the Infrastructure-as-Code approach can improve the implementation and reproduction of computing environments by reducing complexity and manual intervention. In particular, we detail the steps needed to implement the computational environment of a bioinformatics pipeline named MetaWorks from the perspective of the scientist who owns the research work. Also, we present the steps taken to recreate the environment from the point of view of one who wants to reproduce the published results of a research work. This exercise compares the manual way of implementing the pipeline and the automated method proposed by the ECF framework, showing real metrics regarding time consumption, efforts, manual intervention, and platform agnosticism. 

## Provisioning the MetaWorks Pipeline
By running the available main scripts (Windows and Linux), it is possible to provision the MetaWorks Pipeline.

## How to provision the MetaWorks Pipeline on MS Windows?
Passo-a-passo da instalação do MetaWorks based on ECF Framework:

1. Create a directory in your personal machine, and download the main script for MS Windows (win_metaworks_ecf_main_script.ps1) inside it.

2. Open a Powershell terminal as Administrator and access your new directory. The commands shown in the next steps must be run in this terminal.

3. Execute the main script for MS Windows in the Powershell terminal:

	**win_metaworks_ecf_main_script.ps1**
 
4. The main script will install the package manager Chocolatey, the Vagrant, and the Virtualbox. If the installations are successful, the main script will start Vagrant.

5. Vagrant will create the MetaWorks computational environment defined by following the ECF framework and start the Virtual Machine Module (VMM) that is the basis of this environment.

6. From this point, we can access the environment and run a test in the MetaWorks pipeline:

	6.1 To check if the VMM is running, use the following command:

		> vagrant status

		The following result must be shown:

		The name of the virtual machine that represents the VMM is "metaworks_ecf_vmm".

	6.2 To access the VMM, run the following command:

   		> vagrant ssh metaworks_ecf_vmm

		If the command asks for a password, type vagrant. After this, you will be inside the VMM, a Ubuntu Linux OS.


	6.3 The Container Module (CM) that contains the MetaWorks Pipeline environment is up and running. To check the information about the CM, use the following command:

		$ sudo docker container ps -a

		The following information must be shown:

		vagrant@ecf:~$ sudo docker container ps -a
		CONTAINER ID   IMAGE                           COMMAND       CREATED        STATUS                     PORTS     NAMES
		21a48b73857b   adornogomes/metaworks_ecf:1.0   "/bin/bash"   22 hours ago   Exited (0) 5 seconds ago             metaworks_ecf_container1

		To access the CM, run the following command:

		$ sudo docker attach metaworks_ecf_container1







-------------------------------
Last updated: November 19, 2023
