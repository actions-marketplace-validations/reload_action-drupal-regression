# Base image
FROM alpine:latest

# This hack is widely applied to avoid python printing issues in docker containers.
# See: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/pull/13
ENV PYTHONUNBUFFERED=1

RUN echo "**** install dependencies ****" && \
    apk add --no-cache bash ca-certificates curl python3 tidyhtml && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel colorama requests validators pytidylib && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

# Copies your code file repository to the filesystem
WORKDIR /src

COPY . /src

# change permission to execute the script
RUN chmod +x /src/entrypoint.sh

# file to execute when the docker container starts up
ENTRYPOINT ["/src/entrypoint.sh"]
