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

export PS1="\[\033[38;5;11m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;46m\]nix\[$(tput sgr0)\]\[\033[38;5;15m\]:\[$(tput sgr0)\]\[\033[38;5;6m\][\w]\[$(tput sgr0)\]\[\033[38;5;15m\]\\$ \[$(tput sgr0)\]"
EOF

# Okay, do the install:
$ROOT/bin/proot-bash.sh <(curl https://nixos.org/nix/install)

touch $OVERLAY/.done
