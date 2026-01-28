# LogoPak <a href = "https://github.com/danielvartan/logopak"><img src = "images/logo.svg" align="right" width="120" /></a>

<!-- badges: start -->
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![GPLv3 License Badge](https://img.shields.io/badge/license-GPLv3-bd0000.png)](https://www.gnu.org/licenses/gpl-3.0)
[![Contributor Covenant 3.0 Code of Conduct](https://img.shields.io/badge/Contributor%20Covenant-3.0-4baaaa.svg)](https://www.contributor-covenant.org/version/3/0/code_of_conduct/)
<!-- badges: end -->

LogoPak is a [Flatpak](https://flatpak.org/) package for [NetLogo](https://ccl.northwestern.edu/netlogo/), a multi-agent programmable modeling environment for simulating natural and social phenomena. It simplifies the installation and management of NetLogo on Linux systems.

The package includes all four NetLogo applications (NetLogo, NetLogo 3D, HubNet Client, and Behaviorsearch) and registers desktop files, file icons, and MIME types for NetLogo model files, enabling users to open models directly from their file manager.

## Building

### Prerequisites

You need to have [Flatpak](https://flatpak.org/) and `flatpak-builder` installed:

```bash
# On Ubuntu/Debian
sudo apt install flatpak flatpak-builder

# On Fedora
sudo dnf install flatpak flatpak-builder

# On Arch Linux
sudo pacman -S flatpak flatpak-builder
```

Add the [Flathub](https://flathub.org/en) repository if you haven't already:

```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

Install the required runtime and SDK:

```bash
flatpak install flathub org.freedesktop.Platform//24.08 org.freedesktop.Sdk//24.08
```

### Build the Flatpak

```bash
cd flatpak
flatpak-builder --force-clean build-dir com.danielvartan.NetLogo.yaml
```

### Install locally

```bash
cd flatpak
flatpak-builder --user --install --force-clean build-dir com.danielvartan.NetLogo.yaml
```

### Run

```bash
flatpak run com.danielvartan.NetLogo
```

You can also run the other applications:

```bash
flatpak run --command=NetLogo3D com.danielvartan.NetLogo
flatpak run --command=HubNetClient com.danielvartan.NetLogo
flatpak run --command=Behaviorsearch com.danielvartan.NetLogo
```

Or use the lowercase aliases:

```bash
flatpak run --command=netlogo com.danielvartan.NetLogo
flatpak run --command=netlogo3d com.danielvartan.NetLogo
flatpak run --command=hubnetclient com.danielvartan.NetLogo
flatpak run --command=behaviorsearch com.danielvartan.NetLogo
```

### Create a Flatpak bundle

To create a single-file bundle for distribution:

```bash
cd flatpak
flatpak-builder --repo=repo --force-clean build-dir com.danielvartan.NetLogo.yaml
flatpak build-bundle repo netlogo.flatpak com.danielvartan.NetLogo
```

Users can then install it with:

```bash
flatpak install netlogo.flatpak
```

## Uninstalling the Package

To uninstall the `LogoPak` Flatpak package, run the following command:

```bash
flatpak uninstall com.danielvartan.NetLogo
```

Use the `--delete-data` option to remove all associated user data as well:

```bash
flatpak uninstall --delete-data com.danielvartan.NetLogo
```

## Contributing

[![Contributor Covenant 3.0 Code of Conduct](https://img.shields.io/badge/Contributor%20Covenant-3.0-4baaaa.svg)](https://www.contributor-covenant.org/version/3/0/code_of_conduct/)

Contributions are always welcome! Whether you want to report bugs, suggest new features, or help improve the code or documentation, your input makes a difference.

Before opening a new issue, please check the [issues tab](https://github.com/danielvartan/logopak/issues) to see if your topic has already been reported.

[![GitHub Sponsor](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/danielvartan)

You can also support the development of `LogoPak` by becoming a
sponsor.

Click [here](https://github.com/sponsors/danielvartan) to make a
donation. Please mention `LogoPak` in your donation message.

## License

[![License: GPLv3](https://img.shields.io/badge/license-GPLv3-bd0000.svg)](https://www.gnu.org/licenses/gpl-3.0)

[NetLogo](https://www.netlogo.org) is licensed under [GPL-2.0-or-later](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html). See the [official NetLogo website](https://www.netlogo.org) for more information. `LogoPak` files are licensed under [GPL-3.0-or-later](https://www.gnu.org/licenses/gpl-3):

```text
Copyright (C) 2026 Daniel Vartanian

LogoPak is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <https://www.gnu.org/licenses/>.
```

## Acknowledgments

`LogoPak` is an independent project with no affiliation to [NetLogo](https://www.netlogo.org/) or its developers.

`LogoPak` brand identity is based on the [NetLogo 7](https://www.netlogo.org/) brand identity.
