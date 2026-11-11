
FROM alpine:3.24

LABEL maintainer="Per Böhlin <per.bohlin@devconsoft.se>"

RUN apk add --no-cache \
        bash \
        openssh-server \
    # Prepare SSH directories
    && mkdir -p /run/sshd /etc/ssh/sshd_host_keys \
    && chmod 700 /etc/ssh/sshd_host_keys \
    # Remove any default host keys
    && rm -f /etc/ssh/ssh_host_*key* \
    # Create the upload group and user
    && addgroup -g 101 upload \
    && adduser -D -h /home/upload -s /bin/sh \
        -u 100 -G upload upload \
    && echo 'upload:*' | chpasswd -e \
    # Prepare public-key authentication
    && mkdir -p /home/upload/.ssh \
    && chown -R 100:101 /home/upload \
    && chmod 755 /home/upload \
    && chmod 700 /home/upload/.ssh

COPY files/sshd_config /etc/ssh/sshd_config
COPY files/entrypoint.sh /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
