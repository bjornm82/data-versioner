# FROM golang:alpine AS builder
#
# RUN apk update && apk add --no-cache git
# WORKDIR $GOPATH/src/github.com/bjornm82/data-versioner
# COPY . .
#
# RUN ls -alh
#
# RUN go get -d -v
#
# RUN go build -o /go/bin/data-versioner

FROM alpine:3.7

# COPY --from=builder /go/bin/data-versioner /go/bin/data-versioner
# ENTRYPOINT ["/go/bin/data-versioner"]

RUN apk add --update build-base python3 python3-dev zlib-dev jpeg-dev linux-headers git bash

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install "dvc[s3]"

# CMD ["version"]
