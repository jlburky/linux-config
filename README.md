# linux-config

Custom files used to configure a user's Linux environment. The folders and files
under the `home/` directory equivalently map to a users `$HOME` directory.

## Pre-reqs

* Cinnamon Desktop Environment
* git
* dmenu
* Neovim
* Qtile ([notes here](QTILE_NOTES.md))
* rxvt-unicode
* terminator
* Vim with Doc Mike's vimfiles
* Python module `logging_tree`

## Installation

In the `scripts` directory, are short scripts for each installation. Run the
script with the `--help` option to get a description and usage.

## Directories
* `home` - files to be directly linked to the user's home directory.
* `configuraions` - files and directories that don't map directly to a user's
  `$HOME` directory.
* `scripts` - scripts to automate the environment; each script is prepended
  numerically to provide a run order and must be run from this directory.
* `repos` - stores external cloned (not stored in this repo) or forked (store in
  this repo) repos.
* `venvs` - space to create any virtual environments to support Linux
  configuration.
  
## Configuration Descriptions
* `home/.bashrc` - my bash configurations. 
* `home/.config/nvim/init.vim` - initialization file to configure Nvim to use
  Doc Mike's vimfiles.
* `home/.config/qtile/config.py` - my custom Qtile configuration. 
* `.config/qtile/config.default.py` - default Qtile configuration primarily
  provided for reference.
* `home/.config/qtile/qtile-background.jpg` - background image used in my Qtile
  configuration.
* `home/.config/terminator/config` - configuration the Terminator terminal
  emulator.
* `home/xsession.qtile` - configuration for Qtile to start under Remote Desktop
  (RDP) when this file is `$HOME/.xsession`.
* `home/.vimrc` - Vim initialization file configured to use runtime Vim.
    ```
    URxvt*perl-lib: /path/to/this/urxvt-vim-scrollback
    ```
* `configurations/keybindings.dconf` - the custom keybindings used in the Cinnamon desktop environment.
* `configurations/Xdefaults.template` - used to create the `.Xdefaults` setting
  the path to the location of `urxvt-vim-scrollback`.
* `configurations/xession.cinnamon` - configuration for Cinnamon to start using RDP.
* `repos/urxvt-vim-scrollback` - folder containing the open source plug-in for urxvt
  allowing scrollback using Vim movements. To use, make sure the following line
  in `Xdefaults` has the correct path.

## To Do
* Add gitconfig.
* Update qtile to version 0.24.0.
* Update qtile config.py to support two monitors by repeating Screen object.
* pip freeze the Qtile venv 
