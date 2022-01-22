ARG GO_VER=1.17.2
ARG ALPINE_VER=3.14

FROM golang:${GO_VER}-alpine${ALPINE_VER}

WORKDIR /etc/gopath/src/chaincode/hello
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...

EXPOSE 7070
CMD ["hello"]
