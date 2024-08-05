# Description: Dockerfile for building the minimal image of Incus

ARG TARGETARCH
ARG INCUS_FLAVOR=min

FROM alpine as prepare

ARG TARGETARCH
ENV TARGETARCH=$TARGETARCH

RUN apk add --no-cache \
    bash

RUN mkdir -p /scripts
RUN mkdir -p /export

COPY scripts /scripts


RUN find /scripts -name '*.sh' -exec chmod +x {} +
RUN --mount=type=bind,source=build,target=/import /scripts/import.sh

FROM scratch as storage

COPY --from=prepare /export/incus /incus/lib
COPY --from=prepare /export/bin /incus/bin

FROM opensuse/tumbleweed as runtime

ARG TARGETARCH
ENV TARGETARCH=$TARGETARCH
ARG INCUS_FLAVOR
ENV INCUS_FLAVOR=min

RUN mkdir -p /scripts
COPY --from=prepare /scripts /scripts
RUN /scripts/opensuse/packages.sh

# RUN zypper --non-interactive install \
#     libacl1 \
#     libcap2 \
#     liblxc1 \
#     sqlite3 \
#     libuv1 \
#     liblz4-1 \
#     libudev1 \
#     systemd

RUN mkdir -p /incus/lib
COPY --from=storage /incus/lib /incus/lib

RUN mkdir -p /incus/bin
COPY --from=storage /incus/bin/incusd /incus/bin/incusd

ENV PATH="/incus/bin:${PATH}"
ENV LD_LIBRARY_PATH="/incus/lib/deps/cowsql/.libs/:/incus/lib/deps/raft/.libs/:${LD_LIBRARY_PATH}"

CMD ["/scripts/start.sh"]