# linux-home

Custom files used to configure a user's Linux environment. The folders and files
under the `home/` directory equivalently map to a users `$HOME` directory.

## Installation

The `install_links.sh` script maps all the files under the `home/` directory to
the user's Linux `$HOME` directory as links. If a file or link already exists,
it will back it up with a timestamp extension (.YYYYMMDDHHMM) before creating
the new link. To use, from the location of this script, execute:
```
$ ./install_links.sh
```

## Files
* `.bashrc` - my bash configurations. 
* `.config/nvim/init.vim` - initialization file to configure Nvim to use
  Doc Mike's vimfiles.
* `.vimrc` - Vim initialization file configured to use runtime Vim.
* `Xdefaults` - my configurations for the urxvt terminal.
* `.config/qtile/config.py` - my custom Qtile configuration. 
* `.config/qtile/config.default.py` - default Qtile configuration primarily
  provided for reference.
* `.config/qtile/qtile-background.jpg` - background image used in my Qtile
  configuration.
* `.config/terminator/config` - configuration the Terminator terminal emulator.
