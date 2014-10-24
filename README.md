# lampbase

A base cookbook for provisioning a base LAMP-stack, primarily suited for local development environments served by Vagrant.

Compatible with RHEL and Debian platform families (including CentOS, Ubuntu and Amazon Linux).

Provides the following software:

* Apache2
* PHP5
* MySQL
* memcached
* Self-signed SSL wildcard certificate

## Vagrant Installation

1. Ensure you have the following dependencies installed:
    * [Vagrant](https://www.vagrantup.com/downloads.html)
    * [Chef-DK](https://downloads.getchef.com/chef-dk/)
    * `vagrant-berkshelf` plugin
    
            $ vagrant plugin install vagrant-berkshelf

    * OPTIONAL: `vagrant-omnibus` plugin (ensures Chef is installed on the Guest OS)
    
            $ vagrant plugin install vagrant-omnibus

        Note: This step is **required** if using a box that does not distribute with Chef.
        
    * OPTIONAL: `vagrant-vbguest` plugin (ensures VirtualBox Guest Additions is up-to-date on the Guest OS)
    
            $ vagrant plugin install vagrant-vbguest

2. Download the template Berksfile and Vagrantfile into your application:

        $ cd path/to/my/app
        $ wget https://raw.github.com/apancutt/lampbase/master/{Vagrantfile,Berksfile}.dist
        $ mv Vagrantfile{.dist,} && mv Berksfile{.dist,}

3. Open `Vagrantfile` and modify set the `app_name` parameter. Feel free to bastardize this file as deemed necessary.

4. Boot your VM:

        $ vagrant up --provision

