module Software (withSoftware) where

import           XMonad

import           XMonad.Operations

-- the default configuration import it qualified as W and it seems a gloabl
-- convention
import qualified XMonad.StackSet             as W

-- same as the W
import qualified Data.Map                    as M

import           Data.Bool

import           MachineSpecific
import           Persistent
import           Utils

import           XMonad.Actions.Submap

-- (/=?)
import           XMonad.Hooks.InsertPosition
import           XMonad.Hooks.ManageHelpers

persistentProcesses :: [(String, Window -> X Bool, X ())]
persistentProcesses =
    [
        ( "memo"
        , \w -> runQuery (className =? "nvim-memo") w
        , spawn "alacritty --class 'nvim-memo' --working-directory '/home/baldo/desktop/.nvim-memo' -e nvim"
        )
    ,
        ( "calcolatrice"
        , \w -> runQuery (className =? "python-calcolatrice") w
        , spawn "alacritty --class 'python-calcolatrice' -e python -i -c 'from math import *'"
        )
    ,
        ( "telegram"
        , \w -> runQuery (className =? "TelegramDesktop" <&&> title /=? "Media viewer" <&&> title /=? "Choose Files") w
        , spawn "Telegram"
        )
    ,
        ( "spotify"
        , \w -> runQuery (className =? "Spotify") w
        , spawn "spotify"
        )
    ]

spawnPersistent :: String -> X ()
spawnPersistent = initSpawnPersistent persistentProcesses
smartKill :: X ()
smartKill = initSmartKill persistentProcesses

myColorPicker =
    (spawn "eww open color-picker-menu")
        >> ( submap . M.fromList $
                [ ((0, xK_a), spawn "xcolor -s -f hex")
                , ((0, xK_s), spawn "xcolor -s -f HEX")
                , ((0, xK_d), spawn "xcolor -s -f rgb")
                ]
           )
        >> (spawn "eww close color-picker-menu")

myBluetoothManager =
    (spawn "eww open bluetooth-menu")
        >> ( submap . M.fromList $
                [((0, k), spawn ("bluetooth-manager toggle " ++ c)) | (k, c) <- midrowMappings]
           )
        >> (spawn "eww close bluetooth-menu")

injectKeys :: KeyMask -> M.Map (KeyMask, KeySym) (X ()) -> M.Map (KeyMask, KeySym) (X ())
injectKeys modMask keys =
    insertKeys
        ( [ ((modMask .|. shiftMask, xK_c), smartKill)
          , ((modMask, xK_F1), spawnPersistent "memo")
          , ((modMask, xK_t), spawnPersistent "telegram")
          , ((modMask, xK_y), spawnPersistent "spotify")
          , ((modMask, xK_c), spawnPersistent "calcolatrice")
          , ((modMask .|. shiftMask, xK_e), spawn "eww open power-menu")
          , ((modMask, xK_e), spawn "eww active-windows | grep topbar && eww close topbar || eww open topbar")
          , ((modMask, xK_F8), spawn "dunstctl set-paused toggle && eww update notifications=$(dunstctl is-paused)")
          , ((modMask, xK_a), spawn "rofi -show drun")
          , ((modMask, xK_z), spawn "alacritty")
          , ((modMask, xK_F2), spawn "firefox")
          , ((controlMask .|. shiftMask, xK_p), spawn "firefox --private-window")
          , ((modMask, xK_d), spawn "duplicate-alacritty")
          , -- ((modMask .|. shiftMask, xK_f),     spawn "~/.local/bin/picom-manager toggle"),
            ((mod1Mask .|. controlMask, xK_l), spawn "lockscreen")
          , -- , ((modMask, xK_F10), spawn "screen-saver-toggle && notify $(xset q | grep -oP \"timeout:\\s*\\K\\d*)\"")
            ((modMask, xK_F10), spawn "screen-saver-toggle && eww update caffeine=$(xset q | grep -oP 'timeout:\\s*\\K\\d*')")
          , ((0, xK_Print), spawn "screenshot")
          , ((modMask, xK_g), spawn "screencast")
          , ((modMask .|. shiftMask, xK_g), spawn "pkill -SIGINT screencast")
          , ((modMask, xK_p), spawn "xcolor -s")
          , ((modMask .|. shiftMask, xK_p), myColorPicker)
          , ((modMask, xK_b), myBluetoothManager)
          , ((modMask, xK_minus), spawn "smart-playerctl next")
          , ((modMask, xK_period), spawn "smart-playerctl play-pause")
          , ((modMask, xK_comma), spawn "smart-playerctl previous")
          -- , ((modMask .|. shiftMask, xK_u), spawn "firefox-toggle-full-screen")
          ]
            ++ (machineSpecificKeys modMask)
        )
        keys

injectManageHooks :: ManageHook -> ManageHook
injectManageHooks manageHook =
    composeOne
        [ className =? "TelegramDesktop" <&&> title /=? "Media viewer" <&&> title /=? "Choose Files" -?> doRectFloat centeredRect
        , className =? "TelegramDesktop" <&&> title =? "Media viewer" -?> doFullFloat
        , className =? "Blueberry.py" -?> doCenterFloat
        , className =? "GNU Octave" <&&> title ^? "Figure" -?> doCenterFloat
        , className =? "pavucontrol" -?> doCenterFloat
        , className =? "nvim-memo" -?> doRectFloat centeredRect
        , className =? "python-calcolatrice" -?> doRectFloat centeredRect
        , className =? "Spotify" -?> doRectFloat centeredRectBigger -- Spotify needs to be a bit wider to render nicely
        , pure True -?> manageHook
        ]

withSoftware :: XConfig l -> XConfig l
withSoftware conf@(XConfig{modMask}) =
    conf
        { keys = \cnf -> injectKeys modMask (keys conf cnf)
        , manageHook = injectManageHooks (manageHook conf)
        }
