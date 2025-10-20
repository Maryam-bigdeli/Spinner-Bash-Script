#!/usr/bin/env bash
# ============================================================
# 📦 spinner.sh — Lightweight ASCII Bash spinner (no Unicode)
# Author: Adapted from Will Carhart’s blog
# Purpose: Create a clean, reliable spinner that works on all terminals.
# ============================================================

# ============================================================
# 🎨 Colors (optional)
# ============================================================
GREEN="\033[0;32m"   # Success color
RED="\033[0;31m"     #  Failure color
BLUE="\033[0;36m"    # Spinner color
RESET="\033[0m"      # Reset color back to normal

# ============================================================
# �Spinner frames (ASCII only - works everywhere)
# ============================================================
SPINNER_FRAMES=('|' '/' '-' '\')

# ============================================================
# � Store spinner PID
# We'll save the background process ID to stop it later.
# ============================================================
spinner_pid=

# ============================================================
# Function: spin
# ------------------------------------------------------------
# Shows an endless spinner with a message.
# Runs in background and loops through frames.
# ============================================================
spin() {
  local i=0
  local text="$1"
  while :; do
    printf "\r${BLUE}%s${RESET} %s" "${SPINNER_FRAMES[i]}" "$text"
    i=$(( (i + 1) % ${#SPINNER_FRAMES[@]} ))
    sleep 0.1
  done
}

# ============================================================
# Function: start_spinner
# ------------------------------------------------------------
# Starts the spinner in background and stores its PID.
# ============================================================
start_spinner() {
  local message="$1"
  set +m                      # Disable job control messages
  { spin "$message"; } 2>/dev/null &
  spinner_pid=$!
}

# ============================================================
# Function: stop_spinner
# ------------------------------------------------------------
# Stops the spinner, clears the line, and prints final result.
# ============================================================
stop_spinner() {
  local exit_code=$?
  kill -9 "$spinner_pid" 2>/dev/null || true
  echo -en "\033[2K\r"         # Clear current line
  if [ $exit_code -eq 0 ]; then
    echo -e "${GREEN}✅ Done!${RESET}"
  else
    echo -e "${RED}❌ Failed.${RESET}"
  fi
  set -m                       # Re-enable job control
}

# ============================================================
# �Trap
# ------------------------------------------------------------
# Ensures spinner stops automatically when script exits.
# ============================================================
trap stop_spinner EXIT

# ============================================================
# �Example usage (for testing)
# ------------------------------------------------------------
# Uncomment these lines if you want to test directly:
# ============================================================
start_spinner "Processing data..."
sleep 5
# stop_spinner
