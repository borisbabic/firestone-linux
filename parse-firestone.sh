#!/usr/bin/env bash

set -euo pipefail

DEFAULT_RELATIVE_PATH="drive_c/users/steamuser/AppData/Roaming/Firestone Standalone/data/user.firestone-standalone.json"

show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Parses a Firestone auth URL and saves the output JSON into a Wine prefix.

Options:
  -u, --url URL           Firestone auth URL
  -p, --prefix PATH       Path to the Wine prefix directory
  -f, --file PATH         Relative path inside Wine prefix for JSON 
                          (default: $DEFAULT_RELATIVE_PATH)
  -i, --interactive       Run in interactive mode
  -h, --help              Show this help message
EOF
}

# Parse command line flags
URL=""
WINE_PREFIX=""
RELATIVE_FILE=""
INTERACTIVE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -u|--url)
            URL="$2"
            shift 2
            ;;
        -p|--prefix)
            WINE_PREFIX="$2"
            shift 2
            ;;
        -f|--file)
            RELATIVE_FILE="$2"
            shift 2
            ;;
        -i|--interactive)
            INTERACTIVE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            show_help
            exit 1
            ;;
    esac
done

# Fallback to interactive mode if required arguments are missing
if [[ -z "$URL" || -z "$WINE_PREFIX" ]]; then
    INTERACTIVE=true
fi

if [[ "$INTERACTIVE" == true ]]; then
    echo "=== Firestone Auth Configurator ==="
    echo ""

    if [[ -z "$URL" ]]; then
        read -rp "Enter Firestone Auth URL: " URL
    fi

    if [[ -z "$WINE_PREFIX" ]]; then
        read -rp "Enter Wine Prefix Directory (e.g., ~/.wine or ~/.local/share/bottles/gradles): " WINE_PREFIX
    fi

    if [[ -z "$RELATIVE_FILE" ]]; then
        read -rp "Enter relative file path inside prefix [Default: $DEFAULT_RELATIVE_PATH]: " INPUT_FILE
        RELATIVE_FILE="${INPUT_FILE:-$DEFAULT_RELATIVE_PATH}"
    fi
fi

# Apply default file path if still not set
RELATIVE_FILE="${RELATIVE_FILE:-$DEFAULT_RELATIVE_PATH}"

# Expand home directory (~) if present in prefix path
WINE_PREFIX="${WINE_PREFIX/#\~/$HOME}"

# Validate Wine prefix directory
if [[ ! -d "$WINE_PREFIX" ]]; then
    echo "Error: Wine prefix directory '$WINE_PREFIX' does not exist." >&2
    exit 1
fi

FULL_OUTPUT_PATH="$WINE_PREFIX/$RELATIVE_FILE"

# Extract query string (everything after '?')
QUERY_STRING="${URL#*\?}"

get_param() {
    local key="$1"
    echo "$QUERY_STRING" | grep -oP "(?<=[?&]|^)${key}=\K[^&]*" || true
}

# Extract values from URL
TOKEN=$(get_param "token")
USER_NAME=$(get_param "userName")
DISPLAY_NAME=$(get_param "displayName")
INTERNAL_USER_NAME=$(get_param "internalUserName")
AVATAR_ENCODED=$(get_param "avatar")
PROVIDER=$(get_param "provider")

# URL decode avatar string
AVATAR=$(python3 -c "import sys, urllib.parse; print(urllib.parse.unquote(sys.argv[1]))" "$AVATAR_ENCODED")

# Ensure output directory exists
mkdir -p "$(dirname "$FULL_OUTPUT_PATH")"

# Generate JSON and write to destination file
jq -n \
  --arg userId "$INTERNAL_USER_NAME" \
  --arg token "$TOKEN" \
  --arg userName "$USER_NAME" \
  --arg displayName "$DISPLAY_NAME" \
  --arg avatar "$AVATAR" \
  --arg provider "$PROVIDER" \
  --arg internalUserName "$INTERNAL_USER_NAME" \
  '{
    userId: $userId,
    token: $token,
    userName: $userName,
    displayName: $displayName,
    avatar: $avatar,
    provider: $provider,
    internalUserName: $internalUserName
  }' > "$FULL_OUTPUT_PATH"

echo "Successfully wrote configuration to:"
echo "  $FULL_OUTPUT_PATH"