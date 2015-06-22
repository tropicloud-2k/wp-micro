FROM alpine:3.2

ADD wpm /wpm
RUN /wpm/wpm.sh build

ENV WP_ENV=development \
	WP_SSL=false \
	WP_REPO=https://github.com/roots/bedrock.git

EXPOSE 80 443
CMD ["wpm start"]
