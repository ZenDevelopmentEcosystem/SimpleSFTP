IMAGE := perbohlin/simple-sftp
TAG := test

image:
	$(Q)docker build . \
		-t $(IMAGE):$(TAG)

tag:
	$(Q)docker tag $(IMAGE):$(TAG) $(IMAGE):latest

publish: tag
	$(Q)docker push $(IMAGE):latest

up: env-file
	$(Q)$(ROOT.dir)/bin/docker-compose.sh up -d

down:
	$(Q)$(ROOT.dir)/bin/docker-compose.sh down --remove-orphans

env-file: $(ROOT.dir)/.env

$(ROOT.dir)/.env:
	$(Q)touch "$(@)"
