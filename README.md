# linux-config

Keep all your Linux configurations in one place! 

Link all the folders and files under this repo's `home/` directory to a user's
`$HOME` directory. Store configuration files under `configurations`. Check out
external repos under `repos`. Build required Python virtual environments under
`pyenv`.

## Pre-reqs

* Cinnamon Desktop Environment (if preferred to Qtile)
* dmenu
* git
* nvim (Neovim)
* nvim dependencies
* `rxvt-unicode`
* `rxvt-unicode-256color`
* terminator
* Python 3.10 (for Qtile specifically)
* vim 8.1+ (with: Python 3.6+, xterm_clipboard)

## Installations

In the `scripts` directory, are short scripts for each installation. Run the
script with the `--help` option to get a description and usage. Details
specifically on the installation of Qtile [are here](QTILE.md), though the
installation script, `qtile-config.sh`, should handle the installation.

## Directories

* `home` - files to be directly linked to the user's home directory.
* `configurations` - files and directories that don't map directly to a user's
  `$HOME` directory.
* `scripts` - scripts to automate the environment; each script is prepended
  numerically to provide a run order guidance. All scripts must be run from this directory.
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
* `stow/git/.gitconfig_local` - user's local Git configuration including name and email
  configurations and called by `.gitconfig`. 
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
* `stow/vim/.vimrc` - Vim initialization file configured to use runtime Vim.
* `configurations/keybindings.dconf` - the custom keybindings used in the
  Cinnamon desktop environment.
* `configurations/qtile-default-config.py` - default Qtile configuration primarily
  provided for reference.
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

* Maybe move qtile venv under stow?
* Check if `lua-language-server` submodules already exist, if so, don't update
* Attempt to dockerize nvim with language server
