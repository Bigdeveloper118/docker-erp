FROM python:3.12

RUN apt-get update && apt-get install -y \
    mariadb-client redis-server npm nodejs curl git curl cron \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn \
    && rm -rf /var/lib/apt/lists/*

# สร้าง user frappe
RUN useradd -ms /bin/bash frappe

# ติดตั้ง bench CLI
RUN pip install frappe-bench

# เปลี่ยนไปใช้ user frappe
USER frappe
WORKDIR /home/frappe

# สร้าง bench
RUN bench init --frappe-branch version-15 frappe-bench

WORKDIR /home/frappe/frappe-bench

# ติดตั้ง erpnext และ hrms
RUN bench get-app erpnext --branch version-15
RUN bench get-app hrms --branch version-15

# รัน bench
CMD ["bench", "start"]
