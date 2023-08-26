# Use the official Golang image to create a build artifact.
# This is based on Debian and sets the GOPATH to /go.
# https://hub.docker.com/_/golang
FROM golang:1.19.2-buster

# Create and change to the app directory.
WORKDIR /app

# Retrieve application dependencies using go modules.
# Allows container builds to reuse downloaded dependencies.
COPY go.* ./
RUN go mod download

# Copy local code to the container image.
COPY . ./

# Build the binary.
RUN go build -v -o main main.go

# Installs latest Chromium package.
  RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    wget \
    curl \
    gnupg \
    unzip \
    ca-certificates \
    xfonts-utils \
    fonts-noto-cjk \
    fonts-wqy-zenhei \
    fonts-symbola \
    fonts-noto-color-emoji \
    && rm -rf /var/lib/apt/lists/*


# Installs Japanese Noto sans JP fonts.
RUN wget -q https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip \
  && unzip NotoSansCJKjp-hinted.zip \
  && wget -q https://noto-website-2.storage.googleapis.com/pkgs/NotoSerifCJKjp-hinted.zip \
  && unzip -o NotoSerifCJKjp-hinted.zip \
  && mkdir -p /usr/share/fonts/opentype/noto \
  && mv *.otf /usr/share/fonts/opentype/noto \
  && rm *.zip \
  && fc-cache -f
      
# Add Chromium as a user
RUN useradd -m chromium && chown -R chromium:chromium /app
USER chromium

ENV CHROME_BIN=/usr/bin/chromium
ENV CHROME_PATH=/usr/lib/chromium
RUN chmod +x /app/start-chromium.sh

CMD ["/app/start-chromium.sh", "/app/main"]
