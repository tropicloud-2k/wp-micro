FROM alpine:3.2
MAINTAINER "Tropicloud" <admin@tropicloud.net>

ADD wpm /wpm
RUN /wpm/wpm.sh setup

EXPOSE 80 443
ENTRYPOINT ["wpm"]
CMD ["start"]
