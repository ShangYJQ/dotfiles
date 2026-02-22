#!/bin/sh
DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

case "$1" in
low | normal) sound="$DIR/sounds/message.oga" ;;
critical) sound="$DIR/sounds/dialog-warn.oga" ;;
*) sound="$DIR/sounds/message.oga" ;;
esac

pw-play "$sound"
