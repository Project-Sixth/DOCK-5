# General information
Docker for Vanilla Minecraft Server, based on Debian Stretch.
## Fast start
 1. `docker run --name minecraft-server --volume /srv/minecraft:/data --publish 25565:25565 --restart unless-stopped --detach theprojectsix/minecraft-server:1.12.2`
   - *this will download all server files and run server once*
 2. `docker stop minecraft-server`
 3. Configure as needed (manually)
 4. `docker start minecraft-server`

# Build/Run information
### Build Arguments
 - PUID = 1000 *- user ID that will run server*
 - PGID = 1000 *- group ID that will run server*

### Enviromental Variables
 - MINECRAFT_VERSION = 1.12.2 *- needed server version*
   - *notice: you can run literally any version of my docker image, and as long as you provide it with this enviromental variable - it will work like a charm. word of warning tho - do NOT change this variable on active containers - this will download and run new version of server and that can (and will) potentially harm your savefiles.*
   - *also notice - you can actually use word **latest** in here, and it will download literally latest available server.*
 - MIN_RAM = 1G *- minimal amount RAM that you want to give to server*
 - MAX_RAM = 2G *- maximal amount RAM that you want to give to server*
 - TZ = Europe/Moscow *- built-in feature in Debian - required timezone*

### Exposed Ports
 - 25565 *- standard Minecraft port*

### Mounted Volumes
 - /data *- contains every single file of your server*

# Best usage
For easiest usage of this image, I recommend you to use my manage script. It is available [**here**](https://github.com/Project-Sixth/DOCK-5/blob/master/manage.sh), at my GitHub. After you download my script (for example, you can use command `curl -sL https://raw.githubusercontent.com/Project-Sixth/DOCK-5/master/manage.sh > manage.sh; chmod +x manage.sh`), just follow next steps:
 1. Place script in any convinient place and make it executable (`chmod +x manage.sh`)
 2. Edit it with any editor and change mount directory to anywhere you find nessesary.
 3. Create new container by using command `manage.sh create`
 4. If you need to stop, restart or start container - easy as executing `manage.sh start|restart|stop`
 5. You also can use `manage.sh attach` to attach to RCON console. Exiting from it is `Ctrl+p Ctrl+q` keybind
