# Init variables
GIT_ORG_NAME ?= bjornm82
GIT_PROJECT_REPO ?= data-versioner

VERSION ?= $(shell git describe --tags --always)
COMMIT ?= $(shell git rev-parse HEAD)
SHORT ?= $(shell git rev-parse --short HEAD)
BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)

GIT_DATA_REPO ?= https://github.com/bjornm82/data-version-repo

# ssh -T git@github.com
# git remote set-url origin git@github.com:username/your-repository.git
# git commit -am "Update README.md"
# git push

.PHONY: build
build:
	docker build -t ${GIT_ORG_NAME}/${GIT_PROJECT_REPO}:${BRANCH}-${SHORT} .

.PHONY: push
push:
	docker push ${GIT_ORG_NAME}/${GIT_PROJECT_REPO}:${BRANCH}-${SHORT}

.PHONY: run
run:
	docker run -v $(PWD)/example/data:/tmp/data \
	 -v /Users/bmooijekind/.ssh/data-versioner:/tmp/id_rsa \
	 -v /Users/bmooijekind/.ssh/data-versioner.pub:/tmp/id_rsa.pub \
	 --name data-versioner --rm -it ${GIT_ORG_NAME}/${GIT_PROJECT_REPO}:${BRANCH}-${SHORT}

.PHONY: build-cli
build-cli:
	docker build -t ${GIT_ORG_NAME}/${GIT_PROJECT_REPO}:${BRANCH}-${SHORT} .
