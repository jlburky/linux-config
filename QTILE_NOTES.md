# Qtile Notes Version 0.23.0, Released 2023-09-24
While awesome, Qtile is a real pain to install correctly. Once you get a version
working, its good to note the dependencies and their versions. Below are the
details, for getting Qtile v0.23.0 working.

## Pre-reqs
* Python 3.9+ (Usually have to install)
* `python3.9-dev` (Debian)/`python3.9-devel` (Red Hat)
* `libffi-dev` (Debian)/`libffi-devel` (Red Hat)
* `libxkbcommon-x11-dev` (Debian)/`libxkbcommon-x11-devel` (Red Hat)
* Probably more packages not listed here
* Python module `xcffib` 1.4.0
* Python module `cffi` 1.1.0
* Python module `cairocffi` 1.6.0
* Python module `mypy` 1.10.0

## Python 3.9 Installation on Ubuntu 20.04
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

## Qtile Installation
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
