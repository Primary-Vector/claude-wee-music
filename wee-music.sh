#!/usr/bin/env bash
#
# wee-music.sh — Play randomized background music while Claude Code is working.
#
# Usage:
#   wee-music.sh start   Start background music (if not already playing)
#   wee-music.sh stop    Stop background music
#   wee-music.sh done    Stop music and play the "done" jingle
#

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MUSIC_DIR="$SCRIPT_DIR/Nintendo Wii Music Collection"
PID_FILE="/tmp/wee-music-player.pid"
LOOP_PID_FILE="/tmp/wee-music-loop.pid"

# Long songs (>60s) for background music
LONG_SONGS=(
    "01. Main Menu.mp3"
    "03. Mii Channel.mp3"
    "04. Mii Plaza.mp3"
    "05. Mii Parade.mp3"
    "07. Shop Channel.mp3"
    "08. Title (Wii Sports).mp3"
    "09. Training Menu (Wii Fit).mp3"
    "10. Menu 01 (Wii Music).mp3"
    "11. News Channel.mp3"
    "12. Photo Channel.mp3"
    "14. Results (Wii Sports).mp3"
    "15. Yoga (Wii Fit).mp3"
    "16. Menu 02 (Wii Music).mp3"
    "17. Title (Wii Play).mp3"
    "21. Result Display (Wii Sports).mp3"
    "22. Credits (Wii Play Motion).mp3"
)

DONE_JINGLE="02. Channel Intro.mp3"

# --- Detect audio player ---

find_player() {
    if command -v afplay &>/dev/null; then
        echo "afplay"
    elif command -v ffplay &>/dev/null; then
        echo "ffplay"
    elif command -v mpg123 &>/dev/null; then
        echo "mpg123"
    else
        echo ""
    fi
}

# --- Play a file in the foreground (blocking) ---

play_fg() {
    local file="$1"
    local player="$2"
    case "$player" in
        afplay)  afplay "$file" ;;
        ffplay)  ffplay -nodisp -autoexit -loglevel quiet "$file" ;;
        mpg123)  mpg123 -q "$file" ;;
    esac
}

# --- Play a file in the background, write PID to stdout ---

play_bg() {
    local file="$1"
    local player="$2"
    case "$player" in
        afplay)  afplay "$file" & ;;
        ffplay)  ffplay -nodisp -autoexit -loglevel quiet "$file" & ;;
        mpg123)  mpg123 -q "$file" & ;;
    esac
}

# --- Pick a random song ---

random_song() {
    local count=${#LONG_SONGS[@]}
    local index=$((RANDOM % count))
    echo "${LONG_SONGS[$index]}"
}

# --- Check if the music loop is alive ---

is_playing() {
    if [ -f "$LOOP_PID_FILE" ]; then
        local pid
        pid=$(cat "$LOOP_PID_FILE" 2>/dev/null)
        if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
            return 0
        fi
    fi
    return 1
}

# --- Kill the current player and loop ---

kill_music() {
    # Read both PIDs upfront before killing anything
    local loop_pid="" player_pid=""
    [ -f "$LOOP_PID_FILE" ] && loop_pid=$(cat "$LOOP_PID_FILE" 2>/dev/null)
    [ -f "$PID_FILE" ] && player_pid=$(cat "$PID_FILE" 2>/dev/null)

    # Kill loop first so it can't respawn, then kill the player
    [ -n "$loop_pid" ] && kill "$loop_pid" 2>/dev/null
    [ -n "$player_pid" ] && kill "$player_pid" 2>/dev/null

    rm -f "$LOOP_PID_FILE" "$PID_FILE"
}

# --- Music loop (runs in background) ---

music_loop() {
    local player
    player="$(find_player)"
    if [ -z "$player" ]; then
        echo "No audio player found. Install ffmpeg or mpg123." >&2
        exit 1
    fi

    trap 'kill $(cat "$PID_FILE" 2>/dev/null) 2>/dev/null; exit 0' TERM INT

    while true; do
        local song
        song="$(random_song)"
        local file="$MUSIC_DIR/$song"

        if [ ! -f "$file" ]; then
            sleep 1
            continue
        fi

        # Launch player as a direct child so wait works
        play_bg "$file" "$player"
        local child_pid=$!
        echo "$child_pid" > "$PID_FILE"

        wait "$child_pid" 2>/dev/null
        rm -f "$PID_FILE"
    done
}

# --- Commands ---

cmd_start() {
    if ! [ -d "$MUSIC_DIR" ]; then
        echo "Music directory not found. Run setup.sh first." >&2
        exit 1
    fi

    if is_playing; then
        exit 0
    fi

    local player
    player="$(find_player)"
    if [ -z "$player" ]; then
        echo "No audio player found. Install ffmpeg or mpg123." >&2
        exit 1
    fi

    # Launch the music loop in the background
    music_loop &
    local loop_pid=$!
    echo "$loop_pid" > "$LOOP_PID_FILE"
    disown "$loop_pid" 2>/dev/null
}

cmd_stop() {
    kill_music
}

cmd_done() {
    kill_music

    local jingle="$MUSIC_DIR/$DONE_JINGLE"
    if [ -f "$jingle" ]; then
        local player
        player="$(find_player)"
        play_fg "$jingle" "$player"
    fi
}

# --- Main ---

case "${1:-}" in
    start) cmd_start ;;
    stop)  cmd_stop ;;
    done)  cmd_done ;;
    *)
        echo "Usage: wee-music.sh {start|stop|done}" >&2
        exit 1
        ;;
esac
