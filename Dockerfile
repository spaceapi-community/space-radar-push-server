FROM golang:1.13-alpine as builder
RUN apk --no-cache add git
WORKDIR /go/src/app
COPY . .
RUN go get -d  ./...
RUN go generate
RUN go install


FROM alpine:latest
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
COPY --from=builder /go/bin/space-radar-push-server .
EXPOSE 8080
RUN adduser app -S -u 142
USER app

CMD ["./space-radar-push-server"]
