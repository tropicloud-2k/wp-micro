# (wpm+) wp-micro

A Dockerfile for deploying [Bedrock](https://roots.io/bedrock/) based [WordPress](https://wordpress.org/) sites.

### What's included?

* Nginx
* PHP-FPM
* MariaDB
* Composer
* WP-CLI
* mSMTP
* Support for Redis (object cache)
* Support for Memcached (in-memory full page cache)


### Requirements

* [Docker](https://docs.docker.com/installation/)
* A domain  pointing to your Docker host


### Install

```shell
git clone https://github.com/tropicloud/wp-micro.git
docker build -t wp-micro wp-micro
docker run -it -p 80:80 -p 443:443 -h example.com wp-micro
```
