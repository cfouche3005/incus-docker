ARG CURRENT_DIR
ARG TARGETARCH

FROM alpine as prepare

ARG CURRENT_DIR
ENV CURRENT_DIR=$CURRENT_DIR

RUN apk add --no-cache \
    bash

RUN mkdir -p /scripts
RUN mkdir -p /import
RUN mkdir -p /export

COPY $CURRENT_DIR/scripts /scripts
COPY $CURRENT_DIR/build /import

RUN find /scripts -name '*.sh' -exec chmod +x {} +
RUN /scripts/import.sh

FROM scratch as storage

COPY --from=prepare /export/incus /incus/lib
COPY --from=prepare /export/bin /incus/bin

FROM opensuse/tumbleweed as runtime

ARG CURRENT_DIR
ENV CURRENT_DIR=$CURRENT_DIR
ARG TARGETARCH
ENV TARGETARCH=$TARGETARCH
ENV FLAVOR=min

RUN mkdir -p /scripts
COPY $CURRENT_DIR/scripts /scripts

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

RUN mkdir -p /incus/lib
COPY --from=storage /incus/lib /incus/lib

RUN mkdir -p /incus/bin
COPY --from=storage /incus/bin/incusd /incus/bin/incusd

ENV PATH="/incus/bin:${PATH}"
ENV LD_LIBRARY_PATH="/incus/lib/deps/cowsql/.libs/:/incus/lib/deps/raft/.libs/:${LD_LIBRARY_PATH}"

CMD ["/incus/bin/incusd"]