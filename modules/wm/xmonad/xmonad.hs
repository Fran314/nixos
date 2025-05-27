-- the default configuration import it qualified as W and it seems a gloabl
-- convention

-- same as the W
import qualified Data.Map                     as M
import           Graphics.X11.ExtraTypes.XF86
import           Persistent
import           Software
import           StatusBar
import           StickyWindows
import           Utils
import           XMonad
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.InsertPosition
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.UrgencyHook
import           XMonad.Layout.Fullscreen
import           XMonad.Layout.Grid
import           XMonad.Layout.IfMax
import           XMonad.Layout.LayoutBuilder
import           XMonad.Layout.NoBorders
import           XMonad.Layout.ResizableTile
import           XMonad.Layout.Spacing
import           XMonad.Layout.ToggleLayouts
import qualified XMonad.StackSet              as W
import           XMonad.Util.Hacks            (fixSteamFlicker)

myWorkspaces :: [String]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "dashboard", "scratchpad"]

myWorkspacesKeys :: [KeySym]
myWorkspacesKeys = [xK_1 .. xK_9] ++ [xK_backslash, xK_0]

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

myResizableSmallTall = ResizableTall 1 (3 / 100) (2 / 3) []

myResizableBigTall = ResizableTall 1 (3 / 100) (3 / 5) []

-- relBox units are weird. X & Y (the first two arguments) are relative to the whole
-- screen space, while W & H (the last two arguments) are relative to the REMAINING
-- screen space.
-- So for a window that starts halfway and goes to the end, the width is 1 (all the
-- remaining with) and not 1/2 (half of the screen width)
myFakeSpiral =
    ( (layoutN 1 (relBox 0 0 (1 / 2) 1) (Just $ relBox 0 0 1 1) $ Grid) $
        (layoutAll (relBox (1 / 2) 0 1 1) $ Mirror $ myResizableBigTall)
    )

fullscreenLayout = noBorders $ (Full ||| myVerticalGrid)

defaultLayout = lessBorders OnlyLayoutFloatBelow $ spacingWithEdge 6 $ avoidStruts $ (myFakeSpiral ||| myResizableSmallTall)

myLayout = toggleLayouts fullscreenLayout defaultLayout

myManageHook =
    composeAll
        [ isDialog --> doCenterFloat
        , fmap not willFloat --> insertPosition End Newer
        ]

myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
-- myKeys is a function that takes in input a configuration instead of just
-- being a list so that it can access the configuration modifier instead of
-- hardcoding it
--
-- the `@` syntax seems scary but it's just variable destructuring
myKeys conf@(XConfig{modMask, workspaces}) =
    M.fromList $
        -- defaults-ish
        [ ((modMask, xK_j), windows W.focusDown)
        , ((modMask, xK_k), windows W.focusUp)
        , ((modMask .|. shiftMask, xK_j), windows W.swapDown)
        , ((modMask .|. shiftMask, xK_k), windows W.swapUp)
        , ((modMask, xK_h), sendMessage Shrink)
        , ((modMask, xK_l), sendMessage Expand)
        , ((modMask, xK_space), sendMessage NextLayout)
        , ((modMask, xK_f), sendMessage ToggleLayout)
        , ((modMask, xK_n), withFocused $ windows . W.sink)
        -- , ((modMask .|. shiftMask, xK_c), kill) -- overridden by smartKill in module Software
        ]
            ++
            -- worskpace bindings
            [ ((modMask, k), windows $ (W.greedyView i))
            | (i, k) <- zip workspaces myWorkspacesKeys
            ]
            ++ [ ((modMask .|. shiftMask, k), (windows $ W.shift i) >> (windows $ (W.greedyView i)))
               | (i, k) <- zip workspaces myWorkspacesKeys
               ]

main :: IO ()
main =
    xmonad . withSoftware . withStickyWindows . withEwwTB . withUrgencyHook NoUrgencyHook . ewmhFullscreen . ewmh . docks $
        def
            { modMask = mod4Mask
            , terminal = "alacritty"
            , borderWidth = 3
            , normalBorderColor = "#28282A"
            , focusedBorderColor = "#388E3C"
            , workspaces = myWorkspaces
            , layoutHook = myLayout
            , manageHook = myManageHook
            , handleEventHook = fixSteamFlicker <+> handleEventHook def
            , keys = myKeys
            }
