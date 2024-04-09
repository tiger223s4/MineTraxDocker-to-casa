#!/bin/bash

cd /home/mt

! [[ -f .env ]] && wget https://github.com/MineTrax/minetrax/raw/main/.env.example -O .env


[[ $APP_NAME ]] && sed -i -r s/APP_NAME=.+/APP_NAME=$APP_NAME/g .env
[[ $APP_LOCALE ]] && sed -i -r s/APP_LOCALE=.+/APP_LOCALE=$APP_LOCALE/g .env
[[ $AVAILABLE_LOCALES ]] && sed -i -r s/AVAILABLE_LOCALES=.+/AVAILABLE_LOCALES=$AVAILABLE_LOCALES/g .env
[[ $APP_THEME ]] && sed -i -r s/APP_THEME=.+/APP_THEME=$APP_THEME/g .env
[[ $APP_DEBUG ]] && sed -i -r s/APP_DEBUG=.+/APP_DEBUG=$APP_DEBUG/g .env
[[ $DEBUGBAR_ENABLED ]] && sed -i -r s/DEBUGBAR_ENABLED=.+/DEBUGBAR_ENABLED=$DEBUGBAR_ENABLED/g .env
[[ $TELESCOPE_ENABLED ]] && sed -i -r s/TELESCOPE_ENABLED=.+/TELESCOPE_ENABLED=$TELESCOPE_ENABLED/g .env
[[ $APP_URL ]] && sed -i -r s/APP_URL=.+/APP_URL=$APP_URL/g .env

[[ $LOG_DISCORD_WEBHOOK_URL ]] && sed -i -r s/LOG_DISCORD_WEBHOOK_URL=.+/LOG_DISCORD_WEBHOOK_URL=$LOG_DISCORD_WEBHOOK_URL/g .env

[[ $DB_HOST ]] && sed -i -r s/DB_HOST=.+/DB_HOST=$DB_HOST/g .env
[[ $DB_PORT ]] && sed -i -r s/DB_PORT=.+/DB_PORT=$DB_PORT/g .env
[[ $DB_DATABASE ]] && sed -i -r s/DB_DATABASE=.+/DB_DATABASE=$DB_DATABASE/g .env
[[ $DB_USERNAME ]] && sed -i -r s/DB_USERNAME=.+/DB_USERNAME=$DB_USERNAME/g .env
[[ $DB_PASSWORD ]] && sed -i -r s/DB_PASSWORD=.+/DB_PASSWORD=$DB_PASSWORD/g .env

[[ $REDIS_HOST ]] && sed -i -r s/REDIS_HOST=.+/REDIS_HOST=$REDIS_HOST/g .env
[[ $REDIS_PASSWORD ]] && sed -i -r s/REDIS_PASSWORD=.+/REDIS_PASSWORD=$REDIS_PASSWORD/g .env
[[ $REDIS_PORT ]] && sed -i -r s/REDIS_PORT=.+/REDIS_PORT=$REDIS_PORT/g .env


generatedDBUser=$(tr -dc A-Za-z0-9_ < /dev/urandom | head -c 12 | xargs)
generatedDBPass=$(tr -dc A-Za-z0-9_ < /dev/urandom | head -c 64 | xargs)

! [[ $DB_USERNAME ]] && DB_USERNAME=$generatedDBUser
! [[ $DB_PASSWORD ]] && DB_PASSWORD=$generatedDBPass

service php8.3-fpm start
service redis start

php artisan key:generate
php artisan migrate
php artisan db:seed

wget https://gist.github.com/Justman100/8e3fcd03ea9435d4d9b9c46a6d8f3736/raw/6b7c06f58b8442d62051f3a5c5b66d0169946975/maca -O /usr/bin/maca
chmod +x /usr/bin/maca

* * * * * php artisan schedule:run >> /dev/null 2>&1

service minetrax-worker start

cat << EOF > /home/Caddyfile
http://$(curl -sL 'https://api.ipify.org') {
	root * /home/mt/public
	encode gzip
	php_fastcgi unix//run/php/php8.3-fpm.sock
	file_server
}
EOF

caddy start --config /home/Caddyfile

tail -f /dev/null