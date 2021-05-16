# Docker RSS Bridge

This is my personal method for using [RSS-Bridge][rss-bridge] to follow Twitter and Instagram accounts. It should be easily extendable for your purposes, including connecting to other bridges. The basic architecture is:

```
┌───────────────┐       ┌────────────────────┐
│  this docker  │       │  hostile "social"  │
│    image      ├───────▶     networks       │
└──────┬────────┘       └────────────────────┘
       │
       │
 ┌─────▼───────────┐
 │   atom feeds    │
 │  in s3 bucket   │
 └──────────────▲──┘            ┌───────────────────┐
                │               │  your preferred   │
                └───────────────┤    feed reader    │
                                └───────────────────┘
```

Behavior is controlled by environment variables:

```sh
docker run -e S3_BUCKET="my_bucket" -e TWITTER_USERNAMES="space separated usernames" -v ~/.aws:/root/.aws chriszarate/rss-bridge-s3:1.0.0
```

The above command will upload publicly accessible Atom feeds to your S3 bucket like so:

```
s3://my_bucket/feeds/twitter/[username].atom
```

It's up to you to configure web hosting for your S3 bucket. If you prefer you can also pass AWS credentials via environment variables instead of mapping the `~/.aws` directory.

## Instagram

Instagram currently bans IPs on a hair-trigger when you are not logged in, and it's basically impossible to circumvent. You'll have to create an account, [extract your session ID](https://github.com/RSS-Bridge/rss-bridge/issues/1891#issuecomment-816668065), and pass it as an environment variable:

```sh
docker run -e S3_BUCKET="my_bucket" -e INSTAGRAM_USERNAMES="space separated usernames" -e INSTAGRAM_SESSION_ID="my_session_id" -v ~/.aws:/root/.aws chriszarate/rss-bridge-s3:1.0.0
