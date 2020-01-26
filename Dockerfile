FROM debian:9

ARG PUID=1000
ARG PGID=1000
ARG MINECRAFT_VERSION=1.12.2

ENV MIN_RAM=1G \
    MAX_RAM=2G \
    TZ=Europe/Moscow

RUN apt update; \
    apt upgrade -y; \
    apt install -y curl openjdk-8-jre-headless; \
    curl -sL https://github.com/songdongsheng/su-exec/releases/download/1.3/su-exec-musl-static > /bin/su-exec && chmod +x /bin/su-exec; \
    mkdir /app /data /default; \
    groupadd -g $PGID minecraft; \
    useradd -M -u $PUID -g minecraft minecraft; \
    curl -sL "https://github.com/marblenix/minecraft_downloader/releases/download/latest/minecraft_downloader_linux" -o /app/downloader; \
    chmod +x /app/downloader; \
    /app/downloader -v ${MINECRAFT_VERSION} -o /default/minecraft_server.jar

RUN { \
        echo '#!/bin/bash'; \
        echo ''; \
        echo '#if server do not exist in mounted folder, copy it from the defaults.'; \
        echo 'if [ ! -e /data/minecraft_server.jar ]'; \
        echo 'then'; \
        echo '    echo "Vanilla server with version '${MINECRAFT_VERSION}' not found in /data! Installing now..."'; \
        echo '    cp /default/minecraft_server.jar /data/minecraft_server.jar'; \
        echo '    echo "Vanilla server version '${MINECRAFT_VERSION}' has been installed successfully!"'; \
        echo 'fi'; \
        echo ''; \
        echo '# fix eula automatically.'; \
        echo 'echo eula=true > /data/eula.txt'; \
        echo ''; \
        echo '# fix permissions.'; \
        echo 'chown -R minecraft:minecraft /data'; \
        echo ''; \
        echo '# run server.'; \
        echo 'cd /data'; \
        echo 'exec su-exec minecraft java -Xms${MIN_RAM} -Xmx${MAX_RAM} -jar /data/minecraft_server.jar nogui'; \
    } > /docker-entrypoint.sh; \
    chmod +x /docker-entrypoint.sh

VOLUME /data
EXPOSE 25565

CMD ["/docker-entrypoint.sh"]