import XMonad

import XMonad.Actions.UpdatePointer
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Grid
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
    borderWidth = 3,
    layoutHook = smartBorders . avoidStruts $ spacing 10 (layoutHook defaultConfig ||| emptyBSP ||| ResizableTall 1 (3/100) (1/2) [] ||| Grid),
    focusFollowsMouse = False,
    manageHook = composeAll [
        isFullscreen --> doFullFloat,
        manageHook defaultConfig
    ],
    logHook = updatePointer (0.5, 0.5) (0, 0)
  }
  `additionalKeysP`
  [
  ("M-d", spawn appLauncher ),
  ("M-S-l", spawn lockScreen ),
  ("M-m", sendMessage MirrorShrink ),
  ("M-u", sendMessage MirrorExpand )
  ]

main :: IO()
main = xmonad $ ewmh $ xmobarProp $ xmonadConfig
