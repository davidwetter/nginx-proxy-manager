##### Install Docker + Docker Compse ##### 
# Script Name   : setup.sh
# Author				: David Wetter
# Created				: 2. Mai 2022
# Version				: 1.0.2

apt update && apt upgrade -y

apt install docker.io
systemctl start docker 
systemctl enable docker

## install docker-compose ##

apt install curl 

curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

docker-compose --version


##### Install Nginx Proxy Manager #####

## create projekt directory and open it ##
mkdir npm
cd npm

## create docker congig.json ##
nano config.json

{
  "database": {
    "engine": "mysql",
    "host": "db",
    "name": "npm",
    "user": "npm",
    "password": "npm",
    "port": 3306
  }
}

## creacker docker-compose.yml ##
nano docker-compose.yml

version: "3"
services:
  app:
    image: jc21/nginx-proxy-manager:latest
    restart: always
    ports:
      - 80:80
      - 81:81
      - 443:443
    volumes:
      - ./config.json:/app/config/production.json
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
    depends_on:
      - db
    environment:
    # if you want pretty colors in your docker logs:
    - FORCE_COLOR=1
  db:
    image: mariadb:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: "npm"
      MYSQL_DATABASE: "npm"
      MYSQL_USER: "npm"
      MYSQL_PASSWORD: "npm"
    volumes:
      - ./data/mysql:/var/lib/mysql
      
      
## build the conatiner ##
docker-compose up -d

## acess via web browser ##
http://hostip:81

## default login ##
user: admin@example.com
pw: changeme
