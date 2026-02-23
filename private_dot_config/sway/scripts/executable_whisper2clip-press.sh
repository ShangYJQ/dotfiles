#!/usr/bin/env bash
set -euo pipefail

PIDFILE="/tmp/whisper2clip-rec.pid"
WAV="/tmp/whisper2clip.wav"

if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
	exit 0
fi

rm -f "$WAV"
notify-send -t 900 "󰍬 Whisper" "开始录音…（松开按键结束并识别）"

pw-record --rate 16000 --channels 1 "$WAV" >/dev/null 2>&1 &
echo $! >"$PIDFILE"
