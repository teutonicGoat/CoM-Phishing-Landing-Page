#!/bin/bash

# sync-folders.sh
# Script to sync specific folders from a remote host using rsync
# Usage: ./sync-folders.sh <remote_host> <remote_path> <local_destination>

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required arguments are provided
if [ $# -lt 3 ]; then
    print_error "Insufficient arguments provided"
    echo "Usage: $0 <remote_host> <remote_path> <local_destination>"
    echo ""
    echo "Example:"
    echo "  $0 user@remotehost /src /local/backup"
    echo ""
    echo "This will sync the folders defined in the FOLDERS array below."
    exit 1
fi

REMOTE_HOST=$1
REMOTE_PATH=$2
LOCAL_DEST=$3

# Define the specific folders you want to sync
# Modify this array according to your needs
FOLDERS=(
    "Folder 01"
    "Folder 02"
    "Folder 03"
)

# rsync options as an array
RSYNC_OPTIONS=(-a -v -z -P)

# Optional: Add --dry-run to test without actually syncing
DRY_RUN=${DRY_RUN:-false}
if [ "$DRY_RUN" = "true" ]; then
    RSYNC_OPTIONS+=(--dry-run)
    print_warning "DRY RUN MODE - No files will be actually transferred"
fi

# Create local destination if it doesn't exist
if [ ! -d "$LOCAL_DEST" ]; then
    print_info "Creating local destination directory: $LOCAL_DEST"
    mkdir -p "$LOCAL_DEST"
fi

# Function to sync a single folder
sync_folder() {
    local folder=$1
    # Properly construct the remote path, removing any trailing slashes from REMOTE_PATH
    local remote_base="${REMOTE_PATH%/}"
    local remote_folder="$REMOTE_HOST:$remote_base/$folder"
    
    print_info "Syncing: $folder"
    
    if rsync "${RSYNC_OPTIONS[@]}" "$remote_folder" "$LOCAL_DEST/"; then
        print_info "Successfully synced: $folder"
        return 0
    else
        print_error "Failed to sync: $folder"
        return 1
    fi
}

# Main sync process
print_info "Starting sync from $REMOTE_HOST:$REMOTE_PATH to $LOCAL_DEST"
print_info "Folders to sync: ${#FOLDERS[@]}"
echo ""

FAILED_SYNCS=()
SUCCESSFUL_SYNCS=0

for folder in "${FOLDERS[@]}"; do
    if sync_folder "$folder"; then
        ((SUCCESSFUL_SYNCS++))
    else
        FAILED_SYNCS+=("$folder")
    fi
    echo ""
done

# Summary
echo "========================================"
print_info "Sync Summary"
echo "========================================"
print_info "Successful syncs: $SUCCESSFUL_SYNCS/${#FOLDERS[@]}"

if [ ${#FAILED_SYNCS[@]} -gt 0 ]; then
    print_error "Failed syncs: ${#FAILED_SYNCS[@]}"
    for failed in "${FAILED_SYNCS[@]}"; do
        echo "  - $failed"
    done
    exit 1
else
    print_info "All folders synced successfully!"
    exit 0
fi
