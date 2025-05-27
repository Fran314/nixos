module StickyWindows (withStickyWindows) where

import           XMonad

import           Utils

-- the default configuration import it qualified as W and it seems a gloabl
-- convention
import qualified XMonad.StackSet            as W

-- same as the W
import qualified Data.Map                   as M

import           Data.Ratio

import           XMonad.Actions.TagWindows

import           XMonad.Hooks.ManageHelpers

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

toggleTag :: String -> Window -> X ()
toggleTag tag w = do
    windowHasTag <- hasTag tag w
    if windowHasTag
        then delTag tag w
        else addTag tag w

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
    y <- if isTop then return (28 / 1080) else return (1 - p - 64 / 1080) -- Topbar at bottom (bottombar I guess)
    windows $ W.float win (W.RationalRect x y p p)

hasTagHook :: String -> Query Bool
hasTagHook tag = ask >>= \w -> liftX $ hasTag tag w

stickyWindowFloat :: ManageHook
stickyWindowFloat = hasTagHook "stickywindow" --> doFloat

moveToWorkspace :: String -> X ()
moveToWorkspace i = do
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

adjustAllWorkspaces :: KeyMask -> (M.Map (KeyMask, KeySym) (X ())) -> (M.Map (KeyMask, KeySym) (X ()))
adjustAllWorkspaces modMask keys =
    ( foldr
        (.)
        id
        [ (M.adjust (\p -> p >> moveToWorkspace i) (modMask, k))
            . (M.adjust (\p -> p >> moveToWorkspace i) (modMask .|. shiftMask, k))
        | (i, k) <- zip (map show [1 .. 9]) [xK_1 .. xK_9]
        ]
    )
        $ keys

appendWhenStickyWithFallback :: (Window -> X ()) -> (X () -> X (), X ())
appendWhenStickyWithFallback command =
    ( \fallback -> withFocused $ whenStickyWithFallback $ (command, fallback)
    , withFocused $ whenSticky $ command
    )

insertKeysWhenStickyWithFallback :: [((KeyMask, KeySym), Window -> X ())] -> (M.Map (KeyMask, KeySym) (X ())) -> (M.Map (KeyMask, KeySym) (X ()))
insertKeysWhenStickyWithFallback mappings =
    insertKeysWith
        ( map
            (\(chord, command) -> (chord, appendWhenStickyWithFallback command))
            mappings
        )

injectKeys :: KeyMask -> M.Map (KeyMask, KeySym) (X ()) -> M.Map (KeyMask, KeySym) (X ())
injectKeys modMask keys =
    insertKeys
        [ ((modMask, xK_o), withFocused toggleSticky)
        , ((modMask .|. shiftMask, xK_o), withTaggedGlobalP "stickywindow" (W.shiftWin "scratchpad"))
        ]
        . insertKeysWhenStickyWithFallback
            [ ((modMask, xK_Left), moveSticky $ "stickyshifthoriz")
            , ((modMask, xK_Right), moveSticky $ "stickyshifthoriz")
            , ((modMask, xK_Up), moveSticky $ "stickyshiftvert")
            , ((modMask, xK_Down), moveSticky $ "stickyshiftvert")
            , ((modMask, xK_plus), changeStickySize $ (1))
            , ((modMask, xK_minus), changeStickySize $ (-1))
            ]
        . (adjustAllWorkspaces modMask)
        $ keys

withStickyWindows :: XConfig l -> XConfig l
withStickyWindows conf@(XConfig{modMask}) =
    conf
        { keys = \cnf -> injectKeys modMask (keys conf cnf)
        , manageHook = stickyWindowFloat <> manageHook conf
        }
