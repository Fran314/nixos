setopt prompt_subst

function precmd() {
    HOST_ICON=""
    if [[ $HOST == "umbreon" ]]; then
        HOST_ICON=' %B%F{3}%f%b'
    elif [[ $HOST == "altaria" ]]; then
        HOST_ICON=' %B%F{3}󰅟%f%b'
    fi


    ERROR_CODE_PROMPT='%(?.. %B%F{1}[%?]%b%f)'


    USERNAME_PROMPT=' %B%F{4}%n%b%f@%m'
    if [ $(id -u) -eq 0 ]; then
        USERNAME_PROMPT=' %B%F{1}%n%b%f@%m'
    fi


    CWD_PROMPT=' %B%80<..<%~%<<%b'


    GIT_PROMPT=""
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1
    then
        GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [[ $? -ne 0 ]]
        then
            GIT_PROMPT=" [%B%F{1}???%b%f]"
        else
            GIT_STATUS=$(git status --short | cut -c 1-2)
            GIT_UPSTREAM=$(git rev-parse --abbrev-ref $GIT_BRANCH@{upstream} 2> /dev/null)

            STATUS_PROMPT=""
            if [[ $GIT_STATUS != "" ]]; then
                INDEX=$(echo "$GIT_STATUS" | cut -c 1)
                TREE=$(echo "$GIT_STATUS" | cut -c 2)

                INDEX_A=$(echo $INDEX | tr -cd 'A' | wc -c)
                INDEX_M=$(echo $INDEX | tr -cd 'MTRCU' | wc -c)
                INDEX_D=$(echo $INDEX | tr -cd 'D' | wc -c)

                TREE_A=$(echo $TREE | tr -cd 'A?' | wc -c)
                TREE_M=$(echo $TREE | tr -cd 'MTRCU' | wc -c)
                TREE_D=$(echo $TREE | tr -cd 'D' | wc -c)

                INDEX_PROMPT=""
                TREE_PROMPT=""

                if [[ $INDEX_A != "0" ]];     then; INDEX_PROMPT+="%F{2}+$INDEX_A"; fi
                if [[ $INDEX_M != "0" ]];     then; INDEX_PROMPT+="%F{3}~$INDEX_M"; fi
                if [[ $INDEX_D != "0" ]];     then; INDEX_PROMPT+="%F{1}-$INDEX_D"; fi
                if [[ $INDEX_PROMPT == "" ]]; then; INDEX_PROMPT="%F{0}-";          fi

                if [[ $TREE_A != "0" ]];     then; TREE_PROMPT+="%F{2}+$TREE_A"; fi
                if [[ $TREE_M != "0" ]];     then; TREE_PROMPT+="%F{3}~$TREE_M"; fi
                if [[ $TREE_D != "0" ]];     then; TREE_PROMPT+="%F{1}-$TREE_D"; fi
                if [[ $TREE_PROMPT == "" ]]; then; TREE_PROMPT="%F{0}-";         fi

                STATUS_PROMPT=" ($INDEX_PROMPT%f|$TREE_PROMPT%f)"
            fi

            UPSTREAM_PROMPT=""
            if [[ $GIT_UPSTREAM != "" ]]; then
                GIT_AHEAD=$(git log $GIT_UPSTREAM..$GIT_BRANCH --oneline --no-decorate | wc -l)
                GIT_BEHIND=$(git log $GIT_BRANCH..$GIT_UPSTREAM --oneline --no-decorate | wc -l)

                if [[ $GIT_AHEAD != "0" ]]; then
                    UPSTREAM_PROMPT+="%F{4}↑"
                    if [[ $GIT_AHEAD != "1" ]]; then
                        UPSTREAM_PROMPT+=$GIT_AHEAD
                    fi
                fi

                if [[ $GIT_BEHIND != "0" ]]; then
                    UPSTREAM_PROMPT+="%F{3}↓"
                    if [[ $GIT_BEHIND != "1" ]]; then
                        UPSTREAM_PROMPT+=$GIT_BEHIND
                    fi
                fi

                if [[ $UPSTREAM_PROMPT != "" ]]; then
                    UPSTREAM_PROMPT="|$UPSTREAM_PROMPT%f"
                fi
            fi

            GIT_PROMPT=" [%B%F{2}$GIT_BRANCH%b%f$UPSTREAM_PROMPT]"
            GIT_PROMPT+=$STATUS_PROMPT
        fi
    fi

    PROMPT='┌'
    PROMPT+=$HOST_ICON
    PROMPT+=$ERROR_CODE_PROMPT
    PROMPT+=$USERNAME_PROMPT
    PROMPT+=$CWD_PROMPT
    PROMPT+=$GIT_PROMPT
    PROMPT+=$'\n'
    PROMPT+='└> '
}

