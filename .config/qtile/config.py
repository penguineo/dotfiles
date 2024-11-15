import os
import subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from keymaps import keymaps


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/autostart.sh")
    subprocess.call(home)


## Settings ##
my_settings = {
    "modifier_key": "mod1",
    "terminal": "kitty",
    "file_manager": "nautilus",
    "web_browser": "librewolf",
    "handwritten_notes": "rnote",
    "password_manager": "keepassxc",
    "equalizer": "easyeffects",
}

keys, mouse = keymaps(my_settings)

## Workspace ##

groups = [
    Group("1", label="TERM"),
    Group(
        "2",
        label="WEB",
        matches=[Match(wm_class=my_settings["web_browser"])],
        layout="max",
    ),
    Group(
        "3", label="NOTE", matches=[Match(wm_class=my_settings["handwritten_notes"])]
    ),
    Group("4"),
    Group("5"),
    Group("6"),
    Group("7", label="OBS", matches=[Match(wm_class="obs")]),
    Group(
        "8",
        label="PASS",
        matches=[Match(wm_class=my_settings["password_manager"])],
        layout="max",
    ),
    Group(
        "9",
        label="VOl",
        matches=[Match(wm_class=my_settings["equalizer"])],
    ),
]

for i in groups:
    keys.extend(
        [
            Key(
                [my_settings["modifier_key"]],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            Key(
                [my_settings["modifier_key"], "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
        ]
    )

groups.extend(
    [
        ScratchPad(
            "scratchpad",
            [
                DropDown(
                    "btop",
                    "kitty btop",
                    on_focus_lost_hide=True,
                    warp_pointer=True,
                    height=0.7,
                    width=0.6,
                    x=0.2,
                    y=0.15,
                ),
                DropDown(
                    "note",
                    "kitty nvim /storage/personal/notes/dailyjot.md",
                    on_focus_lost_hide=True,
                    warp_pointer=True,
                    height=0.7,
                    width=0.6,
                    x=0.2,
                    y=0.15,
                ),
                DropDown(
                    "volume",
                    "pavucontrol",
                    opacity=0.8,
                    on_focus_lost_hide=True,
                    warp_pointer=True,
                ),
                widget.TextBox("default config", name="default"),
                widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Systray(),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
                widget.QuickExit(),
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # x11_drag_polling_rate = 60,
    ),
]

layouts = [
    layout.Columns(
        border_focus=["#d75f5f", "#8f3d3d"],
        border_width=4,
        margin=6,
        margin_on_single=0,
    ),
    layout.Max(),
    layout.MonadWide(),
    layout.MonadTall(),
    layout.Zoomy(),
]

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wl_xcursor_theme = None
wl_xcursor_size = 24
wmname = "LG3D"
