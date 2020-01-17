FROM debian:stretch

ARG PUID=1000
ARG PGID=1000

ENV MINECRAFT_VERSION=1.12.2 \
    MIN_RAM=1G \
    MAX_RAM=2G \
    TZ=Europe/Moscow

RUN apt update; \
    apt upgrade -y; \
    apt install -y curl openjdk-8-jre-headless; \
    mkdir /app /data; \
    curl -sL "https://github.com/marblenix/minecraft_downloader/releases/download/latest/minecraft_downloader_linux" -o /app/downloader; \
    chmod +x /app/downloader; \
    groupadd -g $PGID minecraft; \
    useradd -M -u $PUID -g minecraft minecraft

RUN echo '#!/bin/bash' > /docker-entrypoint.sh; \
    echo '' >> /docker-entrypoint.sh; \
    echo '# update system completely.' >> /docker-entrypoint.sh; \
    echo 'apt update' >> /docker-entrypoint.sh; \
    echo 'apt upgrade -y' >> /docker-entrypoint.sh; \
    echo '' >> /docker-entrypoint.sh; \
    echo '#if /data/server do not exist, download it.' >> /docker-entrypoint.sh; \
    echo 'if [ ! -e /data/minecraft_server_${MINECRAFT_VERSION}.jar ]' >> /docker-entrypoint.sh; \
    echo 'then' >> /docker-entrypoint.sh; \
    echo '    echo "Vanilla server with version ${MINECRAFT_VERSION} not found in /data! Installing now..."' >> /docker-entrypoint.sh; \
    echo '    /app/downloader -v ${MINECRAFT_VERSION} -o /data/minecraft_server_${MINECRAFT_VERSION}.jar' >> /docker-entrypoint.sh; \
    echo '    echo "Vanilla server version ${MINECRAFT_VERSION} has been installed successfully"' >> /docker-entrypoint.sh; \
    echo 'fi' >> /docker-entrypoint.sh; \
    echo '' >> /docker-entrypoint.sh; \
    echo '# if /data/eula.txt do not exist, create it.' >> /docker-entrypoint.sh; \
    echo 'if [ ! -e /data/eula.txt ]' >> /docker-entrypoint.sh; \
    echo 'then' >> /docker-entrypoint.sh; \
    echo '    echo "Agreeing with EULA automatically :D"' >> /docker-entrypoint.sh; \
    echo '    echo eula=true > /data/eula.txt' >> /docker-entrypoint.sh; \
    echo 'fi' >> /docker-entrypoint.sh; \
    echo '' >> /docker-entrypoint.sh; \
    echo '# fix permissions' >> /docker-entrypoint.sh; \
    echo 'chown -R minecraft:minecraft /app /data' >> /docker-entrypoint.sh; \
    echo '' >> /docker-entrypoint.sh; \
    echo '#run server.' >> /docker-entrypoint.sh; \
    echo 'cd /data' >> /docker-entrypoint.sh; \
    echo 'runuser -p -u minecraft -c "java -Xms${MIN_RAM} -Xmx${MAX_RAM} -jar /data/minecraft_server_${MINECRAFT_VERSION}.jar nogui"' >> /docker-entrypoint.sh; \
    chmod +x /docker-entrypoint.sh

VOLUME /data
EXPOSE 25565

CMD /docker-entrypoint.sh