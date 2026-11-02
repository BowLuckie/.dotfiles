-- ~/.config/hypr/keybinds.lua

local terminal = "ghostty"
local fileManager = "nautilus"
local menu = "rofi -show run -theme ~/.dotfiles/.config/rofi/themes/gruvbox.rasi -show-icons"

local mainMod = "SUPER"

-- Window cycling
hl.bind("ALT + TAB", function()
    hl.dispatch(hl.dsp.window.cycle_next())
end, { description = "Cycle to next window" })

hl.bind("ALT + SHIFT + TAB", function()
    hl.dispatch(hl.dsp.window.cycle_next({ reverse = true }))
end, { description = "Cycle to previous window" })

-- Apps and window management
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- Focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- Overview
hl.bind("SUPER + TAB", function()
    hl.plugin.overview.toggle("all")
    hl.dsp.exec_cmd("pkill -SIGUSR1 waybar")
end, { description = "Toggle Hyprspace overview on all monitors" })

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse drag / resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume / brightness (swayosd)
hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("swayosd-client --output-volume raise"),
    { locked = true, repeating = true })

hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("swayosd-client --output-volume lower"),
    { locked = true, repeating = true })

hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),
    { locked = true })

hl.bind("XF86AudioMicMute",
    hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),
    { locked = true })

hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd("swayosd-client --brightness raise"),
    { locked = true, repeating = true })

hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd("swayosd-client --brightness lower"),
    { locked = true, repeating = true })

-- Media
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
