import XMonad

import XMonad.Operations

import XMonad.Util.EZConfig

-- the default configuration import it qualified as W and it seems a gloabl
-- convention
import qualified XMonad.StackSet as W

-- same as the W
import qualified Data.Map as M

import Data.Bool
import Data.List
import Data.Ratio

import Control.Monad

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.UrgencyHook

import XMonad.Layout.Fullscreen
import XMonad.Layout.Grid
import XMonad.Layout.ResizableTile
import XMonad.Layout.SimpleDecoration
import XMonad.Layout.Spacing
import XMonad.Layout.ToggleLayouts

import XMonad.Layout.IfMax
import XMonad.Layout.NoBorders

import Graphics.X11.ExtraTypes.XF86

import XMonad.Actions.Submap

import XMonad.Actions.TagWindows

-- Add to the keymaps something like
-- (( mask, key ), submap . M.fromList $ menuSubmaps)
--
-- eventually with something like a visual menu made in eww, with:
-- (( mask, key ), (spawn "eww open <menu>") >> (submap . M.fromList $ menuSubmaps) >> (spawn "eww close <menu>"))
menuSubmaps :: [((KeyMask, KeySym), X ())]
menuSubmaps = [((0, xK_c), (spawn "notify-send ciao") >> (submap . M.fromList $ menuSubmaps))]

midrowMappings :: [(KeySym, String)]
midrowMappings = [(xK_a, "0"), (xK_s, "1"), (xK_d, "2"), (xK_f, "3"), (xK_g, "4"), (xK_h, "5"), (xK_j, "6"), (xK_k, "7"), (xK_l, "8")]

myWorkspaces :: [String]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "dashboard", "scratchpad"]

moveToWorkspace :: String -> X ()
moveToWorkspace i = do
    windows $ (W.greedyView i)
    withTaggedGlobal
        "stickywindow"
        ( \win -> do
            windows $ W.shiftWin i win
            windows $ W.focusDown -- the moved sticky window gets focus by
            -- default, but this behaviour is not
            -- wanted, so for each window move the
            -- focus down
        )
    refresh

toggleTag :: String -> Window -> X ()
toggleTag tag w = do
    windowHasTag <- hasTag tag w
    if windowHasTag
        then delTag tag w
        else addTag tag w

borderColorTest :: Window -> X ()
borderColorTest win = do
    XConf{display = d, normalBorder = nbc} <- ask
    setWindowBorderWithFallback d win "#000000" nbc
    return ()

-------------------------------------------------------------------------------
-- Sticky Windows
max_sticky_size :: Rational
max_sticky_size = 2 / 3
min_sticky_size :: Rational
min_sticky_size = 1 / 10

sticky_size_steps :: Integer
sticky_size_steps = 10
sticky_size_min_step :: Integer
sticky_size_min_step = 0
sticky_size_default_step :: Integer
sticky_size_default_step = 5

whenStickyWithFallback :: (Window -> X (), X ()) -> Window -> X ()
whenStickyWithFallback (f, g) win = do
    isSticky <- hasTag "stickywindow" win
    if isSticky
        then do
            f win
            updateStickyWindow win
        else do
            g

whenSticky :: (Window -> X ()) -> Window -> X ()
whenSticky f win = do
    isSticky <- hasTag "stickywindow" win
    if isSticky
        then do
            f win
            updateStickyWindow win
        else pure ()


toggleSticky :: Window -> X ()
toggleSticky w = do
    isSticky <- hasTag "stickywindow" w
    if isSticky
        then (delTag "stickywindow" w) >> (windows $ W.sink w)
        else (addTag "stickywindow" w) >> (updateStickyWindow w)

-- toggleStickyHidden :: Window -> X ()
-- toggleStickyHidden win = do
--     isHidden <- hasTag "hidden" win
--     if isHidden then (delTag "hidden" win) >> (windows $ shiftHere win)
--     else (addTag "hidden" win) >> (windows $ W.shiftWin "scratchpad" win)

deleteStickySize :: Window -> X ()
deleteStickySize win = do
    let recursion d = do
            if d >= sticky_size_min_step
                then do
                    delTag ("stickysize" ++ (show d)) win
                    recursion (d - 1)
                else pure ()
    recursion sticky_size_steps

