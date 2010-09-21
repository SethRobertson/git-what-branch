prefix=/usr/local
bindir=${prefix}/bin
mandir=${prefix}/share/man
man1dir=${mandir}/man1

PROG=git-what-branch
PACKAGE=git-what-branch
TARGETS=$(PROG).1 README $(PROG)
JUNK=$(PROG).1

all: $(TARGETS)

%.1: %
	pod2man < $^ > $@

install: $(TARGETS)
	mkdir -p $(DESTDIR)/$(man1dir) $(DESTDIR)/$(bindir)
	install -m 444 $(PROG).1 $(DESTDIR)/$(man1dir)
	if [ -d .git ]; then								\
	  VERSION=`git describe --tags --match 'v[0-9]*'`;				\
	  sed "s/{UNTAGGED}/$${VERSION}/" $(PROG) > $(DESTDIR)/$(bindir)/$(PROG);	\
	  chmod 755 $(DESTDIR)/$(bindir)/$(PROG);					\
	else										\
	  install -m 755 $(PROG) $(DESTDIR)/$(bindir)/;					\
	fi

README: $(PROG)
	pod2text < $(PROG) > README

release: README
	@VERSION=`git describe --exact-match --match 'v[0-9]*' 2>/dev/null | sed 's/^v//'`;					\
	  if [ $$? -ne 0 -o "$$VERSION" = "" ]; then echo "Not a tagged version, you may not release"; exit 3; fi;		\
	  if [ `git status --porcelain | wc -l` -gt 0 ]; then echo "Uncommitted changes, you may not release"; exit 2; fi;	\
	  git checkout-index -a -f --prefix=/tmp/$(PACKAGE)-$$VERSION/;								\
	  cd /tmp/$(PACKAGE)-$$VERSION;												\
	  sed -i "s/{UNTAGGED}/$${VERSION}/" $(PROG);										\
	  cd ..;														\
	  tar czf $(PACKAGE)-$$VERSION.tar.gz $(PACKAGE)-$$VERSION;								\
	  rm -rf /tmp/$(PACKAGE)-$$VERSION;											\
	  echo /tmp/$(PACKAGE)-$$VERSION.tar.gz

clean nuke:
	rm -rf $(JUNK) *~ core* \#*
