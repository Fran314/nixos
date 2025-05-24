module StatusBar where

import XMonad

import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

myPP :: PP
myPP =
    def
        { ppCurrent = \name -> name
        , ppHidden = \_ -> ""
        , ppUrgent = \_ -> ""
        , ppOrder = \(ws : _ : _ : _) -> [ws]
        }

ewwTopBar :: StatusBarConfig
ewwTopBar = statusBarProp "eww open topbar" (pure myPP)

withEwwTB :: LayoutClass l Window
       => XConfig l
	   -> XConfig l
withEwwTB = withSB ewwTopBar
