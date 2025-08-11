#!/bin/bash

# Liquibase initialization script using Docker
# This script runs Liquibase migrations against the MariaDB database

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DB_HOST="host.docker.internal"
DB_PORT="3306"
DB_NAME="demo_db"
DB_USER="demo_user"
DB_PASSWORD="demo_password"
LIQUIBASE_VERSION="4.25"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${YELLOW}Starting Liquibase initialization...${NC}"

# Check if MariaDB container is running
echo -e "${YELLOW}Checking MariaDB container status...${NC}"
if ! docker ps | grep -q mariadb_db; then
    echo -e "${RED}MariaDB container is not running. Starting it now...${NC}"
    cd "$PROJECT_ROOT"
    docker-compose up -d mariadb
    
    # Wait for MariaDB to be ready
    echo -e "${YELLOW}Waiting for MariaDB to be ready...${NC}"
    timeout=60
    counter=0
    while ! docker exec mariadb_db healthcheck.sh --connect --innodb_initialized > /dev/null 2>&1; do
        if [ $counter -ge $timeout ]; then
            echo -e "${RED}Timeout waiting for MariaDB to start${NC}"
            exit 1
        fi
        echo "Waiting for MariaDB... ($counter/$timeout)"
        sleep 2
        counter=$((counter + 2))
    done
    echo -e "${GREEN}MariaDB is ready!${NC}"
else
    echo -e "${GREEN}MariaDB container is already running${NC}"
fi

# Run Liquibase update
echo -e "${YELLOW}Running Liquibase migrations...${NC}"

# Run Liquibase in Docker container
docker run --rm \
    -v "$PROJECT_ROOT:/liquibase/changelog" \
    -w /liquibase/changelog \
    liquibase/liquibase:$LIQUIBASE_VERSION \
    --defaults-file=liquibase.properties \
    update

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Liquibase migrations completed successfully!${NC}"
    
    # Show database status
    echo -e "${YELLOW}Database tables:${NC}"
    docker exec mariadb_db mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -e "SHOW TABLES;"
    
    # Show Liquibase changelog
    echo -e "${YELLOW}Liquibase changelog:${NC}"
    docker exec mariadb_db mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -e "SELECT * FROM DATABASECHANGELOG ORDER BY DATEEXECUTED DESC LIMIT 5;"
else
    echo -e "${RED}Liquibase migrations failed!${NC}"
    exit 1
fi

echo -e "${GREEN}Initialization complete!${NC}"
