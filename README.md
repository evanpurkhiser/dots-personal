## Evan Purkhiser's Configuration files

These are my personal configuration files for my various machines. Configuration
files are grouped into different 'configuration' groups that allow for specific
installations based on the type of machine the dot files are being installed on.
For example, the dot files installed for a server would be different than the
dotfiles installed on my Desktop, HTPC, or Netbook.

These dotfiles are managed using the `dots` [dotfile managment
utility](https://github.com/EvanPurkhiser/dots).

## Configuration groups

The following configuration groups are available for my dotfiles:

### `base`

The base configuration group should be installed for all environments. This
includes the most basic and cross platform configurations. For example, bash,
vim, and other environment independent configurations should be placed here.

### `common/graphical`

This configuration group should include configuration files used when the
machine has a graphical environment (xorg display server). For example, this
should include gtk configurations and base window manager configurations.

### `common/workstation`

This configuration group should include configuration files for a system that
doesn't necessarily have a graphical environment, but is still a physically
accessible workstation. A good example here is pulseaduio, which can be used
without a display server running.

### `common/develop`

This configuration group should include configuration files that are used with
development tools. For example, mysql is a development tool that may be used
on various machines (servers, workstations, etc).

### `machines/*`

All machine configuration groups should include configuration files that are
specific to that particular machine. It could include configuration files for
programs that have configurations specific to that machine or hardware. For
example my HTPC would include
[xboxdrv](http://pingus.seul.org/~grumbel/xboxdrv/) configurations since that is
specific only to my HTPC.
