[[ $- =~ i ]] && {
    IMAGE="<<WELCOME-IMAGE>>"
    # Why -1-2? -1 is to remove the newline character which must not be counted
    # and the -2 removes the first and last characters which count for the left
    # and right side of the box surrounding the text
    IMAGE_WIDTH=$(($(echo $IMAGE | head -1 | wc -m) - 1 - 2))
    
    DATE=$(date "+%a %d %b %Y %T")
    # Why -1? Same as above, to remove the counted new line
    TEXT_WIDTH=$(($(echo "[$DATE] Welcome to $HOST, $USER!" | wc -m) - 1))

    MAX_WIDTH=$IMAGE_WIDTH
    if [[ $(($TEXT_WIDTH + 4)) -gt $IMAGE_WIDTH ]]; then
        MAX_WIDTH=$(($TEXT_WIDTH + 4))
    fi

    LEFT_SPACE_WIDTH=$(( ($MAX_WIDTH - $TEXT_WIDTH) / 2 ))
    RIGHT_SPACE_WIDTH=$(( $MAX_WIDTH - $TEXT_WIDTH - $LEFT_SPACE_WIDTH ))

    BAR=""
    for i in {1..$MAX_WIDTH}; do
        BAR+="═"
    done

    LEFT_SPACE=""
    for i in {1..$LEFT_SPACE_WIDTH}; do
        LEFT_SPACE+=" "
    done

    RIGHT_SPACE=""
    for i in {1..$RIGHT_SPACE_WIDTH}; do
        RIGHT_SPACE+=" "
    done

    TEXT="\033[0;30m[$DATE] \033[0mWelcome to \033[1;3<<HOST-COLOR>>m$HOST\033[0m, $USER!"
    echo "╔$BAR╗"
    echo "║$LEFT_SPACE$TEXT$RIGHT_SPACE║"
    echo "╚$BAR╝"
    echo "$IMAGE"
}
