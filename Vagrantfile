# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

file_to_disk = './vagrant/tmp_large_disk.vdi'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "autodata", primary: true do |node|

    # mount salt required folders
    node.vm.synced_folder "autodata", "/srv/salt-formula/autodata"
    node.vm.synced_folder "vagrant/salt/pillar", "/srv/pillar"
    node.vm.synced_folder "vagrant/salt/root", "/srv/salt"

    node.vm.box = "hashicorp/precise64"
    node.vm.hostname = "autodata"

    node.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "512"]
      v.name = "autodata"
      v.customize ['createhd', '--filename', file_to_disk, '--size', 10 * 1024]
      v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
    end

    node.vm.provision :salt do |salt|

      salt.verbose = true
      salt.minion_config = "vagrant/salt/minion"
      salt.run_highstate = true

    end

  end

end
