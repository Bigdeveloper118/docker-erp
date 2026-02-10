# Docker ERPNext Setup 🐳

A production-ready Docker setup for ERPNext v15 with HRMS, featuring automated configuration, multi-container architecture, and easy deployment.

## Overview 📋

This project provides a complete containerized ERPNext environment with proper service separation, automated site creation, and production-grade configuration. Built on Frappe Framework v15 with ERPNext and HRMS applications.

## Features ✨

- **Production-Ready**: Separate containers for web, workers, scheduler, and databases
- **Automated Setup**: One-command deployment with proper configuration
- **Multi-Queue Workers**: Short, default, and long queue workers for optimal performance
- **Redis Cluster**: Separate Redis instances for cache, queue, and socketio
- **Health Checks**: Automated service health monitoring
- **Persistent Storage**: Volume management for data persistence
- **Easy Scaling**: Container-based architecture for horizontal scaling

## Architecture 🏗️
```
┌─────────────┐
│   Nginx     │ :80 (Reverse Proxy)
└──────┬──────┘
       │
┌──────▼──────┐
│   ERPNext   │ :8000 (Gunicorn)
└──────┬──────┘
       │
       ├─────► MariaDB (Database)
       ├─────► Redis Cache
       ├─────► Redis Queue
       └─────► Redis SocketIO
       
Workers:
├── Queue Short    (Fast jobs)
├── Queue Default  (Normal jobs)
├── Queue Long     (Slow jobs)
└── Scheduler      (Cron jobs)
```

## Prerequisites 📦

- **Docker**: Version 20.10 or higher
- **Docker Compose**: Version 2.0 or higher
- **System Requirements**:
  - 4GB RAM minimum (8GB recommended)
  - 20GB free disk space
  - Linux/macOS/Windows with WSL2

## Quick Start 🚀

### 1. Clone the Repository
```bash
git clone https://github.com/Bigdeveloper118/docker-erp.git
cd docker-erp
```

### 2. Configure Environment

Create `.env` file:
```bash
cat > .env << 'EOF'
DB_ROOT_PASSWORD=YourSecurePassword123!
ADMIN_PASSWORD=AdminPass123!
SITE_NAME=library.localhost
EOF
```

### 3. Start Services
```bash
# Start all containers
docker-compose up -d

# Watch the logs
docker-compose logs -f configurator
docker-compose logs -f create-site

# Wait for site creation to complete (2-5 minutes)
docker-compose logs -f erpnext
```

### 4. Access ERPNext
```
URL: http://localhost
Username: Administrator
Password: AdminPass123! (from .env)
```

## Project Structure 📁
```
docker-erp/
├── docker-compose.yml           # Main orchestration file
├── .env                         # Environment variables
├── README.md                    # Documentation
│
└── volumes/                     # Docker volumes (auto-created)
    ├── mariadb-data/           # Database files
    ├── sites/                  # ERPNext sites
    │   ├── common_site_config.json
    │   └── library.localhost/
    └── logs/                   # Application logs
```

## Services 🔧

| Service | Description | Port |
|---------|-------------|------|
| **nginx** | Reverse proxy & static files | 80 |
| **erpnext** | Main application (Gunicorn) | 8000 |
| **mariadb** | Database server | 3306 |
| **redis-cache** | Caching layer | 6379 |
| **redis-queue** | Job queue | 6379 |
| **redis-socketio** | Real-time communication | 6379 |
| **queue-short** | Fast background jobs | - |
| **queue-default** | Normal background jobs | - |
| **queue-long** | Slow background jobs | - |
| **scheduler** | Scheduled tasks | - |

## Docker Compose Commands 🛠️
```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f [service-name]

# Restart a service
docker-compose restart [service-name]

# Execute commands in container
docker-compose exec erpnext bash

# View running containers
docker-compose ps

# Remove everything (including volumes)
docker-compose down -v
```

## Common Tasks 💡

### Create Additional Site
```bash
docker-compose exec erpnext bash

bench new-site newsite.localhost \
  --mariadb-root-password YourSecurePassword123! \
  --admin-password admin \
  --no-mariadb-socket

bench --site newsite.localhost install-app erpnext
bench --site newsite.localhost install-app hrms
exit
```

### Backup Site
```bash
# Backup database and files
docker-compose exec erpnext bench --site library.localhost backup

# Backups stored in: sites/library.localhost/private/backups/
```

### Restore Backup
```bash
docker-compose exec erpnext bench --site library.localhost restore \
  /home/frappe/frappe-bench/sites/library.localhost/private/backups/[backup-file]
```

### Update Apps
```bash
docker-compose exec erpnext bash

# Pull latest code
bench update --pull

# Run migrations
bench --site library.localhost migrate

# Build assets
bench build --app erpnext
```

### Clear Cache
```bash
docker-compose exec erpnext bench --site library.localhost clear-cache
```

