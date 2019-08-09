FROM golang:1.8-alpine
ADD . /go/src/hello-app
RUN go install hello-ap

FROM alpine:latest
COPY --from=0 /go/bin/hello-app .
ENV PORT 8082
CMD ["./hello-app"]
