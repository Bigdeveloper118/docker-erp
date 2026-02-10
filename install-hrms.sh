#!/bin/bash

echo "Installing HRMS..."

docker-compose exec erpnext bash -c "
cd /home/frappe/frappe-bench

# Get HRMS if not exists
if [ ! -d apps/hrms ]; then
  echo 'Downloading HRMS app...'
  bench get-app hrms --branch version-15
  
  echo 'Installing HRMS Python dependencies...'
  cd apps/hrms
  pip install -e .
  cd /home/frappe/frappe-bench
fi

# Install to site
echo 'Installing HRMS to site...'
bench --site library.localhost install-app hrms

echo 'HRMS installation complete!'
"

echo "Restarting services..."
docker-compose restart

echo "Done! HRMS is now available."
