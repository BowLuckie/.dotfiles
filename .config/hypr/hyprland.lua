-- ~/.config/hypr/hyprland.lua
-- Main entry point. Everything else lives in its own file.

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

require("startup")
require("appearance")
require("input")
require("keybinds")
require("rules")
