#!/bin/bash
# Claude Backup Cleanup Script
# Part of dotfiles - moves .claude.json.backup* to designated backup location
# Portable across machines with different directory structures

# Use BACKUP_DIR from environment if set, otherwise default
BACKUP_ROOT="${BACKUP_DIR:-$HOME/Backups}"
CLAUDE_BACKUP_DIR="$BACKUP_ROOT/Backups/Claude"

# Create backup directory if it doesn't exist
mkdir -p "$CLAUDE_BACKUP_DIR"

# Move backup files from home directory
BACKUPS_MOVED=0
for backup in "$HOME"/.claude.json.backup*; do
    if [ -f "$backup" ]; then
        mv "$backup" "$CLAUDE_BACKUP_DIR/"
        BACKUPS_MOVED=$((BACKUPS_MOVED + 1))
    fi
done

if [ $BACKUPS_MOVED -gt 0 ]; then
    echo "✓ Moved $BACKUPS_MOVED Claude backup(s) to $CLAUDE_BACKUP_DIR"
else
    echo "✓ No Claude backups to clean up"
fi
