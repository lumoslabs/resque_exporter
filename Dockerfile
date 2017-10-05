FROM instrumentisto/glide:0.13
WORKDIR /go/src/github.com/moznion/resque_exporter
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64
ARG REVISION=""
ARG VERSION=""
COPY glide* ./
RUN glide install --strip-vendor
COPY . ./
RUN go build -v -a \
    -ldflags "-s -X github.com/moznion/resque_exporter.rev=$REVISION -X github.com/moznion/resque_exporter.ver=$VERSION" \
    -installsuffix cgo -o /resque_exporter cmd/resque_exporter/resque_exporter.go \
    && chmod -v +x /resque_exporter

FROM scratch
ENTRYPOINT ["/resque_exporter"]
COPY --from=0 /resque_exporter .
