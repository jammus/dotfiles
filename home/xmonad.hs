import XMonad

import XMonad.Actions.UpdatePointer
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig
import XMonad.Util.Ungrab

appLauncher = "rofi -modi drun,ssh,window -show drun -show-icons"
lockScreen = "betterlockscreen --wall --blur -l"

xmonadConfig = def {
    modMask = mod4Mask,
    terminal = "kitty",
    normalBorderColor = "#504945",
    focusedBorderColor = "#e78a43",
    borderWidth = 2,
    layoutHook = avoidStruts $ spacing 4 (layoutHook defaultConfig ||| emptyBSP),
    focusFollowsMouse = False,
    logHook = updatePointer (0.5, 0.5) (0, 0)
  }
  `additionalKeysP`
  [
  ("M-d", spawn appLauncher ),
  ("M-S-l", spawn lockScreen )
  ]

main :: IO()
main = xmonad $ ewmh $ xmobarProp $ xmonadConfig
