# Container image that runs your code
FROM node:14.1-alpine

RUN apk add --no-cache git
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]