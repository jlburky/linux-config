# linux-config

Custom files used to configure a user's Linux environment. The folders and files
under the `home/` directory equivalently map to a users `$HOME` directory.

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
* vim

## Installation

In the `scripts` directory, are short scripts for each installation. Run the
script with the `--help` option to get a description and usage. Notes
specifically on the installation of Qtile [are here.](QTILE.md)

## Directories

* `home` - files to be directly linked to the user's home directory.
* `configuraions` - files and directories that don't map directly to a user's
  `$HOME` directory.
* `scripts` - scripts to automate the environment; each script is prepended
  numerically to provide a run order guidance. All scripts must be run from this directory.
* `repos` - stores external cloned (not stored in this repo) or forked (store in
  this repo) repos.
* `venvs` - space to create any virtual environments to support Linux
  configuration.
  
## Configuration Descriptions

* `home/.bashrc` - user's bash configurations common across all dev environments. 
* `home/.bashrc_local` - empty file (a placeholder) for user's bash
  configurations local to a particular dev environment. 
* `home/.config/nvim/init.vim` - initialization file to configure Nvim to use
  Doc Mike's vimfiles.
* `home/.config/qtile/config.py` - my custom Qtile configuration. 
* `home/.config/qtile/qtile-background.jpg` - background image used in my Qtile
  configuration.
* `home/.config/terminator/config` - configuration the Terminator terminal
  emulator.
* `home/.xsession` - default configuration for Qtile to start under Remote Desktop
  (RDP).
* `home/.vimrc` - Vim initialization file configured to use runtime Vim.
    ```
    URxvt*perl-lib: /path/to/this/urxvt-vim-scrollback
    ```
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

## To Do

* Add gitconfig script before vim stuff.
* Update qtile config.py to support two monitors by repeating Screen object.
* Resolve `flake8` errors during neovim install.
