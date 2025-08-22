# Docker ERP Setup 🐳

A Docker-based setup for Frappe, ERPNext, and HRMS with automated configuration and site creation using Makefile.

## Overview 📋

This project provides an automated way to set up Frappe, ERPNext, and HRMS systems using Docker containers. It includes a Makefile that automatically creates configuration files and manages site creation.

## Features ✨

- **Automated Configuration**: Generates `.env` and `common_site_config.json` files
- **Multi-system Support**: Frappe, ERPNext, and HRMS ready
- **Docker Integration**: Fully containerized environment
- **Easy Setup**: One-command deployment with Makefile
- **Customizable**: Configurable usernames, passwords, and site names

## Prerequisites 📋

Before running this project, make sure you have:

- [Docker](https://docs.docker.com/get-docker/) installed
- [Docker Compose](https://docs.docker.com/compose/install/) installed
- `make` command available on your system

## Quick Start 🚀

1. **Clone the repository**:
```bash
git clone https://github.com/Bigdeveloper118/docker-erp.git
cd docker-erp
```

2. **Run the setup**:
```bash
make
```

This will automatically:
- Create the `.env` file with root user and password configuration
- Generate `common_site_config.json` with database, Redis, MariaDB, and SocketIO settings
- Set up and create sites for Frappe, ERPNext, and HRMS

## Configuration Files 📝

### .env File
Contains environment variables for:
- Root username and password
- Database credentials
- System configurations

### common_site_config.json
Includes settings for:
- Database connection (MariaDB)
- Redis configuration
- SocketIO settings
- System-wide configurations

## Project Structure 📁

```
docker-erp/
├── Makefile              # Automation script
├── docker-compose.yml    # Docker services configuration
├── .env                  # Environment variables (auto-generated)
├── common_site_config.json # Site configuration (auto-generated)
├── sites/               # Frappe sites directory
└── README.md            # This file
```

## Makefile Commands 🛠️

The Makefile provides several targets for managing your ERP setup:

```bash
# Default target - full setup
make

# Individual targets (if available)
make setup-env          # Create .env file
make setup-config       # Create common_site_config.json
make create-sites       # Create Frappe/ERPNext/HRMS sites
make start              # Start all services
make stop               # Stop all services
make restart            # Restart all services
```

## Customization ⚙️

You can customize the default settings by modifying variables in the Makefile or by creating your own configuration files before running make.

### Common Customizations:
- **Root Username**: Change the default root user
- **Passwords**: Set secure passwords
- **Site Names**: Customize site domains
- **Database Settings**: Modify database configurations

## Services Included 🔧

- **Frappe Framework**: The underlying framework
- **ERPNext**: Complete ERP solution
- **HRMS**: Human Resource Management System
- **MariaDB**: Database server
- **Redis**: Caching and session storage
- **Nginx**: Web server and reverse proxy

## Usage Examples 💡

### Starting the System
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f
```

### Accessing the System
- **ERPNext**: http://localhost:8000
- **HRMS**: http://localhost:8001 (if configured separately)

### Managing Sites
```bash
# Enter Frappe container
docker-compose exec frappe bash

# Create new site
bench new-site example.com

# Install ERPNext
bench --site example.com install-app erpnext
```

## Troubleshooting 🔧

### Common Issues

1. **Port Conflicts**: 
   - Check if ports 8000, 3306, 6379 are available
   - Modify docker-compose.yml if needed

2. **Permission Issues**:
   ```bash
   sudo chown -R $USER:$USER sites/
   ```

3. **Database Connection**:
   - Ensure MariaDB container is running
   - Check database credentials in .env file

4. **Memory Issues**:
   - Increase Docker memory allocation
   - Monitor container resource usage

### Logs and Debugging
```bash
# View all service logs
docker-compose logs

# View specific service logs
docker-compose logs frappe
docker-compose logs mariadb
docker-compose logs redis
```

## Development Mode 🔨

For development purposes:

```bash
# Run in development mode (if configured)
docker-compose -f docker-compose.dev.yml up

# Access bench commands
docker-compose exec frappe bench --help
```

## Production Deployment 🚀

For production use:

1. **Security**: Change all default passwords
2. **SSL**: Configure HTTPS certificates
3. **Backup**: Set up regular database backups
4. **Monitoring**: Implement logging and monitoring
5. **Updates**: Keep containers updated

## Contributing 🤝

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support 💬

For support and questions:
- Create an issue in the GitHub repository
- Check the [Frappe Framework Documentation](https://frappeframework.com/docs)
- Visit [ERPNext Documentation](https://docs.erpnext.com/)

## Acknowledgments 🙏

- [Frappe Framework](https://github.com/frappe/frappe)
- [ERPNext](https://github.com/frappe/erpnext)
- [HRMS](https://github.com/frappe/hrms)
- Docker Community

## Changelog 📝

### v1.0.0
- Initial release
- Automated setup with Makefile
- Docker Compose configuration
- Multi-system support (Frappe, ERPNext, HRMS)

---

⭐ Star this repository if it helped you set up your ERP system!
