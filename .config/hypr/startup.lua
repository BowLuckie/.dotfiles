hl.on("hyprland.start", function()
    hl.exec_cmd("multibar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd('hyprctl plugin load "$(realpath ~/Hyprspace/Hyprspace.so)"')
    hl.exec_cmd("swayosd-server")
end)

local home = os.getenv("HOME")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("PATH", os.getenv("HOME") .. "/.local/bin:" .. os.getenv("HOME") .. "/bin:/usr/local/bin:/usr/bin")
hl.env("PATH", home .. "/.local/bin:" .. home .. "/bin:" .. home .. "/.config/hypr/scripts:/usr/local/bin:/usr/bin")

hl.config({
    plugin = {
        overview = {
            overrideGaps = false,
        },
    },
})
