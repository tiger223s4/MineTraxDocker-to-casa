FROM debian:trixie

WORKDIR /home

RUN apt-get update && apt-get install apt-utils ca-certificates -y

COPY assets/sources.list /etc/apt/sources.list
COPY assets/apt.gpg /etc/apt/trusted.gpg.d/php.gpg

RUN apt-get update && apt-get upgrade -y

RUN apt-get install cron cmake curl dialog gnupg git htop iputils-ping \
                    libpq-dev lsb-release lsof make nano pkgconf python3 \
                    python3-venv python3-pip unzip wget xz-utils zip -y

COPY assets/scripts/redis /etc/init.d/redis
RUN chmod +x /etc/init.d/redis

COPY assets/scripts/setup.sh .
RUN bash setup.sh

COPY --from=docker.io/library/redis:7.2.4 /usr/local/bin/redis-server /usr/bin/redis-server
RUN chmod +x /usr/bin/redis-server

COPY --from=docker.io/library/caddy:latest /usr/bin/caddy /usr/bin/caddy
RUN chmod +x /usr/bin/caddy

COPY assets/minetrax-worker /etc/init.d/minetrax-worker
RUN chmod +x /etc/init.d/minetrax-worker

COPY assets/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT [ "docker-entrypoint.sh" ]