#!/bin/bash

ROOT=$(readlink -f $(dirname $0))

PROOT=$ROOT/.proot

PROOT_ARGS="-b $ROOT/nix:/nix -b $ROOT/home:$HOME -w $HOME"

unset LD_LIBRARY_PATH

exec $PROOT $PROOT_ARGS bash $@
