#!/bin/bash

# Install dependencies
wget http://ftp.de.debian.org/debian/pool/main/n/ncurses/libtinfo5_6.4-4_amd64.deb
wget http://ftp.de.debian.org/debian/pool/main/n/ncurses/libncurses5_6.4-4_amd64.deb
dpkg -i *.deb

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

# Install composer dependencies
COMPOSER_ALLOW_SUPERUSER=1 composer install --no-scripts

# Install NodeJS dependencies
npm install

# Building MineTrax
npm run prod

chmod -R 777 .