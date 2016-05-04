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
     
     
CONFIGURATION:
     The installation of tlkbam will result in the configuration being found in /etc/tklbam/.  
     The configuration file is /etc/tklbam/conf, the overrides are held in /etc/tklbam/overrides and hooks in /etc/tklbam/hooks.d/.
     At present for use on Ubuntu I've not modified these.
     

PROFILES:
     I found this confusing. The profile is stored by default in /var/lib/tklbam/profile/, where your Hub API key is stored in sub_apikey.
     Other keys are in key and secret. The profile itself is stored in profile/, with the id stored in profile_id.
     This profile is designed to identify files and directories required to be backed up, and for the TurnkeyLinux images, and therefore pre-known. 
     The profile is downloaded from the Hub once the user initialises a backup on one of these images.  
     I downloaded and ran "turnkey-nginx-php-fastcgi-14.1-jessie-amd64" in VirtualBox. This name was the profile_id. 
     Other files were 
        packages (containing a list of apt-get packages), such as nginx, nginx-common, nginx-full
        dirindex (probably the state file for the current backup)
        dirindex.conf (containing the directories to be backed up or ignored), such as the following:-
        
        # data
        /opt
        /srv
        /home
        
        /root
        -/root/.cache # duplicity caches by default here
        
        # system minus instance-specific stuff
        /usr/local
        
        /etc
        -/etc/debian_version
        -/etc/turnkey_version
        -/etc/ld.so.cache
        -/etc/apt
        -/etc/resolv.conf
        -/etc/resolvconf
        -/etc/network/interfaces
     
     As TurnkeyLinux's document says, for Ubuntu you need to define this yourself.
     
TurnKeyLinux Hub and Amazon S3:
     This is the intended use of tlkbam. I didn't want to commit myself to Amazon S3, so persevered with to "--solo" option.
     
Running Solo:

     1. You need to create a profile. You cannot use /var/lib/tklbam for this, as this directory is cleared in solo mode.
        I ran all the commands as root, sudo -i
        cd /root
        pluma profile.txt  ## enter directtories you want backed up, one per line. I used /etc and /home. See documentation for excludes
        tklbam-internal create-profile my-custom-profile3 profile.txt
        
        cd /root/my-custom-profile3
        pluma packages  ## and reduced entries to just nginx, nginx-common and nginx-full
        cd /root
        
     2. Initialise the backup system
        cd /root
        tklbam-init --solo --force-profile=my-custom-profile3
        
     3. Carry out a simulated and actual backup to a directory.  
        cd /root
        
        tklbam backup --simulate --address file://mybak3  ## /root/mybak3 was created but was empty
        Console showed log information on the backup.
        The process created /TKLBAM/ containing logs of the backup. Yes, I do mean a directory at root.
        The significant file was newpkgs, which had same as the original packages list, less nginx, nginx-common and nginx-full. 
        (Seems you can't win, and tklbam will always record the lot!)
        
        tklbam backup --simulate --full-backup 1D --address file://mybak3

        tklbam backup --full-backup 1D --address file://mybak3
        tklbam-escrow mybak3.txt  ## and entered a paraphrase
        
        /root/mybak3 had the following contents
        
            -rw-------  1 root root      761 May  5 00:09 duplicity-full.20160504T230908Z.manifest.gpg
            -rw-------  1 root root 26271858 May  5 00:09 duplicity-full.20160504T230908Z.vol10.difftar.gpg
            -rw-------  1 root root 25674887 May  5 00:09 duplicity-full.20160504T230908Z.vol11.difftar.gpg
            -rw-------  1 root root 26213901 May  5 00:09 duplicity-full.20160504T230908Z.vol1.difftar.gpg
            -rw-------  1 root root 26270912 May  5 00:09 duplicity-full.20160504T230908Z.vol2.difftar.gpg
            -rw-------  1 root root 26246389 May  5 00:09 duplicity-full.20160504T230908Z.vol3.difftar.gpg
            -rw-------  1 root root 26254144 May  5 00:09 duplicity-full.20160504T230908Z.vol4.difftar.gpg
            -rw-------  1 root root 26254230 May  5 00:09 duplicity-full.20160504T230908Z.vol5.difftar.gpg
            -rw-------  1 root root 26254192 May  5 00:09 duplicity-full.20160504T230908Z.vol6.difftar.gpg
            -rw-------  1 root root 26254052 May  5 00:09 duplicity-full.20160504T230908Z.vol7.difftar.gpg
            -rw-------  1 root root 26245745 May  5 00:09 duplicity-full.20160504T230908Z.vol8.difftar.gpg
            -rw-------  1 root root 26245148 May  5 00:09 duplicity-full.20160504T230908Z.vol9.difftar.gpg
            -rw-------  1 root root  2898576 May  5 00:09 duplicity-full-signatures.20160504T230908Z.sigtar.gpg

more to follow....

John Radley, 4th May 2016
