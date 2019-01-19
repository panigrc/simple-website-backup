## Simple Website/Database backup

Downloads any website and/or database using **ssh**.

### Features:

- Syncs files from remote to local (`rsync -avz`)
- Dumps and downloads database SQL file

### Requirements:

- SSH access
- rsync on local host

**For database backup:**

- MariaDB/MySQL
- mysqldump on remote host

### Installation:

```bash
git clone https://github.com/panigrc/simple-website-backup.git
chmod +x website-backup.sh
cp website-backup.default.conf website-backup.conf
```

Edit the `website-backup.conf` according your setup.

Run the script

```bash
./website-backup.sh
```