IMAGE="<nix-interpolate:welcome-image>"
if [[ $((RANDOM % 20)) -eq 0 ]]; then
	# Handle variant if supported
	# If the following line reads the same as the one above the if,
	# then variant is not supported
	IMAGE="<nix-interpolate:variant-image>"
fi
# Why -1-2? -1 is to remove the newline character which must not be counted
# and the -2 removes the first and last characters which count for the left
# and right side of the box surrounding the text
IMAGE_WIDTH=$(($(head -1 "$IMAGE" | wc -m) - 1 - 2))

DATE="  \033[0;90m[$(date "+%a %d %b %Y %T")]\033[0m"

TEXT="Welcome to \033[1;38;2;<nix-interpolate:host-color>m$HOST\033[0m, $USER!"
TEXT_WIDTH=$(echo -n "Welcome to $HOST, $USER!" | wc -m)

MAX_WIDTH=$IMAGE_WIDTH
if [[ $((TEXT_WIDTH + 8)) -gt $IMAGE_WIDTH ]]; then
	MAX_WIDTH=$((TEXT_WIDTH + 8))
fi

# Only print welcome if screen is big enough
if [[ $((MAX_WIDTH + 2)) -le $(tput cols) ]]; then

	# MAX_WIDTH + 30 accounts for the size of the box and the size of the date
	if [[ $((MAX_WIDTH + 30)) -gt $(tput cols) ]]; then
		MAX_WIDTH=$(($(tput cols) - 2))
		DATE=""
	fi

	LEFT_PADDING=$(((MAX_WIDTH - TEXT_WIDTH) / 2))
	RIGHT_PADDING=$((MAX_WIDTH - TEXT_WIDTH - LEFT_PADDING))

	BAR=""
	for i in {1.."$MAX_WIDTH"}; do
		BAR+="═"
	done

	for i in {1.."$LEFT_PADDING"}; do
		TEXT=" $TEXT"
	done

	RIGHT_SPACE=""
	for i in {1.."$RIGHT_PADDING"}; do
		TEXT="$TEXT "
	done

	clear
	echo "╔$BAR╗"
	echo "║$TEXT║$DATE"
	echo "╚$BAR╝"
	cat "$IMAGE"
fi
