#!/usr/bin/env bash
set -eu -o pipefail

function on_err() {
    local exit_code=$?
    echo "$*: Error on line '${LINENO}': ${BASH_COMMAND}"
    exit ${exit_code}
}

function generate_authorized_keys() {
    if [ -d /keys ]; then
        local tempfile; tempfile=$(mktemp)
        shopt -s nullglob
        for key in /keys/*; do
            cat "$key" >> "${tempfile}"
        done
        sort -u < "${tempfile}" > "/home/upload/.ssh/authorized_keys"
        chown upload:upload "/home/upload/.ssh/authorized_keys"
        chmod 600 "/home/upload/.ssh/authorized_keys"
    fi
}

function data_dir() {
    if [ ! -d /data/publish ]; then
        mkdir -p /data/publish
        chmod 755 /data/publish
        chown upload:upload /data/publish
    fi
}

function hostkeys() {
    if [ ! -f /etc/ssh/sshd_host_keys/ssh_host_ed25519_key ]; then
        ssh-keygen -t ed25519 -f /etc/ssh/sshd_host_keys/ssh_host_ed25519_key -N ''
    fi
    if [ ! -f /etc/ssh/sshd_host_keys/ssh_host_rsa_key ]; then
        ssh-keygen -t rsa -b 4096 -f /etc/ssh/sshd_host_keys/ssh_host_rsa_key -N ''
    fi
    chmod 600 /etc/ssh/sshd_host_keys/ssh_host_ed25519_key || true
    chmod 600 /etc/ssh/sshd_host_keys/ssh_host_rsa_key || true
}

trap on_err ERR
hostkeys
data_dir
generate_authorized_keys
exec /usr/sbin/sshd -D -e
