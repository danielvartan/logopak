#!/bin/sh
#
# Build steps for the LogoPak Flatpak.
#
# The steps live here instead of inline in the manifest so that the manifest
# used for local builds and the one submitted to Flathub can differ only in
# how they fetch the sources.
#
# It expects the build directory to hold:
#
#   netlogo/   the extracted NetLogo distribution
#   flatpak/   this repository's flatpak directory
#
# Both manifests arrange for that layout.

set -eu

APP_ID="com.danielvartan.logopak"
PREFIX="/app"
NETLOGO_DIR="${PREFIX}/opt/netlogo"
SRC="flatpak"

# ------------------------------------------------------------------------- #
# NetLogo distribution
# ------------------------------------------------------------------------- #

mkdir -p "${NETLOGO_DIR}"
cp -r netlogo/. "${NETLOGO_DIR}/"

# The tarball carries an installer meant for a plain Linux system. It has
# nothing to do inside the sandbox.
rm -f "${NETLOGO_DIR}/install.sh"

# ------------------------------------------------------------------------- #
# Commands
# ------------------------------------------------------------------------- #

mkdir -p "${PREFIX}/bin"

for file in HubNetClient BehaviorSearch; do
  ln -sf "${NETLOGO_DIR}/bin/${file}" "${PREFIX}/bin/${file}"
done

# NetLogo and NetLogo 3D go through a launcher that picks the graphical or the
# batch entry point, so that "NetLogo --headless" works from the same command
# name as the graphical one.
install -Dm755 "${SRC}/netlogo-launcher.sh" "${NETLOGO_DIR}/netlogo-launcher.sh"

for name in NetLogo NetLogo3D netlogo netlogo3d; do
  ln -sf "${NETLOGO_DIR}/netlogo-launcher.sh" "${PREFIX}/bin/${name}"
done

ln -sf "${NETLOGO_DIR}/bin/HubNetClient" "${PREFIX}/bin/hubnetclient"
ln -sf "${NETLOGO_DIR}/bin/BehaviorSearch" "${PREFIX}/bin/behaviorsearch"

# BehaviorSearch has no --headless flag to switch on, so its batch entry point
# gets its own command.
printf '#!/bin/sh\nexec "%s" "$@"\n' \
  "${NETLOGO_DIR}/behaviorsearch/behaviorsearch_headless.sh" \
  > "${PREFIX}/bin/behaviorsearch-headless"
chmod 755 "${PREFIX}/bin/behaviorsearch-headless"

# Expose the bundled JDK, so that NetLogo's own shell launchers and any script
# the user points at them find a JVM.
ln -sf "${NETLOGO_DIR}/lib/runtime/bin/java" "${PREFIX}/bin/java"

# ------------------------------------------------------------------------- #
# Desktop integration
# ------------------------------------------------------------------------- #

for app in NetLogo NetLogo3D HubNetClient BehaviorSearch; do
  install -Dm644 "${SRC}/desktop/${APP_ID}.${app}.desktop" \
    "${PREFIX}/share/applications/${APP_ID}.${app}.desktop"
  install -Dm644 "${SRC}/icons/${app}-512x512.png" \
    "${PREFIX}/share/icons/hicolor/512x512/apps/${APP_ID}.${app}.png"
done

# The catalogue entry is built from the NetLogo desktop file, so its icon is
# also installed under the bare app ID.
install -Dm644 "${SRC}/icons/NetLogo-512x512.png" \
  "${PREFIX}/share/icons/hicolor/512x512/apps/${APP_ID}.png"

# File type icons and definitions.
install -Dm644 "${SRC}/icons/Model-512x512.png" \
  "${PREFIX}/share/icons/hicolor/512x512/mimetypes/${APP_ID}.model.png"
install -Dm644 "${SRC}/icons/BehaviorSearchModel-512x512.png" \
  "${PREFIX}/share/icons/hicolor/512x512/mimetypes/${APP_ID}.behaviorsearch.png"
install -Dm644 "${SRC}/${APP_ID}.xml" \
  "${PREFIX}/share/mime/packages/${APP_ID}.xml"

install -Dm644 "${SRC}/${APP_ID}.metainfo.xml" \
  "${PREFIX}/share/metainfo/${APP_ID}.metainfo.xml"

# ------------------------------------------------------------------------- #
# Licenses
# ------------------------------------------------------------------------- #

install -Dm644 "${SRC}/licenses/NetLogo-COPYING.txt" \
  "${PREFIX}/share/licenses/${APP_ID}/NetLogo-COPYING.txt"
install -Dm644 "${SRC}/licenses/NOTICE.txt" \
  "${PREFIX}/share/licenses/${APP_ID}/NOTICE.txt"

# ------------------------------------------------------------------------- #
# Desktop.Action.BROWSE fix
# ------------------------------------------------------------------------- #

# Build the Java agent that restores Desktop.Action.BROWSE support. JDK 17
# removes BROWSE from XDesktopPeer.supportedActions because GVfs inside the
# Flatpak only reports "file"/"resource" URI schemes, not "http". The agent
# uses reflection to add BROWSE back after init completes.
#
# It is compiled here with the same JDK version that NetLogo bundles, so the
# shipped jar can never be a stale or truncated binary.
. /usr/lib/sdk/openjdk17/enable.sh

mkdir -p browse-fix/classes
javac -d browse-fix/classes "${SRC}/BrowseFix.java"
printf 'Premain-Class: BrowseFix\n' > browse-fix/manifest.txt
jar --create --file browse-fix/browse-fix.jar \
  --manifest browse-fix/manifest.txt -C browse-fix/classes .

# Fail the build here instead of shipping a jar the JVM cannot open.
jar --list --file browse-fix/browse-fix.jar

install -Dm644 browse-fix/browse-fix.jar "${NETLOGO_DIR}/lib/app/browse-fix.jar"

# Attach the agent to the graphical launchers. The path is written as
# $APPDIR/browse-fix.jar (jpackage expands it at launch) instead of an absolute
# /app path: a -javaagent that cannot be resolved aborts the JVM before it
# starts, so the option must stay valid wherever the app image is mounted
# (flatpak-builder build dir, `flatpak build` shell, bundle).
for cfg in "${NETLOGO_DIR}"/lib/app/*.cfg; do
  printf '\njava-options=-javaagent:$APPDIR/browse-fix.jar\n' >> "${cfg}"
  printf 'java-options=--add-opens\n' >> "${cfg}"
  printf 'java-options=java.desktop/sun.awt.X11=ALL-UNNAMED\n' >> "${cfg}"
done
