## drupal6-grinnell-dev\Vagrantfile
## This Vagrantfile builds a grinnell.dev DRUPAL 6 VM image.

Vagrant.configure("2") do |config|

  ## Configure VMWare Workstation as the provider of choice.
  ## System parameters like available memory and number of CPU cores go here.
     config.vm.provider "vmware_workstation" do |v|
       v.vmx["memsize"] = "1024"
       v.vmx["numvcpus"] = "2"
     end

  ## Give our guest a name.
     config.vm.host_name = "drupal6.grinnell.dev"       ## Attention!

  ## Every Vagrant virtual environment requires a box to build off of.
     config.vm.box = "precise64_vmware"
     config.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"

  ## Configure a public network adapter per DHCP.
     config.vm.network "public_network", :bridge => 'en1: Prompt Me'

  ## A trick to enable effective use of the 'puppet module install...' command
  ## follows.  This from http://stackoverflow.com/questions/17508081/installing-a-puppet-module-from-a-manifest-script/21772457#21772457
  ##
  ## This shell provision creates an /etc/puppet/modules folder BEFORE puppet
  ## is installed, and downloads target puppet modules to prep for puppet.
  #######################################
  ## Attention!  Order IS important here!
  ## This shell provisioning MUST APPEAR BEFORE ANY Puppet PROVISIONING takes place!
  ##
  #     config.vm.provision :shell do |shell|
  #       shell.inline =  "
  #                       [ -d /etc/puppet/modules ] || mkdir -p /etc/puppet/modules;
  #                       ( puppet module list | grep puppetlabs-git ) ||
  #                           puppet module install puppetlabs/git;
  #                      ( puppet module list | grep rafaelfc-pear ) ||
  #                          puppet module install rafaelfc/pear;
  #                      ( puppet module list | grep wget ) ||
  #                          puppet module install leonardothibes/wget;
  #                       chown -R vagrant:vagrant /etc/puppet/modules/*;
  #                       "
  #     end
  ##
  ## The following have been copied into my source control so they no longer need
  ## to be downloaded in this fashion.
  #                      ( puppet module list | grep erikwebb-drush ) ||
  #                          puppet module install erikwebb/drush;  # drush
  #                      ( puppet module list | grep erikwebb-drupal ) ||
  #                          puppet module install erikwebb/drupal; # drupal
  #                      ( puppet module list | grep phpmyadmin ) ||
  #                          puppet module install leonardothibes/phpmyadmin;
  #                      ( puppet module list | grep puppetlabs-stdlib ) ||
  #                          puppet module install puppetlabs/stdlib;

  ## Enable the Puppet provisioner, which will look in manifests
     config.vm.provision :puppet do |puppet|
       puppet.manifests_path = "manifests"
       puppet.manifest_file = "drupal6.pp"               ## Attention!
       puppet.module_path = "modules"
       puppet.options = "--verbose "  # --debug"
     end

  ## Forward guest port 80 to host port 8888 and name mapping
     config.vm.network :forwarded_port, guest: 80, host: 8888

  ## Sync host folders to the guest.
  #  config.vm.synced_folder "webroot/", "/vagrant/webroot/", :owner => "www-data"
  #  config.vm.shared_folder "webroot/", "/var/www/", :owner=> 'vagrant',
  #     :group => "www-data", :mount_options => [ "dmode=755", "fmode=664" ]
end

