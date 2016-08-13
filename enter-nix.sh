#!/bin/bash

# Exit on error
set -e

ROOT=$(readlink -f $(dirname $0))
OVERLAY=$ROOT/overlay

# Run setup if haven't done so yet
if [ ! -e $OVERLAY/.done ]; then
  echo "Running first-time setup...."
  $ROOT/bin/first_time_setup.sh
  echo "Setup complete, hopefully! Starting shell..."
fi

# Otherwise, start a shell!
$ROOT/bin/proot-bash.sh
