FROM rssbridge/rss-bridge:latest

RUN apt-get update \
    && apt-get install -y awscli \
		&& apt-get clean

RUN curl \
    -o /app/bridges/InstagramBridge.php \
    "https://raw.githubusercontent.com/chriszarate/rss-bridge/8cc6ed3c7b86702cfc2e0fff7d8048cf37b83c2b/bridges/InstagramBridge.php"

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
