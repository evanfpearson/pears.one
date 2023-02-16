FROM debian:11.6 as builder
ARG HUGO_VERSION="0.110.0"
WORKDIR /build
RUN apt update && apt install -y curl
RUN curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz | tar -xz && mv hugo /usr/local/bin
COPY . /build/
RUN hugo

FROM nginx
COPY --from=builder /build/public /usr/share/nginx/html
