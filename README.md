# MineTraxDocker
MineTrax for your Docker instances!

# Environments
### Following environments variables exists and can be changed
- APP_NAME
- APP_LOCALE
- AVAILABLE_LOCALES
- APP_THEME
- APP_DEBUG
- LOG_DISCORD_WEBHOOK_URL
- DEBUGBAR_ENABLED
- TELESCOPE_ENABLED
- APP_URL
- DB_HOST
- DB_PORT
- DB_DATABASE
- DB_USERNAME
- DB_PASSWORD
- REDIS_HOST
- REDIS_PASSWORD
- REDIS_PORT

# Installation
Run in an empty directory:

```bash
git init
git pull https://github.com/Justman100/MineTraxDocker
bash manage -s
```

# Usage
To manage the MineTrax container, you can use following the *manage* script:
<br>
`bash manage -e` => Join console (to run commands in a running MineTrax container)
<br>
`bash manage -c` => Run a artisan command inside the container
<br>
`bash manage -s` => Create and start a MineTrax container
<br>
`bash manage -r` => Reset a MineTrax container (kill and remove the existing and start a new fresh container)
<br>
`bash manage -k` => Kill a MineTrax container
<br>
`bash manage -d` => Kill and remove a MineTrax container
<br>

Note: To use multiple MineTrax containers, change `minetrax` under `services` in the `docker-compose.yml` to a different name (e.g. minetrax-example)


Variables that are not set will fall back to the default value in the .env! If the variable(s) `DB_USERNAME` or/and `DB_PASSWORD` is/are not set, a random username and/or password will be generated and used!