getStickySize :: Window -> X Integer
getStickySize win = do
    let recursion d = do
            found <- hasTag ("stickysize" ++ (show d)) win
            if found
                then return d
                else
                    if d > sticky_size_min_step
                        then do
                            s <- recursion (d - 1)
                            return s
                        else return sticky_size_default_step -- if nothing found, return default size (middle)
    recursion sticky_size_steps

changeStickySize :: Integer -> Window -> X ()
changeStickySize i win = do
    let clamp a v b = do
            if v > b
                then return b
                else
                    if v < a
                        then return a
                        else return v
    s <- getStickySize win
    deleteStickySize win
    ns <- clamp sticky_size_min_step (s + i) sticky_size_steps
    addTag ("stickysize" ++ (show ns)) win

moveSticky :: String -> Window -> X ()
moveSticky = toggleTag

updateStickyWindow :: Window -> X ()
updateStickyWindow win = do
    s <- getStickySize win
    isTop <- hasTag "stickyshiftvert" win
    isLeft <- hasTag "stickyshifthoriz" win

    p <- return (min_sticky_size + (s % sticky_size_steps) * (s % sticky_size_steps) * (max_sticky_size - min_sticky_size))
    x <- if isLeft then return (28 / 1920) else return (1 - p - 28 / 1920)
    -- y <- if isTop then return (28 / 1080) else return (1 - p - 28 / 1080)
    -- y <- if isTop then return (96 / 1080) else return (1 - p - 28 / 1080) -- Leave margin for firefox tabs
    y <- if isTop then return (28 / 1080) else return (1 - p - 64 / 1080)   -- Topbar at bottom (bottombar I guess)
    windows $ W.float win (W.RationalRect x y p p)

hasTagHook :: String -> Query Bool
hasTagHook tag = ask >>= \w -> liftX $ hasTag tag w

--------------------------------------------------------------------------------
-- Persistent processes

persistentProcesses :: M.Map String (Window -> X Bool, X ())
persistentProcesses =
    M.fromList
        [
            ( "memo"
            ,
                ( \w -> runQuery (className =? "nvim-memo") w
                , spawn "alacritty --class 'nvim-memo' --working-directory '/home/baldo/desktop/.nvim-memo' -e nvim"
                )
            )
        ,
            ( "telegram"
            ,
                ( \w -> runQuery (className =? "TelegramDesktop" <&&> title /=? "Media viewer" <&&> title /=? "Choose Files") w
                , spawn "telegram-desktop"
                )
            )
        ,
            ( "spotify"
            ,
                ( \w -> runQuery (className =? "Spotify") w
                , spawn "spotify-launcher"
                )
            )
        ]

findWindows :: (Window -> X Bool) -> X [Window]
findWindows condition = do
    withWindowSet $
        ( \ws -> do
            forM
                (W.allWindows ws)
                ( \w -> do
                    s <- condition w
                    return $ bool [] [w] s :: X [Window]
                )
                >>= return . join
        )

spawnPersistent :: String -> X ()
spawnPersistent name = do
    let Just (procIdentifier, procCommand) = M.lookup name persistentProcesses
    procWindows <- findWindows procIdentifier
    if (length procWindows > 0)
        then windows $ (shiftHere (head procWindows))
        else procCommand

smartKill :: X ()
smartKill = withFocused f
  where
    f w = do
        shouldLive <- do
            forM
                (M.toList persistentProcesses)
                ( \(_, (procIdentifier, _)) -> do
                    res <- procIdentifier w
                    return res
                )
                >>= return . or
        currWorkspace <- withWindowSet (pure . W.currentTag)
        if shouldLive && currWorkspace /= "scratchpad"
            then windows $ W.shift "scratchpad"
            else kill

-- myLayout = toggleLayouts
--     (noBorders Full)
--     (lessBorders OnlyLayoutFloatBelow
--     $ spacingWithEdge 6
--     $ avoidStruts
--     $ IfMax 1
--         (Full)
--         (Tall 1 (3/100) (2/3) ||| (Grid))
--     )

myVerticalGrid = IfMax 2 (Mirror (Grid)) (Grid)
myResizableTall = ResizableTall 1 (3 / 100) (2 / 3) []
fullscreenLayout = noBorders $ (Full ||| myVerticalGrid)
defaultLayout = lessBorders OnlyLayoutFloatBelow $ spacingWithEdge 6 $ avoidStruts $ (myVerticalGrid ||| myResizableTall)
myLayout = toggleLayouts fullscreenLayout defaultLayout

