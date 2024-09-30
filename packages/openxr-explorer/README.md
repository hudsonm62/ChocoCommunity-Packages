# [OpenXR Explorer](https://community.chocolatey.org/packages/openxr-explorer)

![Screenshot of OpenXR Explorer](https://cdn.jsdelivr.net/gh/maluoi/openxr-explorer/docs/OpenXRExplorerWindow.png)

OpenXR Explorer is a handy debug tool for OpenXR developers. It allows for easy switching between OpenXR runtimes, shows lists of the runtime's supported extensions, and allows for inspection of common properties and enumerations, with direct links to relevant parts of the OpenXR specification!

## Features

### Runtime Switching

If you hop between runtimes often, whether it be for testing, experimenting, or whatever else, you know it can be a bit painful! OpenXR Explorer adds a simple dropdown to manage this, with a configurable list of runtimes for those with in-development runtimes, or non-standard install directories. Permission elevation is requested via a separate switching application, so OpenXR Explorer itself doesn't need admin!

And speaking of a separate application, that application is `xrsetruntime`, and is easily accessible via command line for those with a CLI workflow! Try `xrsetruntime -WMR` from an elevated console.

### Runtime Information

It can be handy to know what to expect when requesting data from OpenXR! This tool shows all the common lists and enumerations, and provides quick links to the relevant section of the OpenXR specification for additional details. This is a great way to quickly see differences between runtimes, or plan out your own OpenXR applications!

### Command Line Interface

Just about everything you see in the GUI is also available in text format when used from the command line! If you provide the openxr-explorer application with function or type names as arguments, it'll just dump the results as text to the console instead of launching the GUI. Who needs this? I don't know! I sure didn't, but I hope someone else does :)

## Package specific

### [choco://openxr-explorer](choco://openxr-explorer)

To use choco:// protocol URLs, install the [(unofficial) choco:// Protocol support](https://community.chocolatey.org/packages/choco-protocol-support)

### Package Parameters

The following package parameters can be set:

- `/SkipGuiShim` - Skips creation of explicit [.gui shim](https://docs.chocolatey.org/en-us/features/shim/#how-can-i-ensure-a-gui-shim) (the actual GUI and CLI shims still work!)

To pass parameters, use `--params "''"` (e.g. `choco install packageID [other options] --params="'/ITEM:value /FLAG_BOOLEAN'"`).

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.

### Notes

- This is an automatically updated package. If you find it is
  out of date by more than a day or two, please contact the maintainer(s) and
  let them know [here](https://github.com/hudsonm62/ChocoCommunity-Packages/issues) that the package is no longer updating correctly.
