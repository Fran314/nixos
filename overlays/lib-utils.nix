machine: final: prev:

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
in

{
  lib = prev.lib // {
    inherit readInterpolate;
  };
}
