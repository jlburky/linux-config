# Qtile Notes Version 0.24.0, Released 2024-01-20
While awesome, Qtile is a real pain to install correctly. Once you get a version
working, its good to note the dependencies and their versions. Below are the
details, for getting Qtile v0.24.0 working.

## Pre-reqs
* Python 3.10+ (May have to install manually)  
  * `python3.10-dev` (Debian)/`python3.10-devel` (Red Hat)
* `libffi-dev` (Debian)/`libffi-devel` (Red Hat)
* `libxkbcommon-x11-dev` (Debian)/`libxkbcommon-x11-devel` (Red Hat)
* Probably more packages not listed here
* Python module `xcffib` 1.5.0
* Python module `cffi` 1.16.0
* Python module `cairocffi` 1.7.0
* Python module `mypy` 1.10.0

## Setup Python 3.10 Virtual Environment
Unless the native version of Python is 3.10+, I would run Qtile in a virtual environment. I
followed the following guide:
* https://whatacold.io/blog/2019-09-29-how-to-run-the-bleeding-edge-code-of-qtile/

Below are my instructions with minor modifications.
First install create the virtual environment
```
$ mkdir -p ~/local/
$ python3.10 -m venv ~/local/qtile-venv/
$ source ~/local/qtile-venv/bin/activate
```

Then I installed and updated `pip` to the latest.
```
(venv)$ python -m pip install --upgrade pip
```

Create the venv glue entry script that will be called by your `.xsession` file.
```
$ touch ~/local/qtile-venv/qtile-venv-entry
$ chmod 755 ~/local/qtile-venv/qtile-venv-entry
```

And enter the following into `qtile-venv-entry`.
```
source ~/local/qtile-venv/bin/activate
python ~/local/qtile-venv/bin/qtile $*
```

## Qtile Installation
With all your non-Python dependent packages installed, install all Python
packages via `pip` in the order below. Qtile has had issue with the order of
installation because packages build on other packages.

```bash
(venv)$ pip install xcffib==1.5.0
(venv)$ pip install cffi==1.16.0
(venv)$ pip install cairocffi==1.7.0
(venv)$ pip install mypy==1.10.0
(venv)$ pip install qtile==0.24.0
```

Now check for issues. Start with a simple call to the help menu.
```bash
(venv)$ qtile --help
```

Check your config file for compatibility. If all is good you should see the output below.
```bash
(venv)$ qtile check
Checking Qtile config at: /home/jlburky/.config/qtile/config.py
Success: no issues found in 1 module
Success: no issues found in 1 source file
Config file type checking succeeded!
Your config can be loaded by Qtile.
```

Errors can be found in `~/.local/share/qtile.log`.
