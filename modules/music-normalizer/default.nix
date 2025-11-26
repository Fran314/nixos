{
  pkgs,
  ...
}:

let
  music-normalizer = pkgs.callPackage (builtins.fetchGit {
    url = "https://github.com/Fran314/music-normalizer";
    rev = "8be66630a9fe437bf4c5dc520e14123ef6f7e552";
  }) { };
in
{
  environment.systemPackages = [
    music-normalizer

    pkgs.ffmpeg-normalize
  ];
}
