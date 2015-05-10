FROM buildpack-deps:wheezy-scm

# gcc for cgo
RUN apt-get update && apt-get install -y \
		gcc libc6-dev make \
		--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.4.2

RUN curl -sSL https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz \
		| tar -v -C /usr/src -xz

RUN cd /usr/src/go/src && ./make.bash --no-clean 2>&1

ENV PATH /usr/src/go/bin:$PATH

RUN mkdir -p /go/src /go/bin && chmod -R 777 /go
ENV GOPATH /go
ENV PATH /go/bin:$PATH
WORKDIR /go

# install go tour zh
RUN go get bitbucket.org/mikespook/go-tour-zh/gotour
EXPOSE 3999
ENTRYPOINT ["/go/bin/gotour"]
CMD ["-openbrowser=false", "-http=0.0.0.0:3999"]
