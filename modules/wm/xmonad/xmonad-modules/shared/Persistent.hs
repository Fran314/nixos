module Persistent(
	initSpawnPersistent,
	initSmartKill
) where

import XMonad

import XMonad.Operations

-- the default configuration import it qualified as W and it seems a gloabl
-- convention
import qualified XMonad.StackSet as W

-- same as the W
import qualified Data.Map as M

import Data.Bool

import Control.Monad

import XMonad.Actions.TagWindows


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

initSpawnPersistent :: [(String, Window -> X Bool, X ())] -> String -> X ()
initSpawnPersistent persistentProcesses name = do
    let Just (procIdentifier, procCommand) = M.lookup name persProcMap
    procWindows <- findWindows procIdentifier
    if (length procWindows > 0)
        then windows $ (shiftHere (head procWindows))
        else procCommand
	where
		persProcMap = M.fromList (map (\(name, query, command) -> (name, (query, command))) persistentProcesses)

initSmartKill :: [(String, Window -> X Bool, X ())] -> X ()
initSmartKill persistentProcesses = withFocused f
	where
		f w = do
			shouldLive <- do
				forM
					persistentProcesses
					( \(_, procIdentifier, _) -> do
						res <- procIdentifier w
						return res
					)
					>>= return . or
			currWorkspace <- withWindowSet (pure . W.currentTag)
			if shouldLive && currWorkspace /= "scratchpad"
				then windows $ W.shift "scratchpad"
				else kill
