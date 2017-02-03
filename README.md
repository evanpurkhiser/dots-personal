## Evan Purkhiser's Configuration files

These are my personal configuration files for my various machines.
Configuration files are grouped into different 'configuration' groups that
allow for specific installations based on the type of machine the dotfiles are
being installed on.  For example, the dotfiles installed for a server would be
different than the dotfiles installed on my home desktop or work laptop.

These dotfiles are managed using the `dots` [dotfile managment
utility](https://github.com/EvanPurkhiser/dots).

## Configuration groups

The following configuration groups are used for my dotfiles:

| Group Name   | Description |
| ------------ | ----------- |
| `base`       | The base configuration group is installed for all environments. This includes the most basic and cross platform configurations. For example, bash, vim, and other environment independent configurations are placed here.
| `common/*`   | Common groups apply to various machines and are generally more generic. This includes playform (osx / linux) and geolocal (work / home) groupings.
| `machines/*` | The machine groups are specific to a single machine. This includes configuration files for programs isntalled locally to that machine that are not intended to be shared elsewhere.
