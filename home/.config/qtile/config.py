import sys
import re
import os.path as osp
import subprocess
import shlex
import socket
import logging
#import logging_tree

from pprint import pformat as pf
from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.lazy import lazy
from libqtile import layout, bar, widget, hook
from typing import List

from libqtile.log_utils import logger as qtileLogger
qtileLogger.setLevel(logging.INFO)

# Note: the system log is in ~/.local/share/qtile/qtile.log
#       the local logger is in ~/.config/qtile/qtile.log
logger = logging.getLogger("myconfig")

#mod = "mod4"   # Windows key
mod = "mod1"   # Alt key


HOME = osp.expanduser('~')
HOSTNAME = socket.gethostname()

logging.basicConfig(
    filename=osp.join(HOME, ".config/qtile/qtile.log"),  
    filemode="w",
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    level=logging.INFO,
)


def bind(key_comb, cmdobj):
    "Helper function for key binding."

    logger.debug('Binding key combination: %s' % key_comb)
    key = [mod]
    m = re.match(r'(\w+)\s*\+?\s*(\w+)?', key_comb)
    if m:
        groups = m.groups(default=None)
        if groups[1] is None:
            char = groups[0]
            logger.debug('binding %s: %r' % (char, cmdobj.__dict__))
        else:
            key.append(groups[0])
            char = groups[1]
            logger.debug('binding mod+%s+%s: %r' % (key[1], char, cmdobj.__dict__))
    else:
        logger.error('No match on regex: %s' % key_comb)
        raise Exception('Bad regex match in bind function')

    return Key(key, char, cmdobj)


keys = [
    # Switch between windows in current layout.
    bind("j", lazy.layout.down()),
    bind("k", lazy.layout.up()),
    bind("h", lazy.layout.left()),
    bind("l", lazy.layout.right()),
    bind("b", lazy.layout.next()),
    bind("n", lazy.layout.normalize()),
    bind("m", lazy.layout.maximize()),
    bind("z", lazy.layout.reset()),
    bind("F11", lazy.layout.grow()),
    bind("F12", lazy.layout.shrink()),

    bind('1', lazy.to_screen(0)),
    bind('2', lazy.to_screen(1)),

    # Move windows up or down in current stack
    bind("control + j", lazy.layout.shuffle_down()),
    bind("control + k", lazy.layout.shuffle_up()),

    # Switch window focus to other pane(s) of stack
    bind("space", lazy.layout.next()),

    # Swap panes of split stack
    bind("shift + space", lazy.layout.rotate()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    bind("shift + Return", lazy.layout.toggle_split()),
    bind("Return", lazy.spawn("urxvt")),

    # Toggle between different layouts as defined below
    bind("Tab", lazy.next_layout()),
    bind("q", lazy.window.kill()),

    bind("shift + r", lazy.restart()),
    bind("shift + q", lazy.shutdown()),
    bind("r", lazy.spawn("dmenu_run -p 'dmenu:'")),
]

groups = [Group(i) for i in "asdfuiop"]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        bind(i.name, lazy.group[i.name].toscreen()),

        # mod1 + shift + letter of group = switch to & move focused window to group
        bind("shift + %s" % i.name, lazy.window.togroup(i.name)),
    ])

layout_theme = {"border_width": 2,                 
    "margin": 4,                 
    #"border_focus": "AD69AF",                 
    "border_focus": "de935f",                 
    "border_normal": "1D2330"} 

layouts = [
    layout.MonadTall(**layout_theme),
    layout.VerticalTile(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Max(**layout_theme),
# More layours to try below
#    layout.Stack(**layout_theme, num_stacks=2),
#    layout.Tile(shift_windows=True, **layout_theme), 
#    layout.Matrix(**layout_theme),    
#    layout.RatioTile(**layout_theme),
#    layout.Floating(**layout_theme),
#    layout.TreeTab(
#        font = "Ubuntu",          
#        fontsize = 10,          
#        sections = ["FIRST", "SECOND"],          
#        section_fontsize = 11,          
#        bg_color = "141414",          
#        active_bg = "90C435",          
#        active_fg = "000000",          
#        inactive_bg = "384323",          
#        inactive_fg = "a0a0a0",          
#        padding_y = 5,          
#        section_top = 10,          
#        panel_width = 320),
]

widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

##### COLORS ##### 
colors = [
    ["#282a36", "#282a36"],  # panel background           
    ["#434758", "#434758"],  # background for current screen tab           
    ["#ffffff", "#ffffff"],  # font color for group names           
    ["#ff5555", "#ff5555"],  # background color for layout widget           
    ["#A77AC4", "#A77AC4"],  # light purple
    ["#7197E7", "#7197E7"],  # background color for pacman widget 
    ["#113654", "#113654"],  # background color for WindowTab widget
    ["#a54242", "#a54242"],  # background color for current layout widget
    ["#4b5058", "#4b5058"],  # color for inactive group
]  

screens = [
    Screen(
        # CUSTOM
        bottom=bar.Bar(
            [
                widget.GroupBox(
                    active=colors[2],
                    inactive=colors[8],
                    highlight_method="block",
                    this_current_screen_border=colors[7],                         
                    this_screen_border=colors[1],                         
                    other_current_screen_border=colors[0],                         
                    other_screen_border=colors[0],                         
                    foreground=colors[2],                         
                    background=colors[0],
                    ),
                widget.Sep(
                    linewidth=2,
                    size_percent=100,
                    foreground=colors[2],                         
                    background=colors[0],
                    ),
                widget.Prompt(),
                widget.WindowTabs(
                    foreground=colors[2],
                    background=colors[6],
                    ),
                widget.CurrentLayout(background=colors[7]),
                widget.TextBox("%s" % HOSTNAME, name="default",
                    foreground=colors[2],
                    background=colors[4],
                    ),
                widget.Systray(),
                widget.Clock(format='%Y-%m-%d %a %I:%M %p'),
            ],
            25,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    Match(wm_class='confirm'),
    Match(wm_class='dialog'),
    Match(wm_class='download'),
    Match(wm_class='error'),
    Match(wm_class='file_progress'),
    Match(wm_class='notification'),
    Match(wm_class='splash'),
    Match(wm_class='toolbar'),
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = "smart"

# Detect certain window names that should be floating.
@hook.subscribe.client_new
def float_display(win):
    wm_class = win.window.get_wm_class()
    w_name = win.window.get_name()
    if wm_class == ("display", "Display"):
        win.floating = True

def run(cmdline):
    logger.info("Running: %s" % cmdline)
    subprocess.Popen(shlex.split(cmdline))


@hook.subscribe.startup_once
def startup():
    """
    Run after qtile is started
    """
    logger.info("Qtile startup...")
    logger.info(f"Python version: {sys.version}")
    logger.info(f"Qtile system log: ~/.local/share/qtile/qtile.log")

    # jlb: not sure what this did 
    #run('xrandr --output DP1 --primary --mode 1920x1080 --rate 60.00 --output DP2 --mode 1920x1080 --rate 60.00 --right-of DP1')
    
    run('feh --bg-scale {}'.format(osp.join(HOME, '.config/qtile/qtile-background.jpg')))

    # Write the logging tree to a file.
    #with open(".config/qtile/logging_tree.txt", 'w') as f:
    #    f.write(logging_tree.format.build_description())


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
