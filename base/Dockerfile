ARG INCUS_VERSION

FROM opensuse/tumbleweed AS builder

WORKDIR /build

#install build dependencies
RUN zypper --non-interactive install \
    autoconf \
    automake \
    git \
    go \
    libacl-devel \
    libcap-devel \
    liblxc1 \
    liblxc-devel \
    sqlite3-devel \
    libtool \
    libudev1 \
    systemd-devel \
    liblz4-devel \
    libuv-devel \
    make \
    tcl \
    gawk \
    wget

ARG INCUS_VERSION

#get incus release
RUN wget https://github.com/lxc/incus/releases/download/v${INCUS_VERSION}/incus-$(echo ${INCUS_VERSION} | sed 's/\.[0]*$//').tar.xz

#extract incus release
RUN mkdir /build/incus && tar --no-same-owner -xvf incus-$(echo ${INCUS_VERSION} | sed 's/\.[0]*$//').tar.xz -C /build/incus --strip-components=1
WORKDIR /build/incus

#build incus dependencies
RUN make deps

#build incus
RUN CGO_CFLAGS="-I/build/incus/vendor/raft/include/ -I/build/incus/vendor/cowsql/include/" CGO_LDFLAGS="-L/build/incus/vendor/raft/.libs -L/build/incus/vendor/cowsql/.libs/" LD_LIBRARY_PATH="/build/incus/vendor/raft/.libs/:/build/incus/vendor/cowsql/.libs/" CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)" make

RUN cp /root/go/bin/incus-agent /root/go/bin/incus-agent.linux.$(uname -m)

#store incus files in a container image
#podman config
# FROM scratch AS output 

# ARG TARGETARCH

# COPY --from=builder /build/incus /linux_${TARGETARCH}/incus
# COPY --from=builder /root/go/bin /linux_${TARGETARCH}/bin

# docker config
FROM scratch AS output 

ARG TARGETARCH

COPY --from=builder /build/incus /incus
COPY --from=builder /root/go/bin /bin
