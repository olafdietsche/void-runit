prefix ?= /usr/local
exec_prefix ?= ${prefix}
sysconfdir ?= ${prefix}/etc
sbindir ?= ${exec_prefix}/sbin
datarootdir ?= ${prefix}/share
libdir ?= ${exec_prefix}/lib
mandir ?= ${datarootdir}/man
man1dir ?= ${mandir}/man1
man8dir ?= ${mandir}/man8

SCRIPTS = 1 2 3 ctrlaltdel

all:
	$(CC) $(CFLAGS) $(LDFLAGS) halt.c -o halt $(LDLIBS)
	$(CC) $(CFLAGS) $(LDFLAGS) pause.c -o pause $(LDLIBS)
	$(CC) $(CFLAGS) $(LDFLAGS) vlogger.c -o vlogger $(LDLIBS)

install:
	install -d ${DESTDIR}${sbindir}/
	install -m755 halt ${DESTDIR}${sbindir}/
	install -m755 pause ${DESTDIR}${sbindir}/
	install -m755 vlogger ${DESTDIR}${sbindir}/
	install -m755 shutdown ${DESTDIR}${sbindir}/shutdown
	install -m755 modules-load ${DESTDIR}${sbindir}/modules-load
	install -m755 zzz ${DESTDIR}${sbindir}/
	ln -sf zzz ${DESTDIR}${sbindir}/ZZZ
	ln -sf halt ${DESTDIR}${sbindir}/poweroff
	ln -sf halt ${DESTDIR}${sbindir}/reboot
	install -d ${DESTDIR}${man1dir}/
	install -m644 pause.1 ${DESTDIR}${man1dir}/
	install -d ${DESTDIR}${man8dir}/
	install -m644 zzz.8 ${DESTDIR}${man8dir}/
	install -m644 shutdown.8 ${DESTDIR}${man8dir}/
	install -m644 halt.8 ${DESTDIR}${man8dir}/
	install -m644 modules-load.8 ${DESTDIR}${man8dir}/
	install -m644 vlogger.8 ${DESTDIR}${man8dir}/
	ln -sf halt.8 ${DESTDIR}${man8dir}/poweroff.8
	ln -sf halt.8 ${DESTDIR}${man8dir}/reboot.8
	install -d ${DESTDIR}${sysconfdir}/sv
	install -d ${DESTDIR}${sysconfdir}/runit/runsvdir/
	install -d ${DESTDIR}${sysconfdir}/runit/core-services/
	install -m644 core-services/*.sh ${DESTDIR}${sysconfdir}/runit/core-services/
	install -m755 ${SCRIPTS} ${DESTDIR}${sysconfdir}/runit/
	install -m644 functions $(DESTDIR)${sysconfdir}/runit/
	install -m644 crypt.awk  ${DESTDIR}${sysconfdir}/runit/
	install -m644 rc.conf ${DESTDIR}${sysconfdir}/
	install -m755 rc.local ${DESTDIR}${sysconfdir}/
	install -m755 rc.shutdown ${DESTDIR}${sysconfdir}/
	install -d ${DESTDIR}${libdir}/dracut/dracut.conf.d/
	install -m644 dracut/*.conf ${DESTDIR}${libdir}/dracut/dracut.conf.d/
	ln -sf /run/runit/reboot ${DESTDIR}${sysconfdir}/runit/
	ln -sf /run/runit/stopit ${DESTDIR}${sysconfdir}/runit/
	cp -R --no-dereference --preserve=mode,links -v runsvdir/* ${DESTDIR}${sysconfdir}/runit/runsvdir/
	cp -R --no-dereference --preserve=mode,links -v services/* ${DESTDIR}${sysconfdir}/sv/

clean:
	-rm -f halt pause vlogger

.PHONY: all install clean
