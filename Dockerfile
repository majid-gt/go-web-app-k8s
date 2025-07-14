# Stage 1: Build
FROM golang:1.22 AS builder

WORKDIR /app

COPY go.mod ./
COPY main.go ./
COPY static ./static

RUN go mod tidy
# IMPORTANT: Build for Linux explicitly
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main

# Stage 2: Run
FROM alpine:latest

WORKDIR /root/

COPY --from=builder /app/main .
COPY --from=builder /app/static ./static

EXPOSE 8080

CMD ["./main"]
