hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

local terminal = "ghostty"
local fileManager = "nautilus"
local menu = "rofi -show run -theme ~/.dotfiles/.config/rofi/themes/gruvbox.rasi -show-icons"

hl.on("hyprland.start", function()
    hl.exec_cmd("$HOME/.config/hypr/scripts/waybar-starter.sh & sleep 1 && $HOME/.config/hypr/scripts/waybar_auto_hide")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd('hyprctl plugin load "$(realpath ~/Hyprspace/Hyprspace.so)"')
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("PATH", os.getenv("HOME") .. "/.local/bin:" .. os.getenv("HOME") .. "/bin:/usr/local/bin:/usr/bin")

hl.config({
    general = {
        gaps_in          = 5,
        gaps_out         = 5,

        border_size      = 2,

        col              = {
            active_border   = { colors = { "#8ec07cee", "#b8bb26ee" }, angle = 45 },
            inactive_border = "#7c6f64aa",
        },

        resize_on_border = false,

        allow_tearing    = false,

        layout           = "dwindle",
    },

    decoration = {
        rounding         = 5,
        rounding_power   = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow           = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur             = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 238.1191, damping = 24.21279333 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0, rounding = 0 })

hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})


hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})

hl.config({
    layers = {
        allow_new_top_layers_over_existing_fullscreen = true,
    },
})

hl.config({
    input = {
        kb_layout    = "us",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "",
        kb_rules     = "",

        follow_mouse = 1,

        sensitivity  = 0,

        touchpad     = {
            natural_scroll = false,
        },
    },
})

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.bind("ALT + TAB", function()
    hl.dispatch(hl.dsp.window.cycle_next())
end, { description = "Cycle to next window" })

hl.bind("ALT + SHIFT + TAB", function()
    hl.dispatch(hl.dsp.window.cycle_next({ reverse = true }))
end, { description = "Cycle to previous window" })

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle onlnu

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind("SUPER + TAB", function()
    hl.plugin.overview.toggle("all")
    hl.dsp.exec_cmd("pkill -SIGUSR1 waybar")
end, { description = "Toggle Hyprspace overview on all monitors" })

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


local suppressMaximizeRule = hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name = "blueman-floating",
    match = {
        class = "^(blueman-manager)$"
    },
    float = true,
    center = true,
    size = "800 600"
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.config({
    plugin = {
        overview = {
            overrideGaps = false,
        },
    },
})

hl.workspace_rule({
    workspace = "1",
    monitor = "HDMI-A-1",
    default = true,
    persistent = true,
})

hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1", persistent = true })

hl.workspace_rule({
    workspace = "5",
    monitor = "DP-2",
    default = true,
    persistent = true,
})

hl.workspace_rule({ workspace = "6", monitor = "DP-2", persistent = true })
hl.workspace_rule({ workspace = "7", monitor = "DP-2", persistent = true })
hl.workspace_rule({ workspace = "8", monitor = "DP-2", persistent = true })
