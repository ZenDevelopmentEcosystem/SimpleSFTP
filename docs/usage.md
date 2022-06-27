Usage
=====

The official docker image:

```console
docker pull perbohlin/simple-sftp
```

User
----

The sftp user `upload` (the only user with access) has UID 100, GID 101.

Place the authorized keys in a directory and mount it as `/keys`. On startup, all
the files will be concatenated into the `upload`-user's authorized_keys file.

Password login has been disabled.

Data is stored at `/data` (owned by root) with the subdirectory `publish`
owned by the `upload`-user.

Example usage (id_rsa.pub has been placed in the mount `/keys`):

```console
docker run --rm -d -v"./keys:/keys" -v"./data:/data" -v"./hostkeys:/etc/ssh/sshd_host_keys" -p"2222:22 perbohlin/simple-sftp
sftp -i id_rsa -P 2222 upload@localhost
```

Host Keys
---------

The server host keys (ED25519, RSA-4096) are generated on start if they don't exist.
They are stored at `/etc/ssh/sshd_host_keys/`. It can be a good idea to preserve
the keys by setting up a mount on that location.

Backup
------

This service is stateless beyond host-keys and authorized keys and does not require backup.

Docker Compose
--------------

The repository contains a docker-compose example `docker-compose.yml`.
