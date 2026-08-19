hl.window_rule({
    name = "pip",
    match = { title = "Picture-in-Picture" },
    float = true,
    keep_aspect_ratio = true
    -- move = "20 monitor_w-120"
})
hl.window_rule({
    name = "file-progress-float",
    match = { title = "File Operation Progress" },
    float = true,
    size = "510 102"
})
hl.window_rule({
    name = "feh",
    match = { class = "feh" },
    float = true,
})
hl.window_rule({
    name = "spotify-float",
    match = { class = "Spotify" },
    float = true,
})
hl.window_rule({
    name = "spotube-float",
    match = { class = "spotube" },
    float = true,
})
hl.window_rule({
    name = "scrcpy-float",
    match = { class = "scrcpy" },
    float = true,
    keep_aspect_ratio = true
})
hl.window_rule({
    name = "qtpass-float",
    match = { title = "QtPass" },
    float = true,
    no_screen_share = true
})
hl.window_rule({
    name = "rmpc-float",
    match = { title = "rmpc" },
    float = true,
})
hl.window_rule({
    name = "kicad-tile",
    match = { title = "KiCad" },
    float = true,
})
hl.window_rule({
    name = "ueberzugpp-float",
    match = { class = "^(ueberzugpp)(.*)$" },
    float = true,
    no_initial_focus = true
})
hl.window_rule({
    name = "qtcreator-preview-float",
    match = { title = "^(Hello World)(.*)$" },
    float = true,
})
hl.window_rule({
    name = "qtcreator-waiting-float",
    match = { title = "^(Waiting for Applications to Stop — Qt Creator)(.*)$" },
    float = true,
})
hl.window_rule({
    name = "blender-fullscreen",
    -- match = { class = "blender", title = "(Unsaved) - Blender .*" },
    -- match = { title = "(Unsaved) - Blender 5.0.1" },
    match = { class = "blender" },
    fullscreen = true
})
-- hl.window_rule({
--     name = "blender-float",
--     match = { class = "blender" },
--     float = true,
-- })
hl.window_rule({
    name = "freecad-fullscreen",
    match = { class = "org.freecad.FreeCAD", title = "FreeCAD 1.1.1" },
    fullscreen = true
})
hl.window_rule({
    name = "freecad-popups-float",
    match = { class = "org.freecad.FreeCAD" },
    float = true
})
