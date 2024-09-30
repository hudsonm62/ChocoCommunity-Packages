# Chocolatey Community Packages

[![Actions Updater](https://img.shields.io/github/actions/workflow/status/hudsonm62/ChocoCommunity-Packages/au-updater.yml?branch=master&logo=githubactions&style=for-the-badge&label=Updater)](https://github.com/hudsonm62/ChocoCommunity-Packages/actions/workflows/au-updater.yml) [![Report Broken Packages](https://img.shields.io/badge/broken%20packages-red?style=for-the-badge&logo=github&label=report&link=https%3A%2F%2Fgithub.com%2Fhudsonm62%2Fchoco-library%2Fissues%2Fnew%2Fchoose)](https://github.com/hudsonm62/ChocoCommunity-Packages/issues/new/choose)

## Description

This repository contains chocolatey packages created and maintained primarily by [hudsonm62](https://chocolatey.org/profiles/hudsonm62) for the [Chocolatey Community](https://community.chocolatey.org/packages), that are updated daily using [Chocolatey AU] via [GitHub Actions](https://github.com/hudsonm62/ChocoCommunity-Packages/actions/workflows/au-updater.yml).

## File Key

- [`packages`](./packages/) - All packages live here, and is checked by [Chocolatey AU] daily.
- [`icons`](./icons/) - All icons live here.
- [`test_all.ps1`](./test_all.ps1) - Runs a test update / pack of all packages in optional groups.
- [`update_all.ps1`](./update_all.ps1) - Runs the Updater, with options to push.
- [`au_setup.ps1`](./au_setup.ps1) - Updates / Installs / Imports NuGet, Chocolatey-AU and chocolateyProfile module.
- [`.github/workflows/au_updater.yml`](./.github/workflows/au_updater.yml) - Handles updating packages, pushing to Chocolatey.

## Guidelines

### Reporting broken/outdated packages

If packages from this repository fail to install or a new version has been released by the software vendor for a particular package, please report it via [GitHub issue](https://github.com/hudsonm62/ChocoCommunity-Packages/issues/new/choose) - You can use one of the Issue templates to quickly fill in the required info.

#### Outdated Packages

_Most_, if not all packages use [Chocolatey AU] and is checked/updated daily. If you find any packages are out of date by more than a few days, please contact the maintainer(s) and let them know [here](https://github.com/hudsonm62/ChocoCommunity-Packages/issues) that the package is no longer updating correctly.

#### Broken Packages

For packages not installing, ensure the issue is not transient (limited to your current environment). You can also execute `choco install pkg-id --yes --verbose --debug` to get full debug information, which you'll need for an [issue report](https://github.com/hudsonm62/ChocoCommunity-Packages/issues/new/choose) anyway.

### Contributing

1. As much as possible, these packages are [automatic](https://chocolatey.org/docs/automatic-packages) and all automatic packages will use the [Chocolatey AU] module.
2. Code is written for humans, not for computers (i.e. assembly). Make the code readable and commented, but also efficient. The goal is not to obfuscate. If another one wants to help, they need to understand it too!
3. All the metadata attributes in the package needs to be filled up as much as possible. If a metadata tag is empty, it is because the information is not available. In case of the metadata should be publicly presented as it is important, but still not available on the net, you could need to contact the publisher of the software.

[Chocolatey AU]: https://github.com/chocolatey-community/chocolatey-au
