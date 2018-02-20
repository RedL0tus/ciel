PREFIX:=/usr/local

SRCDIR=$(shell pwd)

GOPATH=$(SRCDIR)/workdir
GOSRC=$(GOPATH)/src
GOBIN=$(GOPATH)/bin
CIELPATH=$(GOSRC)/ciel

DISTDIR=$(SRCDIR)/instdir
GLIDE=$(GOBIN)/glide

all: build

$(CIELPATH):
	mkdir -p $(DISTDIR)/bin
	mkdir -p $(DISTDIR)/libexec/ciel-plugin
	mkdir -p $(GOSRC)
	mkdir -p $(GOBIN)
	ln -f -s -T $(SRCDIR) $(CIELPATH)

$(GLIDE):
	curl https://glide.sh/get | sh
	
	
deps: $(CIELPATH) $(GLIDE)
	cd $(CIELPATH)
	$(GLIDE) install
	cd $(SRCDIR)

compile: deps
	go build -o $(DISTDIR)/bin/ciel ciel

plugins: plugin/*
	cp -fR plugin/* $(DISTDIR)/libexec/ciel-plugin

build: compile plugins

clean:
	-rm -r $(GOPATH)
	-rm -r $(DISTDIR)
	-rm -r $(SRCDIR)/vendor
	git clean -f -d $(SRCDIR)

install:
	cp -R $(DISTDIR)/* $(PREFIX)

.PHONY: all deps compile plugins build install
