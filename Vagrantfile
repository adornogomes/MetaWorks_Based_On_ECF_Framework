#########################################################
# This Vagrantfile defines the configuration that will  #
# be used by the virtual machine module (VMM) to        #
# demonstrate the provision of the MetaWorks Pipeline   # 
# Computational Environment through the implementation  #
#  based on the Environment Code-First Framework        #
# #######################################################
Vagrant.configure("2") do |config|
  
  # Define the virtual machine image
  # Ubuntu Bionic 22.04 64 bits
  config.vm.box = "bento/ubuntu-22.04"

  # Define the hostname and the network
  config.vm.define :metaworks_ecf_vmm do |ecf_config|
    ecf_config.vm.hostname = "metaworks-ecf-vmm"
    ecf_config.vm.network :private_network,
                          :ip => "192.168.33.10"

    # Define the Ansible configuration
    ecf_config.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "metaworks_ecf.yml"
        ansible.verbose = "vvv"
    end
	
	# Define the provider (virtualbox), quantity of memory,
	# and how many CPUs will be used on the VM
	config.vm.provider "virtualbox" do |domain|
		domain.memory = 8192
		domain.cpus = 1
	end
  end
end




