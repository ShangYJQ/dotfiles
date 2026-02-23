#!/usr/bin/env bash
set -euo pipefail

PIDFILE="/tmp/whisper2clip-rec.pid"
WAV="/tmp/whisper2clip.wav"
OUTTXT="/tmp/whisper2clip.txt"

MODEL="${WHISPER_MODEL:-$HOME/.local/share/whisper/models/ggml-large-v3-turbo.bin}"
VADMODEL="$HOME/.local/share/whisper/models/ggml-silero-v6.2.0.bin"

LANG="${WHISPER_LANG:-zh}"

# 停止录音
if [[ -f "$PIDFILE" ]]; then
	pid="$(cat "$PIDFILE" || true)"
	rm -f "$PIDFILE"
	if [[ -n "${pid:-}" ]] && kill -0 "$pid" 2>/dev/null; then
		kill "$pid" 2>/dev/null || true
	fi
fi

# 等文件落盘
sleep 0.15

if [[ ! -s "$WAV" ]]; then
	notify-send -t 2000 "󰍬 Whisper" "没有录到音频"
	exit 0
fi

if [[ ! -f "$MODEL" ]]; then
	notify-send -t 4000 " hisper" "模型不存在：$MODEL"
	exit 1
fi

notify-send -t 1200 " Whisper" "正在识别…"

text="$(
	/usr/bin/whisper-cli -m "$MODEL" -f "$WAV" -l "$LANG" -nt --vad -vm "$VADMODEL" 2>/tmp/wislog.log |
		tr -d '\r' |
		tr '\n' ' ' |
		sed -E 's/\[[0-9:.]+[[:space:]]*-->[[:space:]]*[0-9:.]+\][[:space:]]*//g'
)"

if [[ -z "${text}" ]]; then
	notify-send -t 2500 "󰍬 Whisper" "未识别到内容"
	exit 0
fi

printf '%s' "$text" | wl-copy

preview="$text"
max=120
if ((${#preview} > max)); then preview="${preview:0:max}…"; fi
notify-send -t 3500 " 已复制到剪贴板" "$preview"
