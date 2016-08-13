#!/bin/bash

ROOT=$(readlink -f $(dirname $0))

# Grab copy of proot (~6MB):
PROOT=$ROOT/.proot
wget http://static.proot.me/proot-x86_64 -O $PROOT
chmod u+x $PROOT

# Setup directories
mkdir -p $ROOT/nix $ROOT/home

# Create a bashrc to load nix on entering
# (and clear LD_LIBRARY_PATH we may have inherited)
cat > $ROOT/home/.bashrc << EOF
unset LD_LIBRARY_PATH

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
   . ~/.nix-profile/etc/profile.d/nix.sh
   export MANPATH=\$HOME/.nix-profile/share/man:\$MANPATH
fi
EOF

# Okay, do the install:
$ROOT/proot-bash.sh <(curl https://nixos.org/nix/install)
