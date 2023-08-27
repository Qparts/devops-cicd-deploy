# Replace the following variables with your specific database configuration
DB_CONTAINER_NAME="some-postgres"
DB_NAME="q_user"
DB_USER="postgres"
DB_PASSWORD="mysecretpassword"
BACKUP_DIR="var/lib/postgresql/backups"

# Create the backup directory if it doesn't exist
docker exec "$DB_CONTAINER_NAME" mkdir -p "$BACKUP_DIR"

# Generate a timestamp for the backup file
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_FILE="$BACKUP_DIR/$DB_NAME-backup-$TIMESTAMP.backup"

# Use docker exec to run pg_dump inside the container and take the backup
docker exec "$DB_CONTAINER_NAME" pg_dump --file "$BACKUP_FILE" --host "localhost" --port "5432" --username "$DB_USER" --no-password --verbose --format=c --blobs --no-owner --section=pre-data --section=data --section=post-data "$DB_NAME"

# Check the exit code of pg_dump to determine if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successful. The backup file is located at: $BACKUP_FILE"
    docker cp $DB_CONTAINER_NAME:$BACKUP_FILE . 
else
    echo "Backup failed. Please check the error message."
fi

