import XMonad

import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Hooks.EwmhDesktops

appLauncher = "rofi -modi drun,ssh,window -show drun -show-icons"

main :: IO()
main = xmonad $ ewmh def
  { modMask = mod4Mask,
    terminal = "kitty"
  }
  `additionalKeysP`
  [ ("M-d", spawn appLauncher )
  ]
