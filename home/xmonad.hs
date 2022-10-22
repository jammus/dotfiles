import XMonad

import XMonad.Actions.UpdatePointer
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig
import XMonad.Util.Ungrab

appLauncher = "rofi -modi drun,ssh,window -show drun -show-icons"
lockScreen = "betterlockscreen --wall --blur -l"

main :: IO()
main = xmonad $ ewmh def {
    modMask = mod4Mask,
    terminal = "kitty",
    layoutHook = avoidStruts $ spacing 4 (layoutHook defaultConfig ||| emptyBSP),
    focusFollowsMouse = False,
    logHook = updatePointer (0.5, 0.5) (0, 0)
  }
  `additionalKeysP`
  [
  ("M-d", spawn appLauncher ),
  ("M-S-l", spawn lockScreen )
  ]
