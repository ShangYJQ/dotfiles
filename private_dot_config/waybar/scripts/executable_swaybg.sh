#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/Pictures/Wallpapers"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/wallpaper"
IDX_FILE="$STATE_DIR/index"
PID_FILE="$STATE_DIR/swaybg.pid"
mkdir -p "$STATE_DIR"

# 收集壁纸（按文件名排序，保证 next/prev 稳定）
mapfile -t WALLS < <(find "$DIR" -maxdepth 1 -type f \
	\( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' -o -iname '*.webp' \) \
	-printf '%p\n' | sort)

# 没有壁纸就退出（避免 kill 后黑屏）
[ "${#WALLS[@]}" -gt 0 ] || exit 0

MODE="${1:-random}"

# 读当前 index（默认 0）
idx=0
if [ -f "$IDX_FILE" ]; then
	idx="$(cat "$IDX_FILE" 2>/dev/null || echo 0)"
fi
# 防御：确保 idx 是数字
case "$idx" in '' | *[!0-9]*) idx=0 ;; esac

case "$MODE" in
random | "")
	idx=$((RANDOM % ${#WALLS[@]}))
	;;
next)
	idx=$(((idx + 1) % ${#WALLS[@]}))
	;;
prev)
	idx=$(((idx + ${#WALLS[@]} - 1) % ${#WALLS[@]}))
	;;
*)
	echo "Usage: $(basename "$0") [random|next|prev]" >&2
	exit 2
	;;
esac

IMG="${WALLS[$idx]}"

# 启动新 swaybg 之前，先确保 IMG 真的存在（避免黑屏）
[ -f "$IMG" ] || exit 0

# 只杀掉我们自己启动的 swaybg（避免误杀别的）
if [ -f "$PID_FILE" ]; then
	oldpid="$(cat "$PID_FILE" 2>/dev/null || true)"
	if [ -n "${oldpid:-}" ] && kill -0 "$oldpid" 2>/dev/null; then
		kill "$oldpid" 2>/dev/null || true
	fi
fi

# 启动新的 swaybg
swaybg -i "$IMG" -m fill >/dev/null 2>&1 &
echo $! >"$PID_FILE"

# 记录 index
echo "$idx" >"$IDX_FILE"
