#version=DEVEL
repo --name="fedora" --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch --excludepkgs="fedora-productimg-cloud,fedora-productimg-workstation"
repo --name="fedora-source" --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-source-$releasever&arch=$basearch --excludepkgs="fedora-productimg-cloud,fedora-productimg-workstation"
repo --name="amahi" --baseurl=http://f25.amahi.org

# System bootloader configuration
bootloader --location=none

%packages --default

%end
