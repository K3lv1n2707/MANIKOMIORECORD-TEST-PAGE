#!/bin/sh
# El volumen de datos se monta como "root"; se le da permiso al usuario "node"
# y la app se ejecuta con ese usuario (más seguro que root).
set -e
mkdir -p "${DATA_DIR:-/app/data}/uploads"
chown -R node:node "${DATA_DIR:-/app/data}"
exec su-exec node "$@"
