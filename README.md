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

The `custom_installs.sh` can be used to implement any customizations outside of
linking the home directory. This script currently should be run before
`link_home.sh`. To use, from the location of this script, execute: 
```
$ ./custom_installs.sh
```

The `link_home.sh` script maps all the files under the `home/` directory to
the user's Linux `$HOME` directory as links. If a file or link already exists,
it will back it up with a timestamp extension (.YYYYMMDDHHMM) before creating
the new link. To use, from the location of this script, execute:
```
$ ./link_home.sh
```

This script can also remove any backups that were created. It prompts the user
if they want to remove each backup. Execute:
```
$ ./link_home.sh --remove-backups
```

### Cinnamon Keybindings Installation

Custom Cinnamon desktop keybindings were captured using the command:
```
$ dconf dump /org/cinnamon/desktop/keybindings/ > keybindings.dconf
```

They should be installed using the command below. 
TODO: Add the loading to the `custom_installs.sh`.
```
$ dconf load /org/cinnamon/desktop/keybindings/ < keybindings.dconf
```

## Directories
* `home` - files to be directly linked to the user's home directory.
* `scripts` - scripts to automate the environment.
  
## Files
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
* `home/.vimrc` - Vim initialization file configured to use runtime Vim.
* `keybindings.dconf` - the custom keybindings used in the Cinnamon desktop
  environment.
* `urxvt-vim-scrollback` - folder containing the open source plug-in for urxvt
  allowing scrollback using Vim movements. To use, make sure the following line
  in `Xdefaults` has the correct path.
    ```
    URxvt*perl-lib: /path/to/this/urxvt-vim-scrollback
    ```
* `Xdefaults.template` - used to create the `.Xdefaults` setting the path to the
  location of `urxvt-vim-scrollback`.
* `xsession.qtile` - configuration for Qtile to start under Remote Desktop
  (RDP) when this file is `$HOME/.xsession`.
* `xsession.cinnamon` - configuration for Cinnamon to start under Remote 

## To Do
* Add gitconfig.
* Move .xsession.qtile to home/.xsession.
* Update qtile to version 0.24.0.
* Update qtile config.py to support two monitors by repeating Screen object.
* pip freeze the Qtile venv 