centeredRect =       W.RationalRect (7 / 24) (1 / 6) (5 / 12) (2 / 3)
centeredRectBigger = W.RationalRect (1 / 4)  (1 / 6) (1 / 2)  (2 / 3)
myManageHook =
    composeAll
        [ composeOne
            [ className =? "TelegramDesktop" <&&> title /=? "Media viewer" -?> doRectFloat centeredRect
            , className =? "TelegramDesktop" <&&> title =? "Media viewer" -?> doRectFloat (W.RationalRect 0 0 1 1)
            , className =? "Blueberry.py" -?> doCenterFloat
            , className =? "GNU Octave" <&&> title ^? "Figure" -?> doCenterFloat
            , className =? "Pavucontrol" -?> doRectFloat centeredRect
            , className =? "nvim-memo" -?> doRectFloat centeredRect
            , className =? "Spotify" -?> doRectFloat centeredRectBigger -- Spotify needs to be a bit wider to render nicely
            , hasTagHook "stickywindow" -?> doRectFloat centeredRect
            , isDialog -?> doCenterFloat
            , fmap not willFloat -?> insertPosition End Newer
            ]
        , manageDocks
        ]

-- note: we can't just open the menu before the submap and close
-- the menu after the submap (like in the bluetooth menu example)
-- because the color we want to pick might be under the menu, so
-- it must be closed before the color-picker, but (clearly) after
-- the submap key has been pressed
-- myColorPicker = (spawn "eww open color-picker-menu")
--     >> ( submapDefault (spawn "eww close color-picker-menu") . M.fromList $
--             [ ((0, k), spawn ("eww close color-picker-menu; my-color-picker " ++ c))
--             | (k, c) <-
--                 [ (xK_a, "hex")
--                 , (xK_s, "HEX")
--                 , (xK_d, "rgb")
--                 , (xK_f, "frgb")
--                 ]
--             ]
--        )

myColorPicker = (spawn "eww open color-picker-menu")
    >> ( submap . M.fromList $
            [ ((0, k), spawn ("xcolor -s -f " ++ c))
            | (k, c) <-
                [ (xK_a, "hex")
                , (xK_s, "HEX")
                , (xK_d, "rgb")
                ]
            ]
       )
    >> (spawn "eww close color-picker-menu")

myBluetoothManager = (spawn "eww open bluetooth-menu")
    >> ( submap . M.fromList $
            [((0, k), spawn ("my-bluetooth-manager toggle " ++ c)) | (k, c) <- midrowMappings]
       )
    >> (spawn "eww close bluetooth-menu")

myMonitorManager = (spawn "eww open monitor-menu")
    >> ( submap . M.fromList $
            [ ((0, k), spawn ("my-monitor-manager " ++ c))
            | (k, c) <-
                [ (xK_a, "auto")
                , (xK_s, "split")
                , (xK_d, "duplicate")
                , (xK_f, "follow")
                ]
            ]
       )
    >> (spawn "eww close monitor-menu")

