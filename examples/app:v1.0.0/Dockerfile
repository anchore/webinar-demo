# first stage does the building
# for UX purposes, I'm naming this stage `build-stage`

FROM golang:1.20-alpine as build-stage
WORKDIR /go/src/go-hello-world
COPY hello-world.go .
COPY go.mod go.sum ./
RUN go mod download
RUN go build -o hello-world .


# starting second stage
FROM alpine:3.10.4

# copy the binary from the `build-stage`
COPY --from=build-stage /go/src/go-hello-world/hello-world /bin

CMD hello-world