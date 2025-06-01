machine:

let
  # Utility function that reads a file and automatically interpolates the
  # variables associated to the machine into the file
  #
  # readInterpolate only interpolates the machine variables, where
  # readInterpolateWith supports an additional set of local variables which
  # take precedence over the machine variables
  #
  # Note that the correct functioning of these substitutions depends on
  # attrNames and attrValues returning the keys and values in the same order
  # (which they do, and the order is alphabetical in the key)
  formatNames = list: map (x: "<nix-interpolate:${x}>") list;
  from = variables: (formatNames (builtins.attrNames (machine // variables)));
  to = variables: (builtins.attrValues (machine // variables));
  readInterpolateWith =
    variables: path: builtins.replaceStrings (from variables) (to variables) (builtins.readFile path);
  readInterpolate = path: readInterpolateWith { } path;

  # Scripts that need variable interpolation must NOT be run before interpolation as
  # this would produce potentially harmful undefined behaviour.
  #
  # To prevent this, any script that needs interpolation to function start with a
  # flag that prevents the script to be ran if set to 1.
  readRemoveStopWith =
    variables: path:
    builtins.replaceStrings
      [ "STOP_EXECUTION_BEFORE_INTERPOLATION=1" ]
      [ "STOP_EXECUTION_BEFORE_INTERPOLATION=0" ]
      (readInterpolateWith variables path);
  readRemoveStop = path: readRemoveStopWith { } path;

in

{
  inherit readInterpolateWith;
  inherit readInterpolate;
  inherit readRemoveStopWith;
  inherit readRemoveStop;
}
