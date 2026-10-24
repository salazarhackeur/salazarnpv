#!/bin/sh
set -eu
: "${PORT:=10000}"
: "${CLIENT_UUID:?Set CLIENT_UUID in the hosting dashboard}"
: "${WS_PATH:=/salazardasilva}"
case "$WS_PATH" in /*) ;; *) WS_PATH="/$WS_PATH" ;; esac
export PORT CLIENT_UUID WS_PATH
envsubst '${CLIENT_UUID} ${WS_PATH}' < /etc/xray/config.template.json > /etc/xray/config.json
envsubst '${PORT} ${WS_PATH}' < /etc/nginx/http.d/default.conf.template > /etc/nginx/http.d/default.conf
/usr/local/bin/xray run -config /etc/xray/config.json &
XRAY_PID=$!
nginx -t
nginx -g 'daemon off;' &
NGINX_PID=$!
cleanup() { kill "$XRAY_PID" "$NGINX_PID" 2>/dev/null || true; }
trap cleanup EXIT INT TERM
wait "$NGINX_PID"
