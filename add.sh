#!/usr/bin/env bash
# Adds a deliverable to the queue: creates the issue, puts it on the board, fills in fields.
# Usage: ./add.sh "Title" --for Chris|Alessandro|Nikolaus|Brad|Lab-wide [--priority High|Medium|Low]
#                         [--start YYYY-MM-DD] [--target YYYY-MM-DD] [--body "details"]
set -euo pipefail

OWNER="lyleantieau"
REPO="$OWNER/deliverables"
BOARD=1

TITLE="${1:?usage: ./add.sh \"Title\" --for NAME [--priority High] [--start DATE] [--target DATE] [--body TEXT]}"
shift
FOR="" PRIORITY="Medium" START="" TARGET="" BODY=""
while [ $# -gt 0 ]; do
  case "$1" in
    --for) FOR="$2" ;;
    --priority) PRIORITY="$2" ;;
    --start) START="$2" ;;
    --target) TARGET="$2" ;;
    --body) BODY="$2" ;;
    *) echo "unknown option: $1" >&2; exit 1 ;;
  esac
  shift 2
done

FIELDS=$(gh project field-list "$BOARD" --owner "$OWNER" --format json)
field() { jq -r --arg n "$1" '.fields[] | select(.name==$n) | .id' <<<"$FIELDS"; }
option() { jq -r --arg n "$1" --arg o "$2" '.fields[] | select(.name==$n) | .options[] | select(.name==$o) | .id' <<<"$FIELDS"; }
choices() { jq -r --arg n "$1" '[.fields[] | select(.name==$n) | .options[].name] | join(", ")' <<<"$FIELDS"; }

# Check names before creating anything, so a typo doesn't leave an orphan issue.
[ -n "$FOR" ] || { echo "--for is required: $(choices "Requested by")" >&2; exit 1; }
[ -n "$(option "Requested by" "$FOR")" ] || { echo "--for must be one of: $(choices "Requested by")" >&2; exit 1; }
[ -n "$(option Priority "$PRIORITY")" ] || { echo "--priority must be one of: $(choices Priority)" >&2; exit 1; }

URL=$(gh issue create --repo "$REPO" --title "$TITLE" --label deliverable \
  --body "${BODY:-_No details yet._}"$'\n\n'"For: $FOR")
ITEM=$(gh project item-add "$BOARD" --owner "$OWNER" --url "$URL" --format json --jq .id)
PROJECT=$(gh project view "$BOARD" --owner "$OWNER" --format json --jq .id)
edit() { gh project item-edit --id "$ITEM" --project-id "$PROJECT" "$@" >/dev/null; }

edit --field-id "$(field Status)" --single-select-option-id "$(option Status "Up next")"
edit --field-id "$(field Priority)" --single-select-option-id "$(option Priority "$PRIORITY")"
edit --field-id "$(field "Requested by")" --single-select-option-id "$(option "Requested by" "$FOR")"
[ -n "$START" ] && edit --field-id "$(field Start)" --date "$START"
[ -n "$TARGET" ] && edit --field-id "$(field Target)" --date "$TARGET"

echo "Added: $URL"
