# Windows, PostgreSQL 10.4, Install from archive
The guide below is adapted from https://stackoverflow.com/questions/26441873/starting-postgresql-and-pgadmin-in-windows-without-installation.
1. Download the ZIP file from https://www.enterprisedb.com/products-services-training/pgbindownload.
2. Unzip the archive into a directory of your choice, say `<pgsql_dir>`
3. Initialize database storage area, as known as *database cluster*, at directory `<data_dir>` with C as locale, `root` as super user and SCRAM-SHA-256 password authentication.

        "<pgsql_dir>\bin\initdb.exe" -D "<data_dir>" --no-locale -E UTF8 -A scram-sha-256 -U root -W

4. Run the following command to start and stop PostgreSQL.

    Start in foreground

        "<pgsql_dir>\bin\postgres.exe" -D "<data_dir>"

    Start in background

        "<pgsql_dir>\bin\pg_ctl.exe" -D "<data_dir>" -l "<log_file>" start

    Stop in background

        "<pgsql_dir>\bin\pg_ctl.exe" -D "<data_dir>" stop
