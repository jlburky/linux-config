# linux-config

## Principles

Configuring your Linux environment can get complicated. This project attempts to
follow these principles:
* Keep all your Linux environment configurations in one place (this project).
  This includes configuration files, external repos, virtual environments and
  installation scripts. Create and manage links to those configurations as
  needed throughout the file system.
* Keep configurations modular. 
* Ensure configurations can be uninstalled.
* Provide a "local" configuration for configs local to a development environment.
* Configure per user. In other words, configurations should not affect other
  users.

## What `linux-config` is Not

Currently, `linux-config` does not handle the installation of system
dependencies. However, known dependencies are listed in the prerequisites
section of the documentation. Also, each install script could offer a
`check_deps()` function to alert the user if a system dependency is not
available.

## Pre-reqs

* Cinnamon Desktop Environment (if preferred to Qtile)
* dmenu
* git
* nvim (Neovim)
* nvim dependencies
* `rxvt-unicode`
* `rxvt-unicode-256color`
* Python 3.10 (for Qtile specifically)
* GNU `stow`
* terminator
* vim 8.1+ (with: Python 3.6+, `xterm_clipboard`)

## Getting Started
TODO - test with a new user?

### Install Scripts

In the `scripts` directory, are scripts for each installation. Run the
script with the `--help` option to get a description and usage. All scripts
offer an `--install` and `--uninstall` command. They may also offer additional
commands. All scripts must be run from this directory and match to the
corresponding stow package (e.g. `stow/git` <=> `scripts/git-config.sh`).

Because it is complicated, details specifically on the installation of Qtile
[are here](QTILE.md), though the installation script, `qtile-config.sh`, should
handle the installation.

## Directories

* `stow` - files to be directly linked to the user's home directory using the
  application, GNU stow.
* `configurations` - files and directories that don't map directly to a user's
  `$HOME` directory.
* `scripts` - scripts to automate the environment.
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
* `stow/nvim/.config/nvim/init.vim` - initializations to configure Nvim to use
  Doc Mike's vimfiles.
* `stow/qtile/.config/qtile/config.py` - my custom Qtile configuration. 
* `stow/qtile/.config/qtile/qtile-background.jpg` - background image used in my
  Qtile configuration.
* `stow/qtile/.local/bin/qtile-venv-entry` - glue shell script that is called to
  start Qtile in a virtual environment; populated by installation script.
* `stow/qtile/.xsession` - default configuration for Qtile to start under Remote
  Desktop (RDP).
* `stow/terminator/.config/terminator/config` - configuration for the Terminator
  terminal emulator.
* `stow/vimfiles/.vimrc` - Vim initialization file configured to use runtime Vim.
* `configurations/keybindings.dconf` - the custom keybindings used in the
  Cinnamon desktop environment.
* `configurations/qtile-default-config.py` - default Qtile configuration
  primarily provided for reference.
* `configurations/Xdefaults.template` - used to create the `.Xdefaults` setting
  the path to the location of `urxvt-vim-scrollback`.
* `configurations/xession.cinnamon` - configuration for Cinnamon to start using
  RDP.
* `repos/urxvt-vim-scrollback` - folder containing the open source plug-in for
  urxvt allowing scrollback using Vim movements. To use, make sure the following
  line in `Xdefaults` has the correct path.
* `venvs/qtile-venv` - reserved to create the Qtile virtual environment using
  the `requirements-frozen.txt` in that directory.

## Tips and Tricks

To test your Git configuration,
```
$ git config --list
```

## To Do

* Create bash-config and terminator-config
* Convert neovim_addons script.
* Check that the executable rxvt-unicode exists.
* Revisit this document.
* Check if `lua-language-server` submodules already exist, if so, don't update
* Attempt to dockerize nvim with language server
