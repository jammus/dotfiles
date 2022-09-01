import XMonad

import XMonad.Util.EZConfig
import XMonad.Util.Ungrab

appLauncher = "rofi -modi drun,ssh,window -show drun -show-icons"

main :: IO()
main = xmonad $ def
  { modMask = mod4Mask,
    terminal = "alacritty"
  }
  `additionalKeysP`
  [ ("M-d", spawn appLauncher )
  ]
