import XMonad

import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Spacing

appLauncher = "rofi -modi drun,ssh,window -show drun -show-icons"
lockScreen = "betterlockscreen --wall --blur -l"

main :: IO()
main = xmonad $ ewmh def {
    modMask = mod4Mask,
    terminal = "kitty",
    layoutHook = avoidStruts $ spacing 4 (layoutHook defaultConfig)
  }
  `additionalKeysP`
  [
  ("M-d", spawn appLauncher ),
  ("M-S-l", spawn lockScreen )
  ]
