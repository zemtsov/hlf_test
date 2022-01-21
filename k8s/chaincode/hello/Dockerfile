ARG GO_VER=1.14.4
ARG ALPINE_VER=3.12

FROM golang:${GO_VER}-alpine${ALPINE_VER}

WORKDIR /Users/zemtsov/go/src/github.com/zemtsov/hlf_test/k8s/chaincode/hello
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...

EXPOSE 7070
CMD ["hello"]
