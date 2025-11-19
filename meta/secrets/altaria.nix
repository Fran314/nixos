let
  fetch-secret =
    { path, sha256 }:
    builtins.readFile (
      builtins.fetchurl {
        url = "file:///secrets/${path}";
        inherit sha256;
      }
    );
in
{
  wg.latias."wg-vps.public" = fetch-secret {
    path = "wg/latias/wg-vps.public";
    sha256 = "sha256:1yplc2k6ay4y1w019zhvj37a9xfv7a6g1cw0ynckm9za5b5zh5j9";
  };
  ssh.latias."id_ed25519.pub" = fetch-secret {
    path = "ssh/latias/id_ed25519.pub";
    sha256 = "sha256:1bb90xpw58vygy5qhr1zcc820r74jrnkhcq5fakwfkccp21wqsyg";
  };
  samba.altaria."device" = fetch-secret {
    path = "samba/altaria/device";
    sha256 = "sha256:1ifyzgmh5myl12apgahaadapmfwak5rdyvxdkr8sjfsd57cyym50";
  };
  caddy.altaria."music-catalogue.basic-auth" = fetch-secret {
    path = "caddy/altaria/music-catalogue.basic-auth";
    sha256 = "sha256:1fll9i4g6vdvwd8x356ixsazn7icgs35d566xn8r6b0kbsga0bhs";
  };
}
