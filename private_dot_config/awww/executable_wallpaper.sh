#!/bin/sh
# waybar click wallpaper controller for awww
# left: next, right: prev, middle: random
# default dir: ~/Wallpapers

DIR="${AWWW_WALLPAPER_DIR:-$HOME/Pictures/Wallpapers/}"
STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/awww"
INDEX_FILE="$STATE_DIR/index"
ORDER_FILE="$STATE_DIR/order"

RESIZE_TYPE="${AWWW_RESIZE_TYPE:-crop}"
export AWWW_TRANSITION_FPS="${AWWW_TRANSITION_FPS:-60}"
export AWWW_TRANSITION="${AWWW_TRANSITION:-random}"

mkdir -p "$STATE_DIR"

[ -d "$DIR" ] || {
	echo "Wallpaper dir not found: $DIR" >&2
	exit 1
}

# Build shuffled order file if missing/empty
build_order() {
	find "$DIR" -type f | while read -r img; do
		echo "$(</dev/urandom tr -dc a-zA-Z0-9 | head -c 8):$img"
	done | sort | cut -d':' -f2- >"$ORDER_FILE"
}

[ -s "$ORDER_FILE" ] || build_order

# Read current index
INDEX=0
[ -f "$INDEX_FILE" ] && INDEX=$(cat "$INDEX_FILE" 2>/dev/null || echo 0)

# Load order into a temp list
# POSIX sh: iterate by reading file with line numbers
COUNT=$(wc -l <"$ORDER_FILE" | tr -d ' ')
[ "$COUNT" -gt 0 ] || {
	build_order
	COUNT=$(wc -l <"$ORDER_FILE" | tr -d ' ')
}

ACTION="${1:-next}"

case "$ACTION" in
next)
	INDEX=$(((INDEX + 1) % COUNT))
	;;
prev)
	INDEX=$(((INDEX - 1 + COUNT) % COUNT))
	;;
random)
	# pick random index
	# shell-safe: use od from /dev/urandom
	R=$(od -An -N2 -tu2 /dev/urandom 2>/dev/null | tr -d ' ')
	INDEX=$((R % COUNT))
	;;
reshuffle)
	build_order
	INDEX=0
	;;
*)
	echo "Usage: $0 {next|prev|random|reshuffle}" >&2
	exit 2
	;;
esac

echo "$INDEX" >"$INDEX_FILE"

# get INDEX-th line (0-based) from ORDER_FILE
TARGET_LINE=$((INDEX + 1))
IMG=$(sed -n "${TARGET_LINE}p" "$ORDER_FILE")

[ -n "$IMG" ] || {
	build_order
	IMG=$(sed -n "1p" "$ORDER_FILE")
	echo 0 >"$INDEX_FILE"
}

# apply to all outputs (or you can change this to only one)
for d in $(awww query | awk '{print $2}' | sed 's/://'); do
	awww img --resize "$RESIZE_TYPE" --outputs "$d" \
		--transition-type "${AWWW_TRANSITION:-random}" \
		--transition-fps "${AWWW_TRANSITION_FPS:-60}" \
		--transition-duration "${AWWW_TRANSITION_DURATION:-3}" \
		"$IMG"
done
