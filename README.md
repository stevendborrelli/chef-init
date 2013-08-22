chef-init
=========

Set up a basic chef client, useful for getting started with chef-solo.  

Will also: 

* Install berkshelf gem into chef's embedded ruby. 
* copies the chef-repo dir and points .chef/knife.rb to the chef-repo/cooksbooks directory

Tested on:

	ubuntu1204
	rhel6.3

####Usage:

Quick install:

	curl -s https://raw.github.com/stevendborrelli/chef-init/master/bootstrap.sh | sudo bash

Cloning the repo: 

	git clone https://github.com/stevendborrelli/chef-init.git

Installing chef:
	
	./bootstrap.sh


Uninstalling:
	
	./uninstall_chef.sh 

