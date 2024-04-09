# v2.0.0 (09.04.2024)
- Changed from Yarn to NPM
- RUF script removed
- Added Docker ignore file
- Containers now use user-friendly names
- Adding missed -rp parameter in the manage script
- Fixed a bug that caused data to be lost if one restarted the container
- MineTrax admin password will no longer be reset directly in the container (was too easy to overlook)
- Moved to a separate image regarding MariaDB (instead of being built in the same image, MariaDB will now be used separately)

# v1.1.0 (08.04.2024)
- Bug fixed where one could not use the commands `--exec`, `--command` and `--reset-password` in the *manage* script
- Bug fixed where the MineTrax instance in the browser only gave a black screen

# v1.0.0 (06.04.2024)
The beginning...