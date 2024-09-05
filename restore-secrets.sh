#!/usr/bin/env bash

if [[ -z "$BW_SESSION" ]]
then
    #--- Start bitwarden session ---#
    bw logout --quiet
    BW_SESSION=$(bw login --raw)
fi

#--- Restore ssh keys ---#
bw --session $BW_SESSION get item ssh-keys                                                                                       \
    | tee >(jq -r '.fields.[] | select(.name == "baldo@latias.public") | .value'                     > ~/.ssh/id_ed25519.pub) \
    |       jq -r '.fields.[] | select(.name == "baldo@latias.private") | .value' | sed 's/\\n/\n/g' > ~/.ssh/id_ed25519

chmod 600 ~/.ssh/id_ed25519
ssh-add ~/.ssh/id_ed25519
