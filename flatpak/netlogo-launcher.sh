#!/bin/sh
#
# Entry point for the NetLogo and NetLogo 3D commands.
#
# NetLogo ships two ways to start: the jpackage launchers in bin/, which are
# the graphical ones and carry the browse-fix Java agent, and the shell
# launchers in the installation root, which start a plain JVM for batch runs.
#
# This script picks one of them, so a single command name covers both uses:
#
#   NetLogo                                  -> graphical launcher
#   NetLogo --headless --model x --table y   -> batch launcher
#
# A session with no display also goes to the batch launcher, since the
# graphical one has nothing to draw on there.
#
# The script name decides the dimensionality: NetLogo3D (or netlogo3d) runs
# the 3D variant, anything else the 2D one.

set -e

NETLOGO_DIR="/app/opt/netlogo"

case "$(basename "$0")" in
  *3[Dd]) is3d=1 ;;
  *)      is3d=0 ;;
esac

headless=0

if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
  headless=1
fi

for arg in "$@"; do
  if [ "$arg" = "--headless" ]; then
    headless=1
    break
  fi
done

if [ "$headless" -eq 0 ]; then
  if [ "$is3d" -eq 1 ]; then
    exec "${NETLOGO_DIR}/bin/NetLogo3D" "$@"
  else
    exec "${NETLOGO_DIR}/bin/NetLogo" "$@"
  fi
fi

# Drop --headless: it selects the launcher here and means nothing to the batch
# entry point.
has3d=0
remaining=$#

while [ "$remaining" -gt 0 ]; do
  arg="$1"
  shift
  remaining=$((remaining - 1))

  if [ "$arg" = "--3D" ]; then
    has3d=1
  fi

  if [ "$arg" != "--headless" ]; then
    set -- "$@" "$arg"
  fi
done

# --3D is only supplied on behalf of the 3D command name. Whoever passes it
# themselves keeps their own argument, in the position they put it.
if [ "$is3d" -eq 1 ] && [ "$has3d" -eq 0 ]; then
  exec "${NETLOGO_DIR}/netlogo-headless.sh" --3D "$@"
else
  exec "${NETLOGO_DIR}/netlogo-headless.sh" "$@"
fi
