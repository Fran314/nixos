{
  pkgs,
  ...
}:

let
  music-normalizer = pkgs.callPackage (builtins.fetchGit {
    url = "https://github.com/Fran314/music-normalizer";
    rev = "f2624db6395b730becec573edc230bd440492328";
  }) { };
in
{
  environment.systemPackages = [
    music-normalizer

    pkgs.ffmpeg-normalize
  ];
}