### Install Additional App
```bash
docker-compose exec erpnext bash

# Download app
bench get-app [app-name] --branch version-15

# Install to site
bench --site library.localhost install-app [app-name]
```

## Configuration Files 📝

### common_site_config.json

Auto-generated with proper service connections:
```json
{
  "db_host": "mariadb",
  "db_port": 3306,
  "redis_cache": "redis://redis-cache:6379",
  "redis_queue": "redis://redis-queue:6379",
  "redis_socketio": "redis://redis-socketio:6379",
  "socketio_port": 9000
}
```

### .env Variables
```env
DB_ROOT_PASSWORD=<MariaDB root password>
ADMIN_PASSWORD=<ERPNext admin password>
SITE_NAME=<Your site domain>
```

## Troubleshooting 🔧

### Services Not Starting
```bash
# Check service status
docker-compose ps

# Check logs for errors
docker-compose logs mariadb
docker-compose logs erpnext

# Restart services
docker-compose restart
```

### Database Connection Issues
```bash
# Verify MariaDB is running
docker-compose exec mariadb mysql -uroot -p${DB_ROOT_PASSWORD} -e "SHOW DATABASES;"

# Check common_site_config.json
docker-compose exec erpnext cat sites/common_site_config.json

# Fix configuration
docker-compose exec erpnext bench set-config -g db_host mariadb
```

### Redis Connection Errors
```bash
# Test Redis connections
docker-compose exec erpnext redis-cli -h redis-cache ping
docker-compose exec erpnext redis-cli -h redis-queue ping
docker-compose exec erpnext redis-cli -h redis-socketio ping

# Update Redis config
docker-compose exec erpnext bench set-config -g redis_cache "redis://redis-cache:6379"
```

### Site Not Loading
```bash
# Check if site exists
docker-compose exec erpnext ls -la sites/

# Verify site config
docker-compose exec erpnext cat sites/library.localhost/site_config.json

# Rebuild
docker-compose exec erpnext bench build --app erpnext
```

### Port Conflicts
```bash
# Change port in docker-compose.yml
ports:
  - "8080:8080"  # Instead of 80:8080
```

### Permission Issues
```bash
# Fix ownership
docker-compose exec erpnext chown -R frappe:frappe sites/
```

## Production Deployment 🚀

### Security Checklist

- [ ] Change all default passwords
- [ ] Use strong passwords (16+ characters)
- [ ] Enable HTTPS/SSL
- [ ] Configure firewall rules
- [ ] Set up automated backups
- [ ] Enable monitoring and logging
- [ ] Restrict database access
- [ ] Use Docker secrets for sensitive data

### SSL Configuration
```yaml
# Add to nginx service in docker-compose.yml
nginx:
  ports:
    - "443:443"
  volumes:
    - ./ssl:/etc/nginx/ssl
    - ./nginx-ssl.conf:/etc/nginx/conf.d/default.conf
```

### Resource Limits
```yaml
# Add to services in docker-compose.yml
erpnext:
  deploy:
    resources:
      limits:
        cpus: '2'
        memory: 4G
      reservations:
        memory: 2G
```

### Automated Backups
```bash
# Create backup script
cat > backup.sh << 'EOF'
#!/bin/bash
docker-compose exec -T erpnext bench --site library.localhost backup
# Copy to external storage
EOF

# Add to crontab
0 2 * * * /path/to/backup.sh
```

## Performance Tuning ⚡

### Worker Scaling
```yaml
# Scale workers in docker-compose.yml
queue-default:
  deploy:
    replicas: 3
```

### Database Optimization
```yaml
mariadb:
  command:
    - --innodb-buffer-pool-size=2G
    - --max-connections=500
```

## Monitoring 📊

### View Logs
```bash
# All logs
docker-compose logs -f

# Specific service
docker-compose logs -f erpnext
docker-compose logs -f queue-default

# Last 100 lines
docker-compose logs --tail=100 erpnext
```

### Resource Usage
```bash
# Container stats
docker stats

# Disk usage
docker system df
```

## Contributing 🤝

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License 📄

MIT License - see [LICENSE](LICENSE) file

## Resources 📚

- [ERPNext Documentation](https://docs.erpnext.com/)
- [Frappe Framework Docs](https://frappeframework.com/docs)
- [Docker Documentation](https://docs.docker.com/)
- [ERPNext Forum](https://discuss.erpnext.com/)

## Support 💬

- **Issues**: [GitHub Issues](https://github.com/Bigdeveloper118/docker-erp/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Bigdeveloper118/docker-erp/discussions)
- **ERPNext Forum**: [discuss.erpnext.com](https://discuss.erpnext.com/)

## Changelog 📝

### Version 1.0.0 (Current)
- ✅ ERPNext v15.20.1
- ✅ Automated site creation
- ✅ Multi-container architecture
- ✅ Separate Redis instances
- ✅ Worker queue separation
- ✅ Health checks
- ✅ Production-ready configuration

---

**Built with ❤️ using Frappe Framework and Docker**

⭐ Star this repo if it helped you!
