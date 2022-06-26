Development
===========

Docker Compose
--------------

For convenience, the make system can bring up a container using docker compose
with the command:

```shell
make up
```

If local test environment specific details need to be added, a file named
`local-docker-compose.yml` can be added to the directory root.
This extra file is not included when running static check on the included docker-compose.yml file.
