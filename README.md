# Look at the [Wiki](https://github.com/capyBearista/home-server/wiki)!

This page holds some of the YAML files I've used to set up services with Docker Compose, along with helper scripts and example config files. All personal information has been removed and replaced with placeholder values, so it should be easy to fill them in for yourself. Feel free to copy them!

## Docker Compose Files

### 1. minecraft-docker-compose.yml
- **Service**: Minecraft server with Modrinth modpack
- **Customization needed**:
  - Replace `player1`, `player2`, etc. in `WHITELIST` and `OPS` with actual usernames
  - Update `MOTD` to your server message
  - Replace `ICON` with a direct link to your server icon image
  - Change `SEED` to your preferred world seed
    - The one in there right now is pretty sweet though. There's a Plains village surrounded by a Cherry Grove valley near-ish spawn 🌸
  - Replace `VANILLATWEAKS_SHARECODE` with your actual share code
  - Update `MODRINTH_MODPACK` to your preferred modpack
    - I *highly* recommend [Adrenaline](https://github.com/skywardmc/adrenaline), a really great, lightweight performance modpack for servers
  - Update `MODRINTH_PROJECTS` to your preferred mods and datapacks
    - Check out [Spark](https://modrinth.com/mod/spark) to monitor your Minecraft server's performance
    - Check out [Chunky](https://modrinth.com/plugin/chunky) to pre-load chunks so you can ease your server's load when you're actually playing

### 2. minecraft-bedrock-docker-compose.yml
- **Service**: Minecraft Java server with Geyser + Floodgate for Bedrock crossplay
- **Customization needed**:
  - Replace `player1`, `player2`, etc. in `WHITELIST` and `OPS` with actual usernames
  - Update `MOTD`, `SEED`, and `LEVEL` for your world
  - Update `MODRINTH_PROJECTS` and `VANILLATWEAKS_SHARECODE` to your preferences
  - Adjust `MEMORY` allocation as needed (default: 6144M)

### 3. jellyfin-docker-compose.yml
- **Service**: Jellyfin media server
- **Customization needed**:
  - Update `/path/to/your/media` to point to your media directory
  - Adjust `PUID` and `PGID` if needed (default 1000)

### 4. immich-docker-compose.yml
- **Service**: Immich photo management
- **Customization needed**:
  - Create a `.env` file with database credentials and upload location
  - Configure environment variables as per Immich documentation

### 5. convertx-docker-compose.yml
- **Service**: ConvertX file conversion service
- **Customization needed**:
  - Change `JWT_SECRET` to a secure random string
  - Update volume path if needed

### 6. portainer-docker-compose.yml
- **Service**: Portainer container management
- **Customization needed**: None - ready to use

### 7. npmplus-docker-compose.yml
- **Service**: NPMplus reverse proxy (Nginx Proxy Manager fork)
- **Customization needed**:
  - Update `DB_MYSQL_PASSWORD`, `MYSQL_PASSWORD`, and `MYSQL_ROOT_PASSWORD`
  - Configure your domain and SSL certificates after first launch

### 8. paperless-docker-compose.yml
- **Service**: Paperless-ngx document management (with PostgreSQL, Redis, Tika, and Gotenberg)
- **Customization needed**:
  - Update `POSTGRES_PASSWORD` in the compose file
  - Create a companion `docker-compose.env` file with `PAPERLESS_SECRET_KEY`, `PAPERLESS_ADMIN_USER`, and `PAPERLESS_ADMIN_PASSWORD`
  - Update the media volume path (`/path/to/your/paperless/media`)

### 9. n8n-docker-compose.yml
- **Service**: n8n workflow automation (SQLite-backed, no external DB)
- **Customization needed**:
  - Set `N8N_HOST` and `WEBHOOK_URL` to your domain
  - Set `GENERIC_TIMEZONE` to your timezone

### 10. plausible-docker-compose.yml
- **Service**: Plausible CE web analytics (with PostgreSQL and ClickHouse)
- **Customization needed**:
  - Set `SECRET_KEY_BASE` (generate with `openssl rand -base64 48`)
  - Update `BASE_URL` to your domain
  - Change `POSTGRES_PASSWORD` from the placeholder
  - Ensure the `clickhouse/` directory with its config files exists alongside the compose file

### 11. uptime-kuma-docker-compose.yml
- **Service**: Uptime Kuma monitoring dashboard
- **Customization needed**: None - ready to use

### 12. backrest-docker-compose.yml
- **Service**: Backrest backup management (restic web UI)
- **Customization needed**:
  - Update volume paths for your backup source and repository locations

### 13. changedetection-docker-compose.yml
- **Service**: Changedetection.io website change monitoring (with Playwright browser)
- **Customization needed**:
  - Update `BASE_URL` to your server's IP address

### 14. tandoor-docker-compose.yml
- **Service**: Tandoor recipe manager (with PostgreSQL)
- **Customization needed**:
  - Create a `.env` file with database credentials and `SECRET_KEY` (all config is loaded via `env_file`, not inline)

### 15. hypermind-docker-compose.yml
- **Service**: Hypermind AI chat interface
- **Customization needed**: None - API keys for LLM providers are configured through the web UI after launch

## Scripts

### 16. backup-paperless-data.sh
- **Purpose**: Backs up the Paperless-ngx Docker volume (via rsync) and dumps its PostgreSQL database, keeping the last 7 days of SQL backups
- **Customization needed**:
  - Update `BACKUP_DEST`, `PAPERLESS_DIR`, and `LOG_FILE` paths
  - Update the external drive mount point and Docker volume name if yours differ

### 17. cron-git-backup.sh
- **Purpose**: Automated git commit and push of all changes in the user's home directory
- **Customization needed**:
  - Update the `USER` variable to your username

### 18. duck-dns.sh
- **Purpose**: Updates DuckDNS dynamic DNS record
- **Customization needed**:
  - Replace domain and token with your DuckDNS values

### 19. pre-backup-database-dumps.sh
- **Purpose**: Dumps PostgreSQL and MariaDB databases (Paperless, Immich, NPMplus, Tandoor) to `.sql` files before Backrest runs
- **Customization needed**:
  - Set `BACKUP_ROOT` to your dump directory
  - Update database credentials for NPMplus and Tandoor
  - Add or remove dump blocks to match the services you run

## Example Configs

### 20. example-crowdsec-npmplus.conf
- **Purpose**: CrowdSec Lua bouncer config for NPMplus — place in `<npmplus-data-dir>/crowdsec/crowdsec.conf`
- **Customization needed**:
  - `API_KEY` — generate with `sudo cscli bouncers add npmplus-bouncer`
  - Verify `API_URL` and `APPSEC_URL` match your Docker host gateway IP
  - Optionally configure captcha settings (`CAPTCHA_PROVIDER`, `SECRET_KEY`, `SITE_KEY`)

### 21. example-netplan.yml
- **Purpose**: Static IP netplan configuration example
- **Customization needed**:
  - Update IP addresses, gateway, and interface name for your network

### 22. example-fstab-entries.txt
- **Purpose**: Example `/etc/fstab` entries for mounting an external USB drive (NTFS) and hardening `/proc` with `hidepid=2`
- **Customization needed**:
  - Replace `YOUR-DRIVE-UUID-HERE` with the actual UUID of your drive (find with `lsblk -f`)
  - Adjust the mount path and NTFS mount options as needed

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