# linux-config

Custom files used to configure a user's Linux environment. The folders and files
under the `home/` directory equivalently map to a users `$HOME` directory.

## Pre-reqs

* Cinnamon Desktop Environment
* git
* dmenu
* Neovim
* Qtile (see more below)
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

## Files
* `home/.bashrc` - my bash configurations. 
* `home/.config/nvim/init.vim` - initialization file to configure Nvim to use
  Doc Mike's vimfiles.
* `home/.config/qtile/config.py` - my custom Qtile configuration. 
* `.config/qtile/config.default.py` - default Qtile configuration primarily
  provided for reference.
* `home/.config/qtile/qtile-background.jpg` - background image used in my Qtile
  configuration.
* `home/.config/terminator/config` - configuration the Terminator terminal emulator.
* `home/.vimrc` - Vim initialization file configured to use runtime Vim.
* `home/.Xdefaults` - my configurations for the urxvt terminal generated from
  Xdefaults.template by the `custom_installs.sh`. Desktop (RDP) when this file
  is `$HOME/.xsession`.
* `keybindings.dconf` - the custom keybindings used in the Cinnamon desktop
  environment.
* `urxvt-vim-scrollback` - folder containing the open source plug-in for urxvt
  allowing scrollback using Vim movements. To use, make sure the following line
  in `Xdefaults` has the correct path.
    ```
    URxvt*perl-lib: /path/to/this/urxvt-vim-scrollback
    ```
* `Xdefaults.template` - used to create the `.Xdefaults`; with a generic
  location of `urxvt-vim-scrollback`.
* `xsession.qtile` - configuration for Qtile to start under Remote Desktop
  (RDP) when this file is `$HOME/.xsession`.
* `xsession.cinnamon` - configuration for Cinnamon to start under Remote 

## Qtile Notes Version 0.23.0, Released 2023-09-24
While awesome, Qtile is a real pain to install correctly. Once you get a version
working, its good to note the dependencies and their versions. Below are the
details, for getting Qtile v0.23.0 working.

### Pre-reqs
* Python 3.9+ (Usually have to install)
* `python3.9-dev` (Debian)/`python3.9-devel` (Red Hat)
* `libffi-dev` (Debian)/`libffi-devel` (Red Hat)
* `libxkbcommon-x11-dev` (Debian)/`libxkbcommon-x11-devel` (Red Hat)
* Probably more packages not listed here
* Python module `xcffib` 1.4.0
* Python module `cffi` 1.1.0
* Python module `cairocffi` 1.6.0
* Python module `mypy` 1.10.0

### Python 3.9 Installation on Ubuntu 20.04
I started by following the instructions from this site:
* https://linuxize.com/post/how-to-install-python-3-9-on-ubuntu-20-04/

Then I manually changed the `python3` link to point to 3.9.
```
$ cd /usr/bin
$ rm python3
$ ln -s python3.9 python3
```

Then I installed and updated `pip` to the latest.
```
$ sudo apt install python3-pip
$ sudo python3 -m pip install --upgrade pip
$ sudo apt remove python3-pip
```

### Qtile Installation
With all your non-Python dependent packages installed, install all Python
packages via `pip` in the order below. Qtile has had issue with the order of
installation because packages build on other packages.

```bash
$ sudo pip install xcffib==1.4.0
$ sudo pip install cffi==1.1.0
$ sudo pip install cairocffi==1.6.0
$ sudo pip install mypy==1.10.0
$ sudo pip install qtile==0.23.0
```

Now check for issues. If all is good you should see the output below.
```bash
$ qtile check
Checking Qtile config at: /home/jlburky/.config/qtile/config.py
Success: no issues found in 1 module
Success: no issues found in 1 source file
Config file type checking succeeded!
Your config can be loaded by Qtile.
```

Errors can be found in `~/.local/share/qtile.log`.

## To Do
* Add gitconfig.
