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

5. Add the configured private IP (default `10.100.10.101` to your Host VM):

        10.100.10.101 myapp.localhost.dev

## Trusting the Self-Signed Certificate

By 'trusting' the CA certificate on your Host machine, you will be able to navigate to your app over HTTPS without being nagged by your browser.

1. [Download the CA certificate](https://raw.github.com/apancutt/lampbase/master/files/default/ca.crt)

2. Depending on your Host OS, usually you can just double click this file to add it to your trusted certificates. If not, check Google.

## Using your own CA certificate

Perhaps you already have a CA certificate that you use to self-sign SSL certificates. Or perhaps you're concerned about using publicly-provided keys. Either way, you can create and use your own CA certificates to sign the SSL certificate used by the vhost.

### Generating a CA key/certificate pair

Skip this step if you already have a CA key and certificate.

1. Download the template configuration file:

        $ wget -O openssl.cnf https://raw.github.com/apancutt/lampbase/master/templates/default/openssl.cnf.erb

2. Generate the CA key:

        $ openssl genrsa -out ca.key 4096

3. Create the CA certificate:

        $ openssl req -sha256 -new -x509 -days 36524 -key ca.key -out ca.crt -config openssl.cnf -extensions v3_req_ca -subj "/CN=localhost"

### Provisioning the server with your own CA

1. Create a new local cookbook:

    1. Create the cookbook folders:

            $ mkdir -p lampbase-local/files/default

    2. Create the cookbook Berksfile:

            $ echo 'source "https://supermarket.getchef.com"' > lampbase-local/Berksfile
            $ echo 'metadata' >> lampbase-local/Berksfile

    3. Configure the cookbook metadata:

            $ echo 'name "lampbase-local"' > lampbase-local/metadata.rb
            $ echo 'depends "lampbase"' >> lampbase-local/metadata.rb

    4. Copy your CA key and certificate into the cookbook:

            $ cp /path/to/my/ca.key lampbase-local/files/default/ca.key
            $ cp /path/to/my/ca.crt lampbase-local/files/default/ca.crt

    Note: You could have used `berks cookbook lampbase-local` to have Berkshelf generate the cookbook skeleton for you; but that's too much for what we need here.

2. Add your new cookbook to your application's Berksfile:

        echo 'cookbook "lampbase-local", path: "./lampbase-local"' >> Berksfile

3. Configure the location of the CA files in your Vagrantfile:

        lampbase: {
            app_name: app_name,
            # Configure lampbase to obtain the CA files from your lampbase-local cookbook
            ca_key_file_cookbook: "lampbase-local",
            ca_crt_file_cookbook: "lampbase-local"
        }

4. Build it!

    * From scratch:

            $ vagrant up --provision

    * Existing box:

        You will first need to remove the existing SSL certificates else the provisioner will skip creating SSL certificates.

            $ vagrant ssh
            $ sudo su root -c 'rm -f /etc/apache2/ssl/*'
            $ exit
            $ vagrant reload --provision
