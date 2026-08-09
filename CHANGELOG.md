# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/). The project also follows [Semantic Versioning](https://semver.org/), [Conventional Branch](https://conventionalbranch.org/), and [Conventional Commits](https://www.conventionalcommits.org/) standards.

## v0.3.1.9000 (development version)

### Added

- `behaviorsearch-headless` command for BehaviorSearch batch runs.
- `java` command pointing to the JDK that NetLogo bundles.

### Changed

- `NetLogo` and `NetLogo3D` now route `--headless` runs, and runs started without a display, to NetLogo's batch launcher, which starts a JVM without the browse fix agent.
- The browse fix is compiled during the Flatpak build with the JDK version that NetLogo bundles, instead of shipping a prebuilt jar.
- `JAVA_HOME` now points to NetLogo's own runtime.
- Renamed `NEWS.md` to `CHANGELOG.md`.

### Fixed

- The browse fix agent aborting the JVM with "Error opening zip file or JAR manifest missing". The agent is referenced through jpackage's `$APPDIR` instead of a hardcoded `/app` path.
- NetLogo's shell launchers failing to find a JVM, because the runtime pointed `JAVA_HOME` at a JDK that is not part of it.

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