myKeyBindings =
    [ ((mod4Mask .|. shiftMask, xK_c), smartKill)
    , ((mod4Mask .|. shiftMask, xK_e), spawn "eww open powermenu")
    , ((mod4Mask, xK_F1), spawnPersistent "memo")
    , ((mod4Mask, xK_F2), spawn "firefox")
    , ((controlMask .|. shiftMask, xK_p), spawn "firefox --private-window")
    -- , ((mod4Mask, xK_F3), unGrab *> spawn "~/.local/bin/open-current-project")
    , ((mod4Mask, xK_F8), spawn "dunstctl set-paused toggle && eww update notifications=$(dunstctl is-paused)")
    , ((mod4Mask, xK_a), spawn "rofi -show drun")
    , ((mod4Mask, xK_z), spawn "alacritty")
    , ((mod4Mask, xK_t), spawnPersistent "telegram")
    , ((mod4Mask, xK_y), spawnPersistent "spotify")
    , ((mod4Mask, xK_d), spawn "my-duplicate-alacritty")
    -- , ((mod4Mask, xK_v), spawn "~/.local/bin/vpn-toggle")
    -- , ((mod4Mask .|. shiftMask, xK_f), spawn "~/.local/bin/picom-manager toggle")
    , ((mod4Mask, xK_f), sendMessage ToggleLayout)
    , ((mod4Mask, xK_n), withFocused $ windows . W.sink)
    , ((0, xF86XK_AudioLowerVolume), spawn "pamixer -d 25")
    , ((0, xF86XK_AudioRaiseVolume), spawn "pamixer -i 25")
    , ((shiftMask, xF86XK_AudioLowerVolume), spawn "pamixer -d 10")
    , ((shiftMask, xF86XK_AudioRaiseVolume), spawn "pamixer -i 10 --allow-boost")
    , ((0, xF86XK_AudioMute), spawn "pamixer -t")
    , ((0, xF86XK_MonBrightnessUp), spawn "my-set-brightness +")
    , ((0, xF86XK_MonBrightnessDown), spawn "my-set-brightness -")
    , ((mod1Mask .|. controlMask, xK_l), spawn "my-lockscreen")
    , ((0, xK_Print), spawn "my-screenshot")
    , ((mod4Mask, xK_g), spawn "my-screencast")
    , ((mod4Mask .|. shiftMask, xK_g), spawn "pkill -SIGINT my-screencast")
    , ((mod4Mask, xK_u), spawn "my-reconnect-wifi")
    -- , ((mod4Mask, xK_u), spawn "~/.local/bin/reload-connection-that-occasionally-drops")
    -- , ((mod4Mask, xK_p), spawn "my-color-picker hex")
    , ((mod4Mask, xK_p), spawn "xcolor -s")
    , ((mod4Mask .|. shiftMask, xK_p), myColorPicker)
    , ((mod4Mask, xK_b), myBluetoothManager)
    , ((mod4Mask, xK_s), myMonitorManager)

    , ((mod4Mask, xK_backslash), windows $ W.greedyView "dashboard")
    , ((mod4Mask, xK_0), windows $ W.greedyView "scratchpad")

    , ((mod4Mask, xK_o), withFocused toggleSticky)
    , ((mod4Mask .|. shiftMask, xK_o), withTaggedGlobalP "stickywindow" (W.shiftWin "scratchpad"))
    , ((mod4Mask, xK_Left), withFocused $ whenSticky $ moveSticky "stickyshifthoriz")
    , ((mod4Mask, xK_Right), withFocused $ whenSticky $ moveSticky "stickyshifthoriz")
    , ((mod4Mask, xK_Up), withFocused $ whenSticky $ moveSticky "stickyshiftvert")
    , ((mod4Mask, xK_Down), withFocused $ whenSticky $ moveSticky "stickyshiftvert")
    , ((mod4Mask, xK_plus), withFocused $ whenSticky $ changeStickySize (1))
    -- combine mod+minus into changeStickySize AND playerctl next as they collide
    -- , ((mod4Mask, xK_minus), withFocused $ whenSticky $ changeStickySize (-1))
    , ((mod4Mask, xK_minus), withFocused $ whenStickyWithFallback $ (changeStickySize (-1), spawn "playerctl next"))
    -- , ((mod4Mask, xK_minus), spawn "playerctl next")
    , ((mod4Mask, xK_period), spawn "playerctl play-pause")
    , ((mod4Mask, xK_comma), spawn "playerctl previous")
    ]
        ++ [ ((mod4Mask, k), moveToWorkspace i)
           | (i, k) <- zip (map show [1 .. 9]) [xK_1 .. xK_9]
           ]
        ++ [ ((mod4Mask .|. shiftMask, k), (windows $ W.shift i) >> (moveToWorkspace i))
           | (i, k) <- zip (map show [1 .. 9]) [xK_1 .. xK_9]
           ]

myPP :: PP
myPP =
    def
        { ppCurrent = \name -> name
        , ppHidden = \_ -> ""
        , ppUrgent = \_ -> ""
        , ppOrder = \(ws : _ : _ : _) -> [ws]
        }

mySB :: StatusBarConfig
mySB = statusBarProp "eww open topbar" (pure myPP)

main :: IO ()
main =
    xmonad . withSB mySB . withUrgencyHook NoUrgencyHook . ewmhFullscreen . ewmh . docks $
        def
            { modMask = mod4Mask
            , terminal = "alacritty"
            , borderWidth = 3
            -- , normalBorderColor = "#388E3C"
            -- , focusedBorderColor = "#28282A"
            , normalBorderColor = "#28282A"
            , focusedBorderColor = "#388E3C"
            , -- , normalBorderColor = "#2f4930"
              -- , focusedBorderColor = "#388E3C"
              workspaces = myWorkspaces
            , layoutHook = myLayout
            , manageHook = myManageHook
            }
            `additionalKeys` myKeyBindings
