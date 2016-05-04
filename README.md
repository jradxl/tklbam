# tklbam
TurnKey GNU/Linux Backup and Migration agent

Version for Ubuntu 16.04
-- TurnkeyLinux suggest you run on Ubuntu by using a wget commmand, but Ubuntu 16.04 is based on "stretch" and not "jessie" 
   so their command fails.
   This repository includes a modified verion of their install script renamed "ez-apt-install-ubuntu.sh", which 
   fixes this problem by hard-coding in a reference to "stretch" by subsituting "jessie". It also contains some comments as
   I work out what this script does! My version of the script starts with a delete of the repository .list file in /etc/apt/sources.d/ which allows it to be re-run with changed values.
   
-- To Use:

     Either these commands, as root
     
     sudo -i  
     wget -O - -q https://raw.github.com/jradxl/tklbam/master/contrib/ez-apt-install-ubuntu.sh PACKAGE=tklbam /bin/bash
   
     OR

     git clone https://github.com/jradxl/tklbam.git
     and then run sudo ./ez-apt-install-ubuntu.sh from within the clone.
     

WARNING:
     This install adds a TurnkeyLinux repository based on Debian Jessie to your Ubuntu 16.04.
     As far as can see the install only adds Python scripts from TurnkeyLinux's repository so it 
     should be safe. Because of this, my "ez-apt-install-ubuntu.sh" does not install tklbam by default.
     You need to manually type, sudo apt-get install tklbam after the install script finishes.
     You are advised to read the log of what apt-get will do before continuing the install.
    

KEYS:
     There are two. The first is TurnkeyLinux's public APT key for signing their repository. This is coded within 
     "ez-apt-install-ubuntu.sh" and you can ignore it (although the script does allow for some other Key to be used).
     The second is your private API Key, which is generated within your Hub account on TurnkeyLinux's website. This provides a 
     method for the tklbam python scripts to access your Hub account without the need of username and password. Therefore 
     it needs to be kept secure. I got confused at first with APT and API!
     
     You initialise tlkbam with the command, "sudo tklbam init". It will ask for your Hub API-Key.  
     
     
MAKEFILES:
     There are two in this github repository. The first in docs/ is for building the documentation. Add rst2man with 
     "sudo apt-get install python-docutils". You can ignore this makefile, but to aid understanding Tklbam, I have 
     added a PDF of all the Man pages in this directtory, tklbam-all-docs.pdf
     The second is in the root of this repository and is for installing the python scripts in /usr/local/. It is not necessary
     to use this makefile unless you are developing, and if you do the installation will be in precedence to those installed 
     by "ez-apt-install-ubuntu.sh". 
     
     
     
     
     
