#!/bin/bash -e
# script adds the correct apt source and installs package
# Author: Liraz Siri <liraz@turnkeylinux.org>
##
# Modified: John Radley <jradxl AT gmail DOT com>
#  For use with Ubuntu 16.04
#  See https://github.com/jradxl/tklbam
##

if [ -n "$1" ]; then
    PACKAGE="$1"
fi

if [ -n "$2" ]; then
	APT_KEY="$2"
fi

if [ -z "$PACKAGE" ]; then
    cat<<EOF
Syntax: $0 <package>
Script adds an apt source if needed and installs a package
Environment variables:

    PACKAGE      package to install
    APT_URL      apt source url (default: $APT_URL)
    APT_KEY      apt source key (default: $APT_KEY)
EOF
    exit 1
fi

##
# A APT-KEY can be added on the command line.
# Now I understand the script a bit better, it's not really necessary.
##
if [ -z "$APT_KEY" ]; then
   set ${APT_KEY:=A16EB94D}
fi

set ${APT_URL:="http://archive.turnkeylinux.org/debian"}

error() {
    1>&2 echo "error: $1"
    exit 1
}

##
# For Ubuntu 16.04, get_debian_dist() has been modified to convert
# "stretch" to "jessie"
##
get_debian_dist() {
    case "$1" in 
        6.*) echo squeeze ;;
        7.*) echo wheezy ;;
        8.*) echo jessie ;;
        stretch/*) echo jessie ;;
        */*) echo $1 | sed 's|/.*||' ;;
    esac
}

##
# If $APT_URL is already present in apt sources, then remove file.
# Needed when running this script multiple times to remove a faulty entry
##
if  rgrep . /etc/apt/sources.list* | sed 's/#.*//' | grep -q $APT_URL; then
  apt_name=$(echo $APT_URL | sed 's|.*//||; s|/.*||')
  apt_file="/etc/apt/sources.list.d/${apt_name}.list"
  rm $apt_file
fi

##
# This will always run
# For Ubuntu 16.04, get_debian_dist() has been modified to convert
# "stretch" to "jessie"
##
if ! rgrep . /etc/apt/sources.list* | sed 's/#.*//' | grep -q $APT_URL; then

    [ -f /etc/debian_version ] || error "not a Debian derived system - no /etc/debian_version file"

    apt_name=$(echo $APT_URL | sed 's|.*//||; s|/.*||')
    apt_file="/etc/apt/sources.list.d/${apt_name}.list"
    debian_dist=$(get_debian_dist "$(cat /etc/debian_version)")
    echo "Distribution used is $debian_dist"
    echo "deb $APT_URL $debian_dist main" > $apt_file

    ##
    # Look up the Public Key. 
    # If trying manually from website pgpkeys.mit.edu, you need
    # to prepend 0x, thus 0xA16EB94D
    ##
    echo "+ apt-key adv --keyserver pgpkeys.mit.edu --recv-keys $APT_KEY"
    apt-key adv --keyserver pgpkeys.mit.edu --recv-keys $APT_KEY

    echo
    echo "Added $APT_URL package source to $apt_file"
fi

##
# As usual, update the reposiiories
##
#set -x
echo
echo "apt-get update..."
apt-get update

##
#I don't know what this does, so commented out!
#You need to explicitally run the tklbam install yourself
##
#if 0>&2 tty > /dev/null; then
#    0>&2 apt-get install $PACKAGE
#else
#    echo "To finish execute this command:"
#    echo 
#    echo "    apt-get install $PACKAGE"
#    echo
#fi

#set +x

echo 
echo 
echo "Warning: A Debian Jessie repository has been added."
echo " ** Read carefully the log of what apt-get install will do. **"
echo 
echo "To finish execute this command:"
echo 
echo "    sudo apt-get install $PACKAGE"
echo

