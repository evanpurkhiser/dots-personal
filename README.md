## Evan Purkhiser's Configuration files

These are my personal configuration files for my various machines. Configuration
files are grouped into different 'configuration' groups that allow for specific
installations based on the type of machine the dot files are being installed on.
For example, the dot files installed for a server would be different than the
dotfiles installed on my Desktop, HTPC, or Netbook.

All configurations will be installed into the `$XDG_CONFIG_HOME` directory.

If you have configuration files that absolutely **must** be placed in the
`$HOME` directory (i.e. you cannot override the configuration path with an
enviroment variable) then the configuration file/directory should be symlinked
from the `$XDG_CONFIG_HOME` to where it needs to be in `$HOME`. See the
Installation section for how to do this using `after-install` scripts.

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

#### Extending with explicit append points

If a configuration file isn't procedural (in that you can't just append more
configuration options to the end) such as a XML or JSON file, then you will need
to use 'explicit append points'. This allows you to tell installer where to
insert a subsequent configuration file contents.

There are two types of explicit append points: default and named.

##### default append points

One 'default' append point may be defined per configuration file. This is the
point where subsequent configuration files will be inserted into the file.

The default append point is denoted by a `!!@@` with no trailing characters.

##### named append points

One or more 'named' append points may be defined per configuration file. This
allows you to include multiple subsequent configuration files into the file.

The named append point is denoted by a `!!@@` followed by a name. That same name
should be appended to the subsequent configuration file names prefixed with a dot.

For example, if you have a `bashrc` file that includes a `!!@@aliases` then the
subsiquent file that would be inserted at that append point would have the file
name `bashrc.aliases`.

### Overriding

You can completely override a configuration file included in a previous group.
This is similar to extending a configuration file as described in the previous
section, however the file will simply replace the file specified in the
environment group.

Enable overriding for a file by appending `.override` to the filename.

## Installation

An installation script will be included to specify environment groups to install
and then to copy the files into the `$XDG_CONFIG_HOME` directory.

An additional `after-install` script may be included in each configuration group
directory to be run after installing the configuration files.
