local mainMod = "SUPER"
local terminal = "alacritty"
local fileManager = "thunar"
local browser = "zen-browser"
local menu = "rofi -show drun -theme ~/.config/rofi/launcher.rasi"
local clipboard = "cliphist list | rofi -dmenu -theme ~/.config/rofi/clipboard.rasi | cliphist decode | wl-copy"
local passManager = "qtpass"

-- Actions
hl.bind(mainMod .. " + X", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
-- hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
-- hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("wlogout -b 4"))
-- hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("~/.config/scripts/reload.sh"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("swaync-client -t -sw"))
-- hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(clipboard))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(passManager))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("flameshot gui"))

hl.bind(mainMod .. " + SHIFT + B", hl.dsp.global("quickshell:showcase"))
hl.bind(mainMod .. " + SPACE", hl.dsp.global("quickshell:launcher"))
hl.bind(mainMod .. " + M", hl.dsp.global("quickshell:controlcenter"))
hl.bind(mainMod .. " + P", hl.dsp.global("quickshell:clipboard"))
hl.bind(mainMod .. " + O", hl.dsp.global("quickshell:osd"))
hl.bind(mainMod .. " + Q", hl.dsp.global("quickshell:logout"))
hl.bind(mainMod .. " + slash", hl.dsp.global("quickshell:help"))
-- hl.bind(mainMod .. " + SHIFT + B", hl.dsp.global("quickshell:testmode"))

-- Media Controls
hl.bind(mainMod .. " + ALT + RETURN", hl.dsp.exec_cmd("alacritty --title rmpc --command rmpc"))
hl.bind(mainMod .. " + ALT + SPACE", hl.dsp.exec_cmd("mpc toggle"))
hl.bind(mainMod .. " + ALT + H", hl.dsp.exec_cmd("mpc seek -5%"))
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("mpc seek +5%"))
hl.bind(mainMod .. " + ALT + J", hl.dsp.exec_cmd("amixer set Master 5%-"))
hl.bind(mainMod .. " + ALT + K", hl.dsp.exec_cmd("amixer set Master 5%+"))
hl.bind(mainMod .. " + ALT + N", hl.dsp.exec_cmd("mpc next"))
hl.bind(mainMod .. " + ALT + P", hl.dsp.exec_cmd("mpc prev"))

-- Navigations
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Workspaces
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.focus({ workspace = 10 }))

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    -- hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
