# Look at the [Wiki](https://github.com/capyBearista/home-server/wiki)!

This page just holds some of the YAML files I've used to set up services with Docker Compose. All personal information has been removed and replaced with placeholder values, so it should be easy to fill them in for yourself. Feel free to copy them!

## Files Overview

### 1. minecraft-docker-compose.yaml
- **Service**: Minecraft server with Modrinth modpack
- **Customization needed**:
  - Replace `player1`, `player2`, etc. in `WHITELIST` and `OPS` with actual usernames
  - Update `MOTD` to your server message
  - Change `SEED` to your preferred world seed
    - The one in there right now is pretty sweet though. There's a Plains village surrounded by a Cherry Grove valley near-ish spawn 🌸
  - Replace `VANILLATWEAKS_SHARECODE` with your actual share code
  - Update `MODRINTH_MODPACK` to your preferred modpack
    - I *highly* recommend [Adrenaline](https://github.com/skywardmc/adrenaline), a really great, lightweight performance modpack for servers
  - Update `MODRINTH_PROJECTS` to your preferred mods and datapacks
    - Check out [Spark](https://modrinth.com/mod/spark) to monitor your Minecraft server's performance
    - Check out [Chunky](https://modrinth.com/plugin/chunky) to pre-load chunks so you can ease your server's load when you're actually playing

### 2. pihole-docker-compose.yaml
- **Service**: Pi-hole DNS ad blocker
- **Customization needed**:
  - Change `WEBPASSWORD` to a secure password
  - Update IP addresses (`192.168.1.200`, `192.168.1.201`) to match your network
  - Modify `parent: eth0` to match your network interface name
  - Adjust subnet and gateway to match your network configuration

### 3. jellyfin-docker-compose.yaml
- **Service**: Jellyfin media server
- **Customization needed**:
  - Update `/path/to/your/media` to point to your media directory
  - Adjust `PUID` and `PGID` if needed (default 1000)

### 4. valheim-docker-compose.yaml
- **Service**: Valheim game server
- **Customization needed**:
  - Update all `/path/to/valheim/` paths to your actual Valheim directory
  - Create and configure the `valheim.env` file with server settings

### 5. convertx-docker-compose.yaml
- **Service**: ConvertX file conversion service
- **Customization needed**:
  - Change `JWT_SECRET` to a secure random string
  - Update volume path if needed

### 6. portainer-docker-compose.yaml
- **Service**: Portainer container management
- **Customization needed**: None - ready to use

### 7. immich-docker-compose.yml
- **Service**: Immich photo management
- **Customization needed**:
  - Create a `.env` file with database credentials and upload location
  - Configure environment variables as per Immich documentation

## Security Notes

- All passwords and personal information have been removed
- Replace all placeholder values before deployment
- Use strong, unique passwords for each service

## Usage

1. Clone this repository
2. Customize the configuration files as needed
3. Create any required `.env` files
4. Double check with documentation for each service; it's readily available
5. Run `docker-compose up -d` in the appropriate directory
6. For public-facing services (e.g., Minecraft), ensure you set up the necessary port forwarding settings on your router!