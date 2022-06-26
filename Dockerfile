FROM alpine:latest
LABEL maintainer="Per Böhlin <per.bohlin@devconsoft.se>"

RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk add --no-cache \
        bash \
        shadow@community \
        openssh-server-pam \
        openssh-sftp-server \
    && ln -s /usr/sbin/sshd.pam /usr/sbin/sshd \
    && mkdir -p /var/run/sshd \
    && rm -f /etc/ssh/ssh_host_*key* \
    && groupadd --gid 101 upload \
    && useradd --non-unique --uid 101 --gid 101 upload \
    && usermod -p "*" upload \
    && mkdir -p /home/upload/.ssh \
    && chown -R 101:101 /home/upload \
    && chmod 755 /home/upload \
    && chmod 700 /home/upload/.ssh

COPY files/sshd_config /etc/ssh/sshd_config
COPY files/entrypoint.sh /

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
