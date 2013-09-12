## Evan Purkhiser's Configuration files

These are my personal configuration files for my various machines. Configuration
files are grouped into different 'environment' groups that allow for specific
installations based on the type of machine the dot files are being installed on.
For example, the dot files installed for a server would be different than the
dotfiles installed on my Desktop, HTPC, or Netbook.

All configurations will be installed into the `$XDG_CONFIG_HOME` directory.

## Configuration groups

### `base`

The base configuration group is installed for all environments. This includes
the most basic and cross platform configurations. For example, bash, vim, and
other environment independent configurations should be placed here.

### `common/graphical`

This configuration group should include configuration files used when the
machine has a graphical environment (xorg display server). For example, this
should include gtk configurations and base window manager configurations.

### `common/workstation`

This configuration group should include configuration files for a system that
doesn't necessarily have a graphical environment, but is still a physically
accessible workstation. A good example here is pulseaduio, which can be used
without a display server running.

### `machines/*`

All machine configuration groups should include configuration files that are
specific to that particular machine. It could include configuration files for
programs that have configurations specific to that machine or hardware. For
example my HTPC would include
[xboxdrv](http://pingus.seul.org/~grumbel/xboxdrv/) configurations since that is
specific only to my HTPC.

## Extending and Overriding configurations

Configuration groups can override or extend files that are included in
configuration groups specified prior to them.

### Extending configuration files

If a configuration file in the `base` group specifies _most_ of what is needed,
but for the specific environment you're installing the configuration files into
requires a little extra configuration for that file it is possible to append to
it.

For example, if you would like to add more options to the `bashrc` for your
`machine/desktop` group, you can simply include the `bash/bashrc` file and it
will automagically be appended to the `base/bash/bashrc` file upon installation.

Shebangs will be removed from the first line of the file being appended.

### Overriding

You can completely override a configuration file included in a previous group.
This is similar to extending a configuration file as described in the previous
section, however the file will simply replace the file specified in the
environment group.

Enable overriding for a file by appending `.ovrd` to the filename.

## Installation

An installation script will be included to specify environment groups to install
and then to copy the files into the `$XDG_CONFIG_HOME` directory.

An additional `after-install` script may be included in each configuration group
directory to be run after installing the configuration files.

## Problems and Concerns

 * How to handle extending files where the contents cannot just be appended to
   the end, for example XML or JSON configuration files.
