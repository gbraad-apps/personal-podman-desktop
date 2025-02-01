ARG BASE_IMAGE="ghcr.io/gbraad-devenv/fedora/rdesktop"
ARG BASE_VERSION=41

FROM ${BASE_IMAGE}:${BASE_VERSION}

ARG VERSION=1.16.0

USER root

RUN dnf install -y \
        podman \
        podman-remote \
    && dnf clean all \
    && rm -rf /var/cache/yum \
    && curl -fsSL https://github.com/podman-desktop/podman-desktop/releases/download/v${VERSION}/podman-desktop-${VERSION}.tar.gz \
        -o /tmp/pd.tar.gz \
    && mkdir -p /opt/podmandesktop \
    && tar --strip-components=1 -zxvf /tmp/pd.tar.gz \
        -C /opt/podmandesktop/ \
    && rm -rf /tmp/pd.tar.gz \
    && git config -f /etc/rdesktop/rdesktop.ini \
	    rdesktop.title "Personal Podman Desktop ${VERSION}" \
    && git config -f /etc/rdesktop/rdesktop.ini \
	    rdesktop.exec "/opt/podmandesktop/podman-desktop"

# ensure to become root for systemd
#ENTRYPOINT ["/sbin/init"]
