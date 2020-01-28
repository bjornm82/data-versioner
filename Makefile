GIT_ORG_NAME ?= bjornm82
GIT_PROJECT_REPO ?= data-versioner

# Init variables
VERSION ?= $(shell git describe --tags --always)
COMMIT ?= $(shell git rev-parse HEAD)
BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)

.PHONY: build
build:
	docker build -t ${GIT_ORG_NAME}/${GIT_PROJECT_REPO}:${BRANCH}-${COMMIT} .

.PHONY: push
push:
	docker push ${GIT_ORG_NAME}/${GIT_PROJECT_REPO}:${BRANCH}-${COMMIT}

.PHONY: run
run:
	docker run -v $(PWD)/example/data:/tmp/data --name data-versioner --rm -it ${GIT_ORG_NAME}/${GIT_PROJECT_REPO}:${BRANCH}-${COMMIT}
