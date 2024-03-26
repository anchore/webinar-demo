FROM base:v1.0.0

RUN set -ex && \
    echo "aws_access_key_id=01234567890123456789" > /aws_access && \
    echo "-----BEGIN OPENSSH PRIVATE KEY-----" > /ssh_key && \
    microdnf -y install yum-utils python3-devel python3 python3-pip nodejs shadow-utils tar gzip && \
    yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo && \
    microdnf -y install terraform && \
    curl -sSfL  https://anchorectl-releases.anchore.io/anchorectl/install.sh  | sh -s -- -b $HOME/.local/bin && \
    adduser -d /xmrig mining && \
    pip3 install --index-url https://pypi.org/simple --no-cache-dir aiohttp pytest urllib3 botocore six numpy protobuf==3.20 && \
    npm install -g --cache /tmp/empty-cache debug chalk commander xmldom && \
    npm cache clean --force && \
    microdnf -y clean all && \
    echo "trigger package verification for gzip" >> /usr/share/doc/gzip/TODO && \
    rm -rf /var/cache/yum /tmp 

## just to make sure we have a unique build each time
RUN date > /image_build_timestamp && \
    touch image_build_timestamp_$(date +%Y-%m-%d_%T)

USER mining
WORKDIR /xmrig
ENTRYPOINT /bin/false