# Dockerfile
# syntax=docker/dockerfile:1

# Use the custom image with Go and Bun
FROM golang:1.22.1-alpine

# Set up working directory
WORKDIR /app

# Copy application files
COPY app/go.mod .
COPY app/go.sum .
RUN go mod download

COPY app/ .
RUN go build -o /docker-app

# Final stage: Run the application
EXPOSE 8080
CMD [ "/docker-app" ]
