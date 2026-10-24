FROM alpine:3.22
RUN apk add --no-cache ca-certificates curl unzip nginx gettext tini \
 && mkdir -p /etc/xray /run/nginx /var/log/nginx
ARG XRAY_VERSION=26.9.9
RUN ARCH="$(uname -m)" \
 && case "$ARCH" in x86_64) XRAY_ARCH="64" ;; aarch64) XRAY_ARCH="arm64-v8a" ;; *) echo "Unsupported architecture: $ARCH"; exit 1 ;; esac \
 && curl -fsSL "https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-${XRAY_ARCH}.zip" -o /tmp/xray.zip \
 && unzip /tmp/xray.zip xray -d /usr/local/bin \
 && chmod +x /usr/local/bin/xray \
 && rm -f /tmp/xray.zip
COPY xray-config.template.json /etc/xray/config.template.json
COPY nginx.conf.template /etc/nginx/http.d/default.conf.template
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENV PORT=10000
EXPOSE 10000
ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]
