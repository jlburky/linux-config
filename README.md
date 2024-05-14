# linux-home

Custom files used to configure a user's Linux environment. The folders and files
under the `home/` directory equivalently map to a users `$HOME` directory.

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
* `home/.Xdefaults` - my configurations for the urxvt terminal.
* `urxvt-vim-scrollback` - folder containing the open source plug-in for urxvt
  allowing scrollback using Vim movements. To use, make sure the following line
  in `Xdefaults` has the correct path.
    ```
    URxvt*perl-lib: /path/to/this/urxvt-vim-scrollback
    ```
* `Xdefaults.template` - pretty much the same as the `.Xdefaults`; with a
  generic location of `urxvt-vim-scrollback`.

## To Do
* Add xsession files and installation.
* Add print function showing any executed commands in link_home.sh.
* Add scrollback for Terminator.
