module MachineSpecific (
    machineSpecificKeys,
    machineSpecificManageHook,
) where

import           XMonad

import qualified Data.Map                     as M

import           XMonad.Actions.Submap

import           Graphics.X11.ExtraTypes.XF86

myMonitorManager =
    (spawn "eww open monitor-menu")
        >> ( submap . M.fromList $
                [ ((0, xK_a), spawn "monitor-manager auto")
                , ((0, xK_s), spawn "monitor-manager split")
                , ((0, xK_d), spawn "monitor-manager duplicate")
                , ((0, xK_f), spawn "monitor-manager follow")
                ]
           )
        >> (spawn "eww close monitor-menu")

myVPNManager =
    (spawn "eww open vpn-menu")
        >> ( submap . M.fromList $
                [ ((0, xK_a), spawn "toggle-vpn home")
                , ((0, xK_s), spawn "toggle-vpn proton")
                ]
           )
        >> (spawn "eww close vpn-menu")

machineSpecificKeys :: KeyMask -> [((KeyMask, KeySym), X ())]
machineSpecificKeys modMask =
    -- hardware interaction
    [ ((0, xF86XK_AudioLowerVolume), spawn "pamixer -d 25")
    , ((0, xF86XK_AudioRaiseVolume), spawn "pamixer -i 25")
    , ((shiftMask, xF86XK_AudioLowerVolume), spawn "pamixer -d 10")
    , ((shiftMask, xF86XK_AudioRaiseVolume), spawn "pamixer -i 10 --allow-boost")
    , ((0, xF86XK_AudioMute), spawn "pamixer -t")
    , ((0, xF86XK_MonBrightnessUp), spawn "set-brightness +")
    , ((0, xF86XK_MonBrightnessDown), spawn "set-brightness -")
    ]
        ++
        -- other
        [ ((modMask, xK_s), myMonitorManager)
        , ((modMask, xK_u), spawn "reconnect-wifi")
        , ((modMask .|. shiftMask, xK_u), myVPNManager)
        , ((modMask .|. controlMask, xK_u), spawn "toggle-hotspot")
        ]

machineSpecificManageHook :: ManageHook
machineSpecificManageHook = composeAll []
