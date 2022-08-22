prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	echo "nothing to build"

install: 
	cp ".auto_crash.sh" "$(bindir)/auto_crash"

uninstall:
	rm -rf "$(bindir)/auto_crash"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
