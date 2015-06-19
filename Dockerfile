FROM alpine:3.2
MAINTAINER "Tropicloud" <admin@tropicloud.net>

ADD wpm /wpm
RUN /wpm/wpm.sh setup

ENV WP_REPO=https://github.com/roots/bedrock.git \
	WP_ENV=production \
	WP_SSL=false

EXPOSE 80 443
ENTRYPOINT ["wpm"]
CMD ["start"]
