FROM golang:1.14 AS builder
RUN GO111MOD=off go get -d -u github.com/gabrie30/ghorg \
  && cd /go/src/github.com/gabrie30/ghorg \
  && CGO_ENABLED=0 go build -ldflags="-s -w -extldflags '-static'" -o /ghorg .

RUN GO111MOD=off go get -d -u github.com/eth0izzle/shhgit \
  && cd /go/src/github.com/eth0izzle/shhgit \
  && CGO_ENABLED=0 go build -ldflags="-s -w -extldflags '-static'" -o /shhgit .


FROM alpine
RUN apk add git
COPY --from=builder /ghorg /usr/local/bin/
COPY --from=builder /shhgit /usr/local/bin/
COPY --from=builder /go/src/github.com/gabrie30/ghorg/sample-conf.yaml /root/.config/ghorg/conf.yaml
COPY --from=builder /go/src/github.com/eth0izzle/shhgit/config.yaml /config.yaml
COPY --from=builder /etc/ssl/certs /etc/ssl/certs
#RUN addgroup -S app && adduser -S -G app app
#USER app
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]