#!/bin/bash

DOTCHEF=~/.chef

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

function clean_gems {
	[ -f ${RUBY_HOME}/bin/gem ] && ${RUBY_HOME}/bin/gem list --no-version | ${SUDO} xargs ${RUBY_HOME}/bin/gem uninstall -aIx	
}

#clean up everything
function clean_ubuntu {
	if [ -n "$REMOVE_DEPS" ]; then 
		${SUDO} ${PKG_UNINSTALLER} ${PKG_UNINSTALL_ARGS} build-essential git-core libxslt1-dev libxml2-dev
	fi 
	${SUDO} ${PKG_UNINSTALLER} ${PKG_UNINSTALL_ARGS} chef 
}

function clean_redhat {
	if [ -n "$REMOVE_DEPS" ]; then 
		${SUDO} ${PKG_UNINSTALLER} ${PKG_UNINSTALL_ARGS} gcc git libxml2-devel libxslt-devel  libgpg-error-devel libgcrypt-devel
	fi 
	${SUDO} ${PKG_UNINSTALLER} ${PKG_UNINSTALL_ARGS} chef 
}

check_root
clean_gems 

if [ "$PLATFORM" = "ubuntu" ]; then
        clean_ubuntu 
elif [ "$PLATFORM" = "redhat" ]; then
        clean_redhat
fi

