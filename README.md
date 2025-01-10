# Linux Config (linux-config)

## Principles

Configuring your Linux environment can get complicated. This project attempts to
make installing and replicating your development environment easier by following
these principles:

* Keep all your Linux environment configurations in one place. This includes
  configuration files, external repos, virtual environments and installation
  scripts. 
* Create and manage links to configurations as needed throughout the file
  system.
* Keep all configurations under CM.
* Keep configurations modular. 
* Ensure configurations can be uninstalled.
* Design for "local" configurations to store configs local only to a development
  environment.
* Configure per user. In other words, configurations should not affect other
  users.

## What `linux-config` is Not

Currently, `linux-config` does not handle the installation of system
dependencies. However, known dependencies are listed in the prerequisites
section of the documentation. Also, each install script could offer a
`check_deps()` function to alert the user if a system dependency is not
available.

## linux-config Pre-reqs

* git
* GNU `stow`

## My Application's Pre-reqs

* terminator
* vim 8.1+ (with: Python 3.6+, `xterm_clipboard`)
* nvim (Neovim)
* nvim dependencies
* `dmenu`
* `rxvt-unicode`
* `rxvt-unicode-256color`
* Python 3.10 (for Qtile specifically)
* Cinnamon Desktop Environment (when not using Qtile)

## Getting Started

To get comfortable with using `linux-config`, its recommended to start by
creating a test user on your system. Then, go to the `scripts` directory, and
execute the configuration script of your choice. All configuration scripts end
in `-config`. For instance, to install the `git` configurations, execute:
```
$ git-config --install
```

* Stow commands can also be executed in the stow directory.

### Install Scripts

In the `scripts` directory, are scripts for each installation ending in
`-config`. Run the script with the `--help` option to get a description and
usage. All scripts offer an `--install` and `--uninstall` command. They may also
offer additional commands. All scripts must be run from this directory. If it
exists, the prefix of the script will match
to the corresponding stow package (e.g. `stow/git` <=> `scripts/git-config.sh`)
and the script will handle the calls to "stow"/link your config files.

Because it is complicated, details specifically on the installation of Qtile
[are here](QTILE.md), though the installation script, `qtile-config.sh`, should
handle the installation.

### Stow

`stow` is a fundamental application enabling Linux Config by managing the
linking of configuration files in a modular fashion. While the installation
scripts should handle the required calls to `stow`, you can make stow calls from
the stow directory. Also, the `stow-home.sh` wrapper script is provided to
simply the calls to install a *single* stow package. To use it, execute the
following:
```
$ cd scripts
$ export PATH=$PATH:$PWD
$ cd ../stow
$ stow-home.sh --install <package>
```

## Directories

* `stow` - files to be directly linked to the user's home directory using the
  application, GNU stow.
* `configurations` - files and directories that don't map directly to a user's
  `$HOME` directory.
* `scripts` - scripts to automate the installation of configs (ending in
  `-config` and some help scripts as well.
  additional.
* `repos` - stores external cloned (not stored in this repo) or forked (store in
  this repo) repos.
* `venvs` - space to create any virtual environments to support Linux
  configuration.
  
## Configuration Descriptions

* `stow/bash/.bashrc` - user's bash configurations common across all dev
  environments. 
* `stow/bash/.bashrc_local` - empty file (a placeholder) for user's bash
  configurations local to a particular dev environment and called by `.bashrc`. 
* `stow/git/.gitconfig` - user's Git configuration minus name and email
  configurations local to a particular dev environment. 
* `stow/git/.gitconfig_local` - user's local Git configuration including name
  and email configurations and called by `.gitconfig`. 
* `stow/qtile/.config/qtile/config.py` - my custom Qtile configuration. 
* `stow/qtile/.config/qtile/qtile-background.jpg` - background image used in my
  Qtile configuration.
* `stow/qtile/.local/bin/qtile-venv-entry` - glue shell script that is called
  to start Qtile in a virtual environment; populated by installation script.
* `stow/qtile/.xsession` - default configuration for Qtile to start under Remote
  Desktop (RDP).
* `stow/terminator/.config/terminator/config` - configuration for the Terminator
  terminal emulator.
* `stow/nvim/.config/nvim/` - stand-alone configurations (independent of Vim)
  for Nvim.
* `stow/vimfiles/.vimrc` - Vim initialization file configured to use runtime
  Vim.
* `configurations/keybindings.dconf` - the custom keybindings used in the
  Cinnamon desktop environment.
* `configurations/qtile-default-config.py` - default Qtile configuration
  primarily provided for reference.
* `configurations/qtile-venv.desktop` - system Qtile desktop entry to enter Qtile
  locally from a workstation versus a remote desktop session.
  primarily provided for reference.
* `configurations/Xdefaults.template` - used to create the `.Xdefaults` under
  `stow/rxvt` setting the path to the location of `urxvt-vim-scrollback`.
* `configurations/xession.cinnamon` - configuration for Cinnamon to start using
  RDP.
* `repos/urxvt-vim-scrollback` - folder containing the open source plug-in for
  urxvt allowing scrollback using Vim movements. To use, `.Xdefaults` must have
  the correct path it this repo.
* `venvs/qtile-venv` - reserved to create the Qtile virtual environment using
  the `requirements-frozen.txt` in that directory.

## Tips and Tricks

To test your Git configuration,
```
$ git config --list
```

To view Xsession errors:
```
$ less /var/log/xrdp-sesman.log
```

For remote sessions using Cinnamon, Gnome or KDE use the `Xvnc` session.

## To Do

* Add and test nvim add-ons.
* Check if `lua-language-server` submodules already exist, if so, don't update.
* Attempt to dockerize nvim with language server.
