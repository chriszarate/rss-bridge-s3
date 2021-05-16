#!/bin/bash

BASE_URL="http://localhost:$PORT/?action=display&format=Atom"

S3_BUCKET=`echo "$S3_BUCKET" | sed -E 's/^(s3:)?\/+//'`

if [ -z "$S3_BUCKET" ]; then
  echo "Missing S3_BUCKET environment variable."
  exit 1
fi

call_rss_bridge () {
  INSTAGRAM_SESSION_ID="$INSTAGRAM_SESSION_ID" php \
    /app/index.php \
    action=display \
    format=Atom \
    "$@"
}

upload_to_s3 () {
  if [ -z "$2" ]; then
    echo "Error generating feed"
    exit 1
  fi

  echo "Uploading $1"

  echo "$2" | \
    aws s3 cp \
      --acl="public-read" \
      --content-type="application/atom+xml" \
      - \
      "$1"
}

if [ ! -z "TWITTER_USERNAMES" ]; then
  for USERNAME in ${TWITTER_USERNAMES}; do
    FEED="s3://$S3_BUCKET/feeds/twitter/$USERNAME.atom"

    upload_to_s3 \
      "$FEED" \
      "$(call_rss_bridge bridge=Twitter context=By+username u=$USERNAME)"
  done
fi

if [ ! -z "INSTAGRAM_USERNAMES" ]; then
  for USERNAME in ${INSTAGRAM_USERNAMES}; do
    FEED="s3://$S3_BUCKET/feeds/instagram/$USERNAME.atom"

    upload_to_s3 \
      "$FEED" \
      "$(call_rss_bridge bridge=Instagram context=Username direct_links=on media_type=all u=$USERNAME)"
  done
fi
