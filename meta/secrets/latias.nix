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
  wg = {
    altaria."wg0.public" = fetch-secret {
      path = "wg/altaria/wg0.public";
      sha256 = "sha256:1d5dw1vrfkxql2fd8aydnmcrhmnmga3ppgiwlb73d2yxy7ijbwvr";
    };
    umbreon."wg0.public" = fetch-secret {
      path = "wg/umbreon/wg0.public";
      sha256 = "sha256:172i249psx4wa0crkxvsx6xk2g4ha6gvn2gghzvvd7xgn5zdilxb";
    };
    proton."wg0.public" = fetch-secret {
      path = "wg/proton/wg0.public";
      sha256 = "sha256:0arnjgk3lh01r8idwxw808am96m4d5sdwpjw9pc80mq0yzngrs7g";
    };
  };
}
