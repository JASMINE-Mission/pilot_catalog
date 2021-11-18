IMAGE=jasmine-psql
VER=0.1
OPTS=

.PHONY: build-psql

build-psql:
	docker build $(OPTS) -t $(IMAGE):$(VER) psql
