-- Send backtick & forwardtick immediately, also make backtick default
hs.hotkey.bind({}, '´', function()
  hs.eventtap.keyStrokes("`")
end)
hs.hotkey.bind({ "shift" }, '´', function()
  hs.eventtap.keyStrokes("´")
end)

-- Send tilde directly
hs.hotkey.bind({ 'alt' }, '¨', function()
  hs.eventtap.keyStrokes("~")
end)

hs.loadSpoon("LeftRightHotkey"):start()

spoon.LeftRightHotkey:bind({ "rOpt" }, "9", function()
  hs.eventtap.keyStrokes("9")
end)

spoon.LeftRightHotkey:bind({ "rOpt" }, "7", function()
  hs.eventtap.keyStrokes("7")
end)

spoon.LeftRightHotkey:bind({ "lShift" }, "2", function()
  hs.eventtap.keyStrokes("2")
end)
