# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/). The project also follows [Semantic Versioning](https://semver.org/), [Conventional Branch](https://conventionalbranch.org/), and [Conventional Commits](https://www.conventionalcommits.org/) standards.

## v1.0.0 (2026-08-09)

### Added

- `behaviorsearch-headless` command for BehaviorSearch batch runs.
- `java` command pointing to the JDK that NetLogo bundles.
- `flathub/` directory with the manifest and the `flathub.json` submitted to Flathub, plus the submission instructions.
- NetLogo's license and a packaging notice, installed under `/app/share/licenses`.
- Screenshots, developer, keywords, branding, and help, bug tracker and repository links in the metadata, as Flathub requires.
- `x-checker-data` for the NetLogo source, so that Flathub's external data checker can propose version updates.
- `flathub.json` restricting builds to `x86_64`, the only architecture NetLogo ships a Linux build for.
- A note in the metadata stating that this is an unofficial package, with no affiliation to Northwestern University or the Center for Connected Learning and Computer-Based Modeling.
- `Keywords` entries in the NetLogo and NetLogo 3D desktop files.
- A lint job in the build workflow, running the metadata, desktop file and manifest checks that Flathub applies.

### Changed

- `NetLogo` and `NetLogo3D` now route `--headless` runs, and runs started without a display, to NetLogo's batch launcher, which starts a JVM without the browse fix agent.
- The browse fix is compiled during the Flatpak build with the JDK version that NetLogo bundles, instead of shipping a prebuilt jar.
- `JAVA_HOME` now points to NetLogo's own runtime.
- Updated the runtime to `org.freedesktop.Platform` 25.08.
- Moved the build steps out of the manifest into `flatpak/build.sh`, shared by the local and the Flathub manifests.
- The NetLogo archive now extracts to its own directory, so the packaging files are no longer copied into the installed tree.
- Application icons are now installed under `hicolor/512x512`, matching their actual size.
- Dropped the `Java` category and the portal `--talk-name` from the desktop files and the manifest, which Flathub's linter rejects.
- Dropped the unused `--socket=wayland` permission. The JVM has no Wayland backend, so NetLogo always draws through X11.
- Three dimensional models (`.nlogo3d` and `.nlogox3d`) now have their own file type, `application/x-netlogo-3d`, and open in NetLogo 3D. They used to share a type with two dimensional models, so the desktop could hand them to the application that cannot run them.
- NetLogo's own installer script is no longer shipped, since it has nothing to do inside the sandbox.
- Reworded the summary to "Simulate complex systems", following Flathub's wording rules.
- The build workflow now runs on the `freedesktop-25.08` image and mirrors screenshots the way Flathub does.
- Renamed `NEWS.md` to `CHANGELOG.md`.

### Fixed

- The browse fix agent aborting the JVM with "Error opening zip file or JAR manifest missing". The agent is referenced through jpackage's `$APPDIR` instead of a hardcoded `/app` path.
- NetLogo's shell launchers failing to find a JVM, because the runtime pointed `JAVA_HOME` at a JDK that is not part of it.
- Metadata that failed validation, from a missing developer tag and a deprecated `mimetypes` block.

## v0.3.0 (2026-05-17)

### Added

- Java agent that restores `Desktop.Action.BROWSE` support inside the Flatpak sandbox.

### Changed

- Updated NetLogo to version 7.0.4.
- Updated the documentation.

### Fixed

- "Unable to open a browser" error.
- BehaviorSearch desktop file casing, from `Behaviorsearch`.

## v0.2.0 (2026-01-28)

### Changed

- Changed `app-id` to `com.danielvartan.logopak`, to align with package naming conventions.
- Enhanced the documentation.

### Fixed

- NetLogo display issue in the dashboard.

## v0.1.0 (2026-01-28)

First release! 🎉

## v0.0.0.9000 (2026-01-27)

### Added

- A `NEWS.md` file to track changes to the package.
