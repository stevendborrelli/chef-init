#!/bin/bash 

#bootstrap a minimal chef enviroment
# installs:
#  	chef
#	berkshelf

#reference: http://gettingstartedwithchef.com

DOTCHEF=~/.chef

#Git repo for your cookbooks
REPODIR=~/chef-repo

#Location of ruby install
RUBY_HOME=/opt/chef/embedded 

function set_redhat {
	PLATFORM="redhat"
	PKG_INSTALLER="yum"
	PKG_UNINSTALLER="yum"
 	PKG_INSTALL_ARGS="-y install"
	PKG_UNINSTALL_ARGS="-y remove"	
}
	
function set_ubuntu {
	PLATFORM="ubuntu"
	PKG_INSTALLER="apt-get"
	PKG_UNINSTALLER="dpkg"
 	PKG_INSTALL_ARGS="-y install"
	PKG_UNINSTALL_ARGS="-P"		
}

if  [ -f "/etc/redhat-release" ]; then
	set_redhat 
elif [ -f "/etc/lsb-release" ]; then
	set_ubuntu
fi

#Are we running as root? If not, wrap commands with sudo
function check_root {
	id=`id -u`

	if [ "$id" != 0 ] ; then
		SUDO="sudo"
	else
		SUDO=
	fi

}

function get_chef {
	curl -s -L https://www.opscode.com/chef/install.sh | sudo bash 

}

#set up a base chef recipe directory
function get_base_repo {
	local _dest=$1
	if [ ! -d "${_dest}" ]; then 
		wget http://github.com/opscode/chef-repo/tarball/master
		tar -zxvf master && mv opscode-chef-repo* ${_dest}
		rm -f master opscode-chef-repo* 
	else
		echo "${_dest} already exists, skipping chef-repo copy" 
	fi
}

#configure the .chef/knife.rb file to the location of your cookbook directory
function dotChef_cookbook { 
	local _dir=$1
	local _repodir=$2
	if [ ! -d "$1" ] ; then
		mkdir "$1" && echo "cookbook_path [ '${_repodir}/cookbooks' ]" > "$1"/knife.rb
	else
		echo "${_dir} already exists, skipping knife.rb config" 
	fi 
}

#installs OS packages
function install_packages {
	${SUDO} ${PKG_INSTALLER} ${PKG_INSTALL_ARGS} $@ 
}

#Installs ubuntu build tools 
function install_ubuntu_build {
	install_packages build-essential libxslt1-dev libxml2-dev
}

#Installs rhel build tools 
function install_redhat_build {
	install_packages gcc libxml2 libxml2-devel libxslt libxslt-devel  
}


#Installs gems using the chef embedded ruby
function chef_install_gem {
	local _gem=$1
	gem_opts="--no-ri --no-rdoc"
	${SUDO} ${RUBY_HOME}/bin/gem install ${_gem}  ${gem_opts} 
}

check_root

get_chef
get_base_repo ${REPODIR}
dotChef_cookbook ${DOTCHEF} ${REPODIR}
if [ "$PLATFORM" = "ubuntu" ]; then 
	install_ubuntu_build 
elif [ "$PLATFORM" = "redhat" ]; then
	install_redhat_build
fi
chef_install_gem berkshelf

