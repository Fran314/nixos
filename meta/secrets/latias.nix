let
  fetch-secret =
    { path, sha256 }:
    builtins.fetchurl {
      url = "file:///secrets/${path}";
      inherit sha256;
    };
in
{
  wireguard = {
    altaria.wg0.public = builtins.readFile (fetch-secret {
      path = "wireguard/altaria/wg0.public";
      sha256 = "sha256:1d5dw1vrfkxql2fd8aydnmcrhmnmga3ppgiwlb73d2yxy7ijbwvr";
    });

    proton.wg0.public = builtins.readFile (fetch-secret {
      path = "wireguard/proton/wg0.public";
      sha256 = "sha256:0arnjgk3lh01r8idwxw808am96m4d5sdwpjw9pc80mq0yzngrs7g";
    });
  };
}
