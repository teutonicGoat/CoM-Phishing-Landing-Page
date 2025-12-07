# CoM-Phishing-Landing-Page
A landing page for CoM users who've clicked on phishing simulation links

## Deployment

### Syncing Specific Folders with rsync

If you need to copy specific folders from a remote server (e.g., for deployment or backup), see the [RSYNC_GUIDE.md](RSYNC_GUIDE.md) for detailed instructions.

You can also use the provided `sync-folders.sh` script:

```bash
# Test what would be synced (dry run)
DRY_RUN=true ./sync-folders.sh user@remotehost /src /local/destination

# Perform actual sync
./sync-folders.sh user@remotehost /src /local/destination
```

Edit the `FOLDERS` array in `sync-folders.sh` to specify which folders you want to sync.
