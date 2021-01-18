# Some simple testing tasks (sorry, UNIX only).
PYTHON  := python
PROGRAM := aiohttp
PACKAGE := python-$(PROGRAM)
VERSION := $(shell sed -n s/[[:space:]]*Version:[[:space:]]*//p $(PACKAGE).spec)

all: build

clean:
	@rm -rf build dist $(PROGRAM).egg-info $(PROGRAM)-*.tar.gz *.egg *.src.rpm

build:
	$(PYTHON) setup.py build

install:
	$(PYTHON) setup.py install --skip-build

dist: clean
	$(PYTHON) setup.py sdist

sources: clean
	@git archive --format=tar --prefix="$(PROGRAM)-$(VERSION)/" \
		$(shell git rev-parse --verify HEAD) | gzip > "$(PROGRAM)-$(VERSION).tar.gz"

srpm: sources
	rpmbuild -bs --define "_sourcedir $(CURDIR)" \
		--define "_srcrpmdir $(CURDIR)" $(PACKAGE).spec

.PHONY: all build  clean install dist sources srpm
