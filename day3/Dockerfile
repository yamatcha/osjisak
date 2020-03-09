# FROM alpine:3.4
# # ENV VERSION 2.14.02
# RUN apk add --no-cache nasm make gcc \
#   && rm -rf /var/cache/apk/*
# # VOLUME [ "/Users/soju/workspace/osjisak" ]
# CMD ["/bin/ash"]
# WORKDIR /test/day3

FROM ubuntu:16.04
RUN apt update
RUN apt install -y nasm make gcc libc6-i386 qemu bochs-sdl mtools 
# libc-dev-i386
# CMD [ "/bin/bash" ]
WORKDIR /test/day3
# CMD ["echo","SHELL"]
CMD make img
