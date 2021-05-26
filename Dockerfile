FROM golang:1.16 AS builder
RUN CGO_ENABLED=0 go install -ldflags="-s -w -extldflags '-static'" github.com/gabrie30/ghorg@latest
RUN CGO_ENABLED=0 go install -ldflags="-s -w -extldflags '-static'" github.com/eth0izzle/shhgit@latest

FROM alpine:3.13
RUN apk add git
COPY --from=builder /go/bin/ghorg /usr/local/bin/
COPY --from=builder /go/bin/shhgit /usr/local/bin/
COPY --from=builder /etc/ssl/certs /etc/ssl/certs
#RUN addgroup -S app && adduser -S -G app app
#USER app

RUN mkdir -p /root/.config/ghorg     && \
 wget https://raw.githubusercontent.com/gabrie30/ghorg/master/sample-conf.yaml -O /root/.config/ghorg/conf.yaml && \
 wget https://raw.githubusercontent.com/eth0izzle/shhgit/master/config.yaml -O /config.yaml

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]