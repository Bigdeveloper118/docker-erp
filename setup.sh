#!/bin/bash
echo "Stopping and removing all containers and volumes..."
docker-compose down -v

echo "Starting services..."
docker-compose up -d

echo "Waiting 20 seconds for services to be ready..."
sleep 20

echo "Creating site manually..."
docker-compose exec -T erpnext bash << 'EOFBASH'
cd /home/frappe/frappe-bench

# Ensure common config is correct
cat > sites/common_site_config.json << 'EOF'
{
  "db_host": "mariadb",
  "redis_cache": "redis://redis-cache:6379",
  "redis_queue": "redis://redis-queue:6379",
  "redis_socketio": "redis://redis-socketio:6379"
}
EOF

# Create site
bench new-site library.localhost \
  --mariadb-root-password StrongPassword123! \
  --admin-password Admin123! \
  --no-mariadb-socket

# Install apps
bench --site library.localhost install-app erpnext
bench --site library.localhost install-app hrms
bench use library.localhost

echo "Done!"
EOFBASH

echo "Restarting services..."
docker-compose restart

echo "Setup complete! Access at http://localhost"
