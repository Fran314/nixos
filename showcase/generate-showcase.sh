#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bash imagemagick

print_help() {
    echo "Merge two images on top of eachother"
    echo ""
    echo "USAGE: generate-showcase.sh IMG1 IMG2 OUTPUT"
}

if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]
then
    print_help
    exit 0
elif [ ! -f $1 ] || [ ! -f $2 ] || [[ $3 == "" ]]
then
    print_help
    exit 1
fi

magick $1 -background transparent -extent 3040x1710 png:- \
    | magick composite $2 png:- -geometry +1120+630 $3
