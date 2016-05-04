# tklbam
TurnKey GNU/Linux Backup and Migration agent

Version for Ubuntu 16.04
-- TurnkeyLinux suggest you run on Ubuntu by using a wget commmand, but Ubuntu 16.04 is based on "stretch" and not "jessie" 
   so their command fails.
   This repository includes a modified verion of their install script renamed "ez-apt-install-ubuntu.sh", which 
   fixes this problem by hard-coding in a reference to "stretch" by subsituting "jessie". It also contains some comments as
   I work out what this script does!
   
-- To Use:

     Either this command
      
     sudo wget -O - -q https://raw.github.com/jradxl/tklbam/master/contrib/ez-apt-install-ubuntu.sh | PACKAGE=tklbam /bin/bash
   
     OR

     git clone https://github.com/jradxl/tklbam.git
     and then run sudo ./ez-apt-install-ubuntu.sh from within the clone.
     

WARNING:
     This install adds a TurnkeyLinux repository based on Debian Jessie to your Ubuntu 16.04.
     As far as can see the install only adds Python scripts from TurnkeyLinux's repository so it 
     should be safe. Because of this, my "ez-apt-install-ubuntu.sh" does not install tklbam by default.
     You need to manually type, sudo apt-get install tklbam after the install script finishes.
     You are advised to read the log of what apt-get will do before continuing the install.
    
