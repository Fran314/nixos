module MachineSpecific(
	machineSpecificKeys,
	machineSpecificManageHook
) where

import XMonad

import qualified Data.Map as M

machineSpecificKeys :: KeyMask -> [((KeyMask, KeySym), X ())]
machineSpecificKeys modMask = []

machineSpecificManageHook :: ManageHook
machineSpecificManageHook = composeAll []
