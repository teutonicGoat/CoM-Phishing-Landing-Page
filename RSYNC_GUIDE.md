# Using rsync to Copy Specific Folders

This guide explains how to use rsync to copy specific folders from a remote host to your local machine or another remote location.

## Basic Syntax

```bash
rsync [options] source destination
```

## Copying Multiple Specific Folders

When you need to copy specific folders (like "Folder 01", "Folder 02", and "Folder 03") from a remote host, you have several options:

### Option 1: Multiple rsync Commands

The most straightforward approach is to run rsync separately for each folder:

```bash
rsync -avz remotehost:/src/Folder\ 01 /local/destination/
rsync -avz remotehost:/src/Folder\ 02 /local/destination/
rsync -avz remotehost:/src/Folder\ 03 /local/destination/
```

**Note:** Use backslash (`\`) to escape spaces in folder names, or wrap the path in quotes.

### Option 2: Using Brace Expansion (Bash)

If your folders follow a pattern, you can use brace expansion:

```bash
rsync -avz remotehost:/src/Folder\ 0{1,2,3} /local/destination/
```

### Option 3: Using --include and --exclude Filters

For more complex scenarios, use rsync's filtering options:

```bash
rsync -avz \
  --include='Folder 01' \
  --include='Folder 02' \
  --include='Folder 03' \
  --exclude='*' \
  remotehost:/src/ /local/destination/
```

**Important:** The order matters! Include rules must come before exclude rules.

### Option 4: Using --files-from

Create a file listing the folders you want to sync:

```bash
# Create a file list
cat > folders.txt << EOF
Folder 01
Folder 02
Folder 03
EOF

# Use the file list with rsync
rsync -avz --files-from=folders.txt remotehost:/src/ /local/destination/
```

## Common rsync Options

- `-a` (archive): Preserves permissions, timestamps, symbolic links, etc.
- `-v` (verbose): Shows detailed output of what's being transferred
- `-z` (compress): Compresses data during transfer to save bandwidth
- `-r` (recursive): Copies directories recursively
- `-P` (progress): Shows progress during transfer
- `--dry-run`: Shows what would be transferred without actually doing it
- `--delete`: Deletes files in destination that don't exist in source

## Examples for This Repository

### Syncing Images from Remote Server

```bash
# Sync specific image folders to local images directory
rsync -avzP remotehost:/var/www/phishing-page/images/ ./images/
```

### Testing Before Actual Sync

Always test with `--dry-run` first:

```bash
rsync -avz --dry-run remotehost:/src/Folder\ 01 /local/destination/
```

## SSH Authentication

If you need to specify SSH options:

```bash
rsync -avz -e "ssh -p 2222 -i ~/.ssh/id_rsa" remotehost:/src/Folder\ 01 /local/destination/
```

## Best Practices

1. **Always test with --dry-run first** to see what will happen
2. **Use absolute paths** to avoid confusion
3. **Escape spaces** in folder names or use quotes
4. **Consider trailing slashes**: `/src/` vs `/src` behaves differently
   - `/src/` copies the contents of src
   - `/src` copies the src directory itself
5. **Use -P flag** to see progress and keep partially transferred files
6. **Backup important data** before running rsync with --delete

## Troubleshooting

### Permission Denied
Ensure you have SSH access and proper permissions on both source and destination.

### Partial Transfers
Use the `-P` flag to keep partial transfers and resume interrupted syncs.

### Spaces in Folder Names
Always escape spaces with backslash or wrap paths in quotes:
```bash
rsync -avz "remotehost:/src/Folder 01" /local/destination/
```
