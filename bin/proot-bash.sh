#!/bin/bash

# Exit on error
set -e

ROOT=$(readlink -f $(dirname $0)/..)
OVERLAY=$ROOT/overlay

PROOT=$ROOT/bin/proot-x86_64

if [ ! -e $PROOT ]; then
  echo "proot not found, run setup first!"
  exit 1
fi
if [ ! -d $OVERLAY ]; then
  echo "overlay folder not found, run setup first!"
  exit 1
fi

PROOT_ARGS="-b $OVERLAY/nix:/nix -b $OVERLAY/home:$HOME -w $HOME"

unset LD_LIBRARY_PATH

exec $PROOT $PROOT_ARGS bash $@
