module Utils(
	centeredRect,
	centeredRectBigger,
	fullRect,
	midrowMappings,
	insertKeys,
	insertKeysWith
) where

import XMonad

import qualified XMonad.StackSet as W
import qualified Data.Map as M

centeredRect =       W.RationalRect (7 / 24) (1 / 6) (5 / 12) (2 / 3)
centeredRectBigger = W.RationalRect (1 / 4)  (1 / 6) (1 / 2)  (2 / 3)
fullRect =           W.RationalRect 0 0 1 1

midrowMappings :: [(KeySym, String)]
midrowMappings = [(xK_a, "0"), (xK_s, "1"), (xK_d, "2"), (xK_f, "3"), (xK_g, "4"), (xK_h, "5"), (xK_j, "6"), (xK_k, "7"), (xK_l, "8")]

toInsert :: ((KeyMask, KeySym), X ()) -> (M.Map (KeyMask, KeySym) (X ())) -> (M.Map (KeyMask, KeySym) (X ()))
toInsert (chord, com) = M.insert chord com
insertKeys :: [((KeyMask, KeySym), X ())] -> (M.Map (KeyMask, KeySym) (X ())) -> (M.Map (KeyMask, KeySym) (X ()))
insertKeys mappings keys = (foldr (.) id (map toInsert mappings)) $ keys

toInsertWith :: ((KeyMask, KeySym), (X () -> X(), X ())) -> (M.Map (KeyMask, KeySym) (X ())) -> (M.Map (KeyMask, KeySym) (X ()))
toInsertWith (chord, (f, val)) = M.insertWith (\_ -> f) chord val
insertKeysWith :: [((KeyMask, KeySym), (X() -> X (), X ()))] -> (M.Map (KeyMask, KeySym) (X ())) -> (M.Map (KeyMask, KeySym) (X ()))
insertKeysWith mappings keys = (foldr (.) id (map toInsertWith mappings)) $ keys
