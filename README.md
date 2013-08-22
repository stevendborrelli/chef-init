chef-init
=========


_(c) Steven Borrelli 2013,  MIT license._

Set up a basic chef client and the berkshelf gem. This is a quick way to started with chef-solo.

The scripts are based on the Introduction at http://gettingstartedwithchef.com.


The script will:

* Install the chef package from opscode.
* Install the `berkshelf` gem into chef's embedded ruby located at `/opt/chef/embedded/` 
* copies the `http://github.com/opscode/chef-repr` dir and points `.chef/knife.rb` to the `~/chef-repo/cooksbooks` directory
* Comes with an uninstall scirpt to remove chef, installed ruby gems and additional packages used to build `berkshelf`. 

Tested on:

	ubuntu1204
	
	rhel6.3

####Usage:

Quick install:

	curl -s https://raw.github.com/stevendborrelli/chef-init/master/bootstrap.sh | sudo bash

Cloning the repo: 

	git clone https://github.com/stevendborrelli/chef-init.git

Installing chef and supporting files:
	
	./bootstrap.sh


Uninstalling chef and berkshelf (the `.chef` and `chef-repo` directories will be untouched):
	
	./uninstall_chef.sh 

If you `export REMOVE_DEPS=true` before running `./uninstall_chef.sh`, it will remove dependent
packages that the `bootstrap.sh` script installed, like `gcc` and `git`. This may break your
build environment. 

