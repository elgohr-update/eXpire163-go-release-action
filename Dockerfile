
FROM debian:stretch-slim

ENV GOVERSION="1.17.2"
ENV GOOS=windows
ENV GOARCH=amd64
ENV GOPATH=/go
ENV CGO_ENABLED=1
ENV CC=x86_64-w64-mingw32-gcc
ENV CXX=x86_64-w64-mingw32-g++
ENV PATH="/go/bin:/usr/local/go/bin:${PATH}"
ENV PKG_CONFIG_PATH=/windows/mingw64/lib/pkgconfig
ENV MSYS2_ARCH=x86_64

RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  curl \
  wget \
  git \
  build-essential \
  gcc-mingw-w64-x86-64 \
  protobuf-compiler\
  zip \
  jq \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*



# install latest upx 3.96 by wget instead of `apt install upx-ucl`(only 3.95)
RUN wget --no-check-certificate --progress=dot:mega https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz && \
  tar -Jxf upx-3.96-amd64_linux.tar.xz && \
  mv upx-3.96-amd64_linux /usr/local/ && \
  ln -s /usr/local/upx-3.96-amd64_linux/upx /usr/local/bin/upx && \
  upx --version

# github-assets-uploader to provide robust github assets upload
RUN wget --no-check-certificate --progress=dot:mega https://github.com/wangyoucao577/assets-uploader/releases/download/v0.8.0/github-assets-uploader-v0.8.0-linux-amd64.tar.gz -O github-assets-uploader.tar.gz && \
  tar -zxf github-assets-uploader.tar.gz && \
  mv github-assets-uploader /usr/sbin/ && \
  rm -f github-assets-uploader.tar.gz && \
  github-assets-uploader -version

COPY *.sh /
ENTRYPOINT ["/entrypoint.sh"]

LABEL maintainer = "Jay Zhang <wangyoucao577@gmail.com>"
LABEL org.opencontainers.image.source = "https://github.com/wangyoucao577/go-release-action"
