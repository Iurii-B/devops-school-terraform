#!/bin/bash
sudo apt update
sudo apt install -y python3-pip
pip install sqlalchemy
pip install flask
pip install keyring
pip install keyrings.alt
sudo apt install -y mariadb-client

wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
echo "fc84b8954141ed3c59ac7a1adfc8051c93171bae7ba34d7f9aeecd3b148f1527 mariadb_repo_setup"     | sha256sum -c -
chmod +x mariadb_repo_setup
sudo ./mariadb_repo_setup    --mariadb-server-version="mariadb-10.5"
sudo apt update
sudo apt install -y libmariadb3 libmariadb-dev

pip install mariadb

mkdir /home/ubuntu/flask
mkdir /home/ubuntu/flask/static
mkdir /home/ubuntu/flask/templates

touch /home/ubuntu/flask/app.py
touch /home/ubuntu/flask/parse_json.py
touch /home/ubuntu/flask/static/cover.css
touch /home/ubuntu/flask/templates/base_cover.html
touch /home/ubuntu/flask/templates/index.html
touch /home/ubuntu/flask/templates/countries_list.html
touch /home/ubuntu/flask/templates/country_detail.html
touch /home/ubuntu/flask/cert.pem
touch /home/ubuntu/flask/key.pem
