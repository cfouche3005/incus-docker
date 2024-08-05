ARG PROJECT_DIR
ARG TARGETARCH

FROM alpine as prepare

ARG PROJECT_DIR
ENV PROJECT_DIR=$PROJECT_DIR

RUN apk add --no-cache \
    bash

RUN mkdir -p /scripts
RUN mkdir -p /import
RUN mkdir -p /export

COPY $PROJECT_DIR/scripts /scripts
COPY $PROJECT_DIR/build /import

RUN find /scripts -name '*.sh' -exec chmod +x {} +
RUN /scripts/import.sh

FROM scratch as storage

COPY --from=prepare /export/incus /incus/lib
COPY --from=prepare /export/bin /incus/bin

FROM opensuse/tumbleweed as runtime

ARG PROJECT_DIR
ENV PROJECT_DIR=$PROJECT_DIR
ARG TARGETARCH
ENV TARGETARCH=$TARGETARCH
ENV FLAVOR=min

RUN mkdir -p /scripts
COPY $PROJECT_DIR/scripts /scripts

RUN find /scripts -name '*.sh' -exec chmod +x {} +
RUN /scripts/packages.sh

# RUN zypper --non-interactive install \
#     libacl1 \
#     libcap2 \
#     liblxc1 \
#     sqlite3 \
#     libuv1 \
#     liblz4-1 \
#     libudev1 \
#     systemd