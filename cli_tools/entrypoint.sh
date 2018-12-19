#!/bin/sh
set -e

# Copy config files to $HOME
cp -r /rdataretriever/cli_tools/.pgpass  ~/
cp -r /rdataretriever/cli_tools/.my.cnf  ~/

exec "$@"
