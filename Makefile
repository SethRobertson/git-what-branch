prefix=/usr/local
bindir=${prefix}/bin
mandir=${prefix}/share/man
man1dir=${mandir}/man1

TARGETS=git-what-branch

all: $(TARGETS)

install: $(TARGETS)
	mkdir -p $(DESTDIR)/$(bindir)
	install -m 755 $^ $(DESTDIR)/$(bindir)/

clean nuke:
	rm -rf $(JUNK) *~ core* \#*
