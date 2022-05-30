FROM --platform=${TARGETPLATFORM} teddysun/xray:1.5.5
LABEL maintainer "V2Fly Community <dev@v2fly.org>"

WORKDIR /root
ARG TARGETPLATFORM
ARG TAG
ARG DOWNLOADCONFIG
COPY v2ray.sh /root/v2ray.sh

RUN set -ex \
	&& apk add --no-cache tzdata openssl ca-certificates \
	&& mkdir -p /etc/v2ray /usr/local/share/v2ray /var/log/v2ray /usr/share/v2ray /etc/v2ray/ \
	&& chmod +x /root/v2ray.sh \
	&& /root/v2ray.sh "${TARGETPLATFORM}" "${TAG}"

RUN if [ "$DOWNLOADCONFIG" = "" ]; \
	then echo "DOWNLOADCONFIG is not set"; \
	else wget -O /etc/v2ray/config.json $DOWNLOADCONFIG; \
	fi

RUN wget -O /usr/share/v2ray/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat > /dev/null 2>&1 \
	&& wget -O /usr/share/v2ray/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat > /dev/null 2>&1 \
	&& wget -O /usr/share/xray/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat > /dev/null 2>&1 \
	&& wget -O /usr/share/xray/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat > /dev/null 2>&1

CMD [ "/usr/bin/v2ray", "-config", "/etc/v2ray/config.json" ]
