FROM xmrig/xmrig:latest AS xmrig

FROM docker.io/redhat/ubi9-minimal:latest

LABEL maintainer="pvn@novarese.net"
LABEL name="2023-12-demo"
LABEL org.opencontainers.image.title="2023-12-demo"
LABEL org.opencontainers.image.description="Simple image to test various policy rules with Anchore Enterprise."

HEALTHCHECK --timeout=10s CMD /bin/true || exit 1

### if you need to use the actual rpm rather than the hints file, use this COPY and comment out the other one
### COPY Dockerfile sudo-1.8.29-5.el8.x86_64.rpm ./
COPY anchore_hints.json log4j-core-2.15.0.jar /
COPY --from=xmrig /xmrig/xmrig /xmrig/xmrig