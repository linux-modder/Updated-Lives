## Fedora Respins SIG HowTo Guides and Files Page.

Repo License: GPL v2+ [[ https://www.gnu.org/licenses/gpl.html ]]

Welcome to the Fedora Respins SIG Repo, Here you will find the final work that is used by the SIG Members to provide Community Supported Updated Live ISOs at the regular interval of every even point kernel release  (i.e. 4.9.10 > 4.9.12 > 4.9.14 ... etc)

All Directories have a directory specific README files, please take the few seconds needed to read them.

This Repo is a full suite of the scripts/files you will need to run your own single Updated/Custom ISO or a Personal Infrastruture which is using the same scripts and tools as the Respins SIG and Release Engineering Team.

Some baseline must haves:

* Packages
fedora-kickstarts 

pungi

mock

lorax-lmc-novirt

* Hard Drive Space
~10gb of space for the final ISOs

full set creation WITH source ISO and related pungi bits is ~ 15-20Gb of space

full set WITH source is roughly 42gb of space, if you are hosting several (for example 3) releases like the SIG members do allocate 100gb or more as you will need 42gb for the first set and nearly 10gb for each set of final ISOs therafter.


* Optional Packages
git (for using the git repo for fedora-kickstarts --defaults to pulling the present rawhide version (as of 201703323 this is 27) (if not using the packaged fedora-kickstarts) or if you are usign git packaged stuff for your custom ISOs /remix.

l10n-kickstarts -- for localization ready kickstart files

pykickstart -- provides ksvalidator (cli and gui versions available as of F25) sample invocation:

     user@local-mirror /srv/Livecds/ $ ksvalidator /usr/share/spin-kickstarts/flat-my_custom_kicksstart.ks


Note:  These packages are for more underlying functionality that is NOT needed for a vanilla set of ISOs but for AMI/virtsh uses is needed.
lorax-lmc-templates

lorax-lmc-examples

lorax-lmc-virt


****** Server-Side tracker/seeder ******

If you wish to make this a full suite complete with the seeder and whitelisted tracker you will also need the following:

opentracker-ipv{4,6}

transmission-daemon

transmission


* Now that we have the minimal packages needed installed, you'll need SELinux set to permissive to run the scripts.
   
user@local-mirror /srv/Livecds/ $ setenforce 0 

ALL scripts WILL need you to be root or be run from an account within the wheel group (can use sudo).

The Scripts directory is for those that have their system setup but merely lack or are updating their scripts.

ALL generated ISOs using these scripts are libvirt [[ dnf install @Virtualization ]], Virtualbox sudo dnf install [[ http://download.virtualbox.org/virtualbox/5.1.18/VirtualBox-5.1-5.1.18_114002_fedora25-1.x86_64.rpm  ]] friendly and are tested using both with at least 1gb RAM and 1 cpu.  

The scripts assume /srv/fedora-repo/ and /srv/Livecds/ for torrents and ISO generation respectively.  If these directories do not exist on your infrastructure or are not where you would like to host / build your ISOs/Torrents edit the respective buildmedia.sh or build-torrents.sh prior to running them.


***** SAMPLE INVOCATIONS:  *****

user@local-mirror /srv/Livecds/ $ sudo sh ./pungirun.sh 25 20170301 

user@local-mirror /srv/Livecds/ $ sudo sh ./buildmedia.sh 25 20170301

user@local-mirror /srv/fedora-repo | /srv/Livecds/ $ sudo ./buildtorrents.sh 25 20170301 

** Notes on specific scripts:

 ***** pungirun.sh  ***** 

will create a Fedora-$1-source-$2.iso which will reside at /srv/Livecds/Pungi/25/.../Fedora-$1-source-$2.iso (assuming no changes to script)

pungirun.sh will also generate a sha256sum checksum which we later convert to a sha512sum by re-running sha512sum on ALL the ISOs in the set once they are all generated.

 ***** buildmedia.sh *****
 
Using livemedia-creator this script makes the hybrid ISOs that are becoming the common standard.  Livemedia-creator IS ABLE to make ami and virtinstall images however the script would need editing of the switches used to do this. sha512sum is used here for all ISOs at this phase. Generally at this point the source iso is MANUALLY moved to /srv/Livecds/25/$2/.../ where the other ISOs reside and tehn a final sha512sum is run on the entire directory (including all 7 Updated ISOs and the source ISO. 


 ***** build-torrents.sh *****

This script is normally on the seeder host not the builder but can be on other.  Seeing as the SIG hosts the ISOs on that host in /srv/fedora-repo/F25-Respins this is non standard in regard to the others but is easily changed.  The script runs a for loop through that directory looking for .iso files matching the spin variables (CINN,KDE,LXDE,MATE,XFCE,SOAS,XFCE) and runs transmission-create on them. For those running opentracker this script also outputs the contents of buildfile (default output file for the torrent hashes) to opentracker's whitelist file, all that remains is a manual restart of opentracker.  If you are not running opentracker this will exit with a non fatal error on the attempted move, or you can comment out the last 5 lines of the script.

We have provided a complete opentracker.conf that is ready to accept teh geoipblocks and whitelisted IPs ( ours have been sanitized in this file for dummy values, so please make sure to edit with valid IPs for your uses/environment.
