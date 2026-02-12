FROM frappe/erpnext:v15.29.1

USER frappe

WORKDIR /home/frappe/frappe-bench/apps

# Clone HRMS
RUN git clone https://github.com/frappe/hrms --branch version-15 --depth 100

# Checkout ไป version 15.28.0
RUN cd hrms && git checkout 27e0c4be5 && cd ..

# Install dependencies
RUN cd hrms && pip install --user --no-cache-dir -e . && cd ..

WORKDIR /home/frappe/frappe-bench
