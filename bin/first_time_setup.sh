#!/bin/bash

# Exit on error
set -e

ROOT=$(readlink -f $(dirname $0)/..)
OVERLAY=$ROOT/overlay

# Setup directories
if [ -d $OVERLAY ]; then
  echo "Attempting to remove old OVERLAY..."
  chmod -R +w $OVERLAY
  rm -rf $OVERLAY
fi
mkdir -p $OVERLAY/nix $OVERLAY/home

# Grab copy of proot (~6MB):
PROOT=$ROOT/bin/proot-x86_64
wget http://static.proot.me/proot-x86_64 -O $PROOT
chmod u+x $PROOT

# Create a bashrc to load nix on entering
# (and clear LD_LIBRARY_PATH we may have inherited)
cat > $OVERLAY/home/.bashrc << EOF
unset LD_LIBRARY_PATH

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
   . ~/.nix-profile/etc/profile.d/nix.sh
   export MANPATH=\$HOME/.nix-profile/share/man:\$MANPATH
fi
EOF

# Okay, do the install:
$ROOT/bin/proot-bash.sh <(curl https://nixos.org/nix/install)

touch $OVERLAY/.done
