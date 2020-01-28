GIT_ORG_NAME ?= bjornm82
GIT_PROJECT_REPO ?= data-versioner

# Init variables
VERSION ?= $(shell git describe --tags --always)
COMMIT ?= $(shell git rev-parse HEAD)
BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)

.phony: build
build:
	docker build -t ${GIT_ORG_NAME}/${GIT_PROJECT_REPO}:${COMMIT}-${BRANCH} .
