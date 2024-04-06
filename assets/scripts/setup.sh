#!/bin/bash

# Install dependencies
wget http://ftp.de.debian.org/debian/pool/main/n/ncurses/libtinfo5_6.4-4_amd64.deb
wget http://ftp.de.debian.org/debian/pool/main/n/ncurses/libncurses5_6.4-4_amd64.deb
dpkg -i *.deb

# Setup MariaDB
adduser --gecos --disabled-login --disabled-password --no-create-home mysql

version=$(curl -s https://archive.mariadb.org/ | grep -oP "\d+\.\d+\.\d+" | sort -rV | head -n 1)
wget https://archive.mariadb.org/mariadb-$version/bintar-linux-systemd-x86_64/mariadb-$version-preview-linux-systemd-x86_64.tar.gz
gunzip mariadb-$version-preview-linux-systemd-x86_64.tar.gz
tar xvf mariadb-$version-preview-linux-systemd-x86_64.tar
mv mariadb-$version-preview-linux-systemd-x86_64 mariadb
mv mariadb /usr/local
rm -r *.tar
/usr/local/mariadb/scripts/mariadb-install-db --basedir=/usr/local/mariadb --datadir=/usr/local/mariadb/data
chmod -R 777 /usr/local/mariadb
ln -s /usr/local/mariadb /usr/local/mysql

ln -fs /usr/local/mariadb/bin/* /usr/bin

# Setup NodeJS
version=$(curl -s https://nodejs.org/dist/ | grep -oP '\d+\.\d+\.\d+' | sort -rV | head -n 1)
wget https://nodejs.org/dist/v$version/node-v$version-linux-x64.tar.xz
unxz *.xz
tar xvf *.tar
mv node-v$version-linux-x64 /usr/local/node
ln -s /usr/local/node/bin/* /usr/bin
node -v
rm -r *.tar
corepack enable


# Setup PHP
VERSION=8.3

apt-get install php${VERSION}-bcmath\
                php${VERSION}-cli \
                php${VERSION}-curl \
                php${VERSION}-fpm \
                php${VERSION}-gd \
                php${VERSION}-intl \
                php${VERSION}-mbstring \
                php${VERSION}-mysql \
                php${VERSION}-pdo \
                php${VERSION}-redis \
                php${VERSION}-tokenizer \
                php${VERSION}-xml \
                php${VERSION}-zip -y

ln -sf /usr/bin/php8.3 /usr/bin/php

# Setup Composer
wget https://getcomposer.org/download/latest-preview/composer.phar
mv composer.phar /usr/bin/composer
chmod +x /usr/bin/composer

mkdir /root/.config
mkdir /root/.config/composer
wget https://repo.packagist.org/packages.json -O /root/.config/composer/composer.json

mkdir /home/mt
cd /home/mt
git init
git pull https://github.com/MineTrax/minetrax.git
ruf

# Install composer dependencies
COMPOSER_ALLOW_SUPERUSER=1 composer install --no-scripts

# Install NodeJS dependencies
yarn

# Building MineTrax
yarn prod

chmod -R 777 .