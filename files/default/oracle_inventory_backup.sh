#!/bin/bash
#
# Oracle Inventory Backup Script
# This script creates a backup of the Oracle inventory
#

# Set strict error handling
set -eo pipefail

# Script parameters
ORA_INST_PATH="${1:-/etc/oraInst.loc}"
BACKUP_DIR="${2:-/var/backups/oracle_inventory}"
MAX_BACKUPS="${3:-10}"

# Timestamp for backup file
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_FILENAME="oracle_inventory_backup_${TIMESTAMP}.tar.gz"
BACKUP_FILEPATH="${BACKUP_DIR}/${BACKUP_FILENAME}"

# Log function
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a /var/log/oracle/inventory_backup.log
}

# Create backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
  log "Creating backup directory: $BACKUP_DIR"
  mkdir -p "$BACKUP_DIR"
  chmod 750 "$BACKUP_DIR"
fi

# Check if oraInst.loc exists
if [ ! -f "$ORA_INST_PATH" ]; then
  log "ERROR: Oracle inventory file $ORA_INST_PATH not found"
  exit 1
fi

# Extract inventory location from oraInst.loc
INVENTORY_LOCATION=$(grep "^inventory_loc=" "$ORA_INST_PATH" | cut -d= -f2)

if [ -z "$INVENTORY_LOCATION" ]; then
  log "ERROR: Could not determine inventory location from $ORA_INST_PATH"
  exit 1
fi

if [ ! -d "$INVENTORY_LOCATION" ]; then
  log "ERROR: Inventory directory $INVENTORY_LOCATION not found"
  exit 1
fi

# Create backup
log "Creating backup of Oracle inventory at $INVENTORY_LOCATION"
tar -czf "$BACKUP_FILEPATH" -C "$(dirname "$INVENTORY_LOCATION")" "$(basename "$INVENTORY_LOCATION")"

# Also backup the oraInst.loc file
cp "$ORA_INST_PATH" "${BACKUP_DIR}/oraInst.loc_${TIMESTAMP}"

# Check if backup was successful
if [ -f "$BACKUP_FILEPATH" ]; then
  log "Backup completed successfully: $BACKUP_FILEPATH"
else
  log "ERROR: Backup failed"
  exit 1
fi

# Clean up old backups
OLD_BACKUPS=$(ls -t "${BACKUP_DIR}/oracle_inventory_backup_"*.tar.gz 2>/dev/null | tail -n +$((MAX_BACKUPS + 1)))

if [ -n "$OLD_BACKUPS" ]; then
  log "Removing old backups:"
  for OLD_BACKUP in $OLD_BACKUPS; do
    log "  - Removing $OLD_BACKUP"
    rm -f "$OLD_BACKUP"
  done
fi

# Clean up old oraInst.loc backups
OLD_ORAINST=$(ls -t "${BACKUP_DIR}/oraInst.loc_"* 2>/dev/null | tail -n +$((MAX_BACKUPS + 1)))

if [ -n "$OLD_ORAINST" ]; then
  log "Removing old oraInst.loc backups:"
  for OLD_FILE in $OLD_ORAINST; do
    log "  - Removing $OLD_FILE"
    rm -f "$OLD_FILE"
  done
fi

log "Backup process completed"
exit 0