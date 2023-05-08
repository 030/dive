FROM golang:1.20.4-alpine3.17 as builder
ARG VERSION
ENV USERNAME=dive
ENV BASE=/opt/${USERNAME}
ENV DOCKER_CLI_VERSION=19.03.1
COPY . /go/${USERNAME}/
WORKDIR /go/${USERNAME}/cmd/${USERNAME}/
# remove group with id 999 to ensure that it can be assigned to docker group
RUN delgroup ping
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN apk add --no-cache curl=~7 git=~2 && \
  CGO_ENABLED=0 go build -ldflags "-X main.Version=${VERSION}" -buildvcs=false && \
  curl -sL https://gist.githubusercontent.com/030/54fc7ae735a163c09dcf6f3699d87e81/raw/3fcd3221f0e81ec85bcbb2dc8f014923e5230fdc/openshift-docker-user-entrypoint.sh > entrypoint.sh && \
  curl -sL https://gist.githubusercontent.com/030/34a2bf3f7f1cd427dc36c86dcb1e8cf7/raw/ca8944424c44efc4e31dc50868691a9bcf0c2805/openshift-docker-user.sh > user.sh && \
  chmod +x user.sh && \
  ./user.sh && \
  groups ${USERNAME} && \
  addgroup -S docker -g 999 && \
  addgroup ${USERNAME} docker && \
  groups ${USERNAME} && \
  curl https://download.docker.com/linux/static/stable/"$(uname -m)"/docker-${DOCKER_CLI_VERSION}.tgz | \
  tar -xzf - docker/docker --strip-component=1 && \
  mv docker /tmp/

FROM alpine:3.17.2
ENV BIN=/usr/local/bin/
ENV USERNAME=dive
ENV BASE=/opt/${USERNAME}
ENV BASE_BIN=${BASE}/bin
ENV PATH=${BASE_BIN}:${PATH}
COPY --from=builder /etc/group /etc/group
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /opt/ /opt/
COPY --from=builder /tmp/docker /usr/local/bin
USER ${USERNAME}
RUN groups $USERNAME
ENTRYPOINT ["entrypoint.sh"]
CMD ["dive"]
