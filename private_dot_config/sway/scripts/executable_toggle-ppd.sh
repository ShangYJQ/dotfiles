#!/bin/sh
set -eu

ORDER="performance balanced power-saver"

cur="$(powerprofilesctl get 2>/dev/null || true)"

if [ -z "$cur" ]; then
	notify-send -u critical "Power Profile" "powerprofilesctl get 失败：请确认 power-profiles-daemon 正在运行"
	exit 1
fi

next=""
for p in $ORDER; do
	if [ "$p" = "$cur" ]; then
		found=1
		continue
	fi
	if [ "${found:-0}" = "1" ]; then
		next="$p"
		break
	fi
done
[ -n "$next" ] || next="$(printf "%s" "$ORDER" | awk '{print $1}')"

if powerprofilesctl set "$next" 2>/dev/null; then
	case "$next" in
	performance) icon="" ;;
	balanced) icon="" ;;
	power-saver) icon="󱊢" ;;
	*) icon="󱊢" ;;
	esac
	notify-send -u normal "Power Profile $icon" "已切换到: $next"
else
	notify-send -u critical "Power Profile" "切换失败：$cur → $next"
	exit 1
fi
