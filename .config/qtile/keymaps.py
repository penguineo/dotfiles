from libqtile.config import Click, Drag, Key, KeyChord
from libqtile.lazy import lazy


def keymaps(settings):
    m = settings["modifier_key"]
    ms = [m, "shift"]
    mc = [m, "control"]
    my_terminal = settings["terminal"]
    my_file_manager = settings["file_manager"]
    my_web_browser = settings["web_browser"]

    keys = [
        ## Window ##
        # Focus
        Key([m], "h", lazy.layout.left(), desc="Move focus to left"),
        Key([m], "l", lazy.layout.right(), desc="Move focus to right"),
        Key([m], "j", lazy.layout.down(), desc="Move focus down"),
        Key([m], "k", lazy.layout.up(), desc="Move focus up"),
        Key([m], "space", lazy.layout.next(), desc="Move window focus to other window"),
        # Position
        Key(ms, "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
        Key(ms, "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
        Key(ms, "j", lazy.layout.shuffle_down(), desc="Move window down"),
        Key(ms, "k", lazy.layout.shuffle_up(), desc="Move window up"),
        # Size
        Key(mc, "h", lazy.layout.grow_left(), desc="Grow window to the left"),
        Key(mc, "l", lazy.layout.grow_right(), desc="Grow window to the right"),
        Key(mc, "j", lazy.layout.grow_down(), desc="Grow window down"),
        Key(mc, "k", lazy.layout.grow_up(), desc="Grow window up"),
        Key([m], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
        # Layout
        Key([m], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
        Key(
            [m],
            "f",
            lazy.window.toggle_fullscreen(),
            desc="Toggle fullscreen on the focused window",
        ),
        Key(
            [m],
            "t",
            lazy.window.toggle_floating(),
            desc="Toggle floating on the focused window",
        ),
        Key(
            ms,
            "Return",
            lazy.layout.toggle_split(),
            desc="Toggle between split and unsplit sides of stack",
        ),
        # Operations
        Key([m], "q", lazy.window.kill(), desc="Kill focused window"),
        Key(ms, "r", lazy.reload_config(), desc="Reload the config"),
        Key(ms, "q", lazy.shutdown(), desc="Shutdown Qtile"),
        ## Application ##
        # Launcher
        KeyChord(
            [m],
            "r",
            [
                Key(
                    [], "d", lazy.spawn("rofi -show drun"), desc="Application Launcher"
                ),
                Key([], "r", lazy.spawn("rofi -show run"), desc="Command Launcher"),
                Key([], "w", lazy.spawn("rofi -show window"), desc="Window Switcher"),
                Key([], "s", lazy.spawn("rofi -show ssh"), desc="SSH Switcher"),
            ],
            name="Launcher",
            desc="Run Launcher",
        ),
        Key([m], "Return", lazy.spawn(my_terminal), desc="Launch terminal"),
        KeyChord(
            [m],
            "s",
            [
                Key([], "n", lazy.group["scratchpad"].dropdown_toggle("note")),
                Key([], "v", lazy.group["scratchpad"].dropdown_toggle("volume")),
                Key([], "b", lazy.group["scratchpad"].dropdown_toggle("btop")),
            ],
            name="Scratchpad",
            desc="Dropdown applications or services.",
        ),
    ]

    mouse = [
        Drag(
            [m],
            "Button1",
            lazy.window.set_position_floating(),
            start=lazy.window.get_position(),
        ),
        Drag(
            [m],
            "Button3",
            lazy.window.set_size_floating(),
            start=lazy.window.get_size(),
        ),
        Click([m], "Button2", lazy.window.bring_to_front()),
    ]
    return keys, mouse
