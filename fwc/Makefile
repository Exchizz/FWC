install:
	install -m 700 -g root -o root -D fwc ${DESTDIR}/usr/local/sbin/fwc
	install -m 700 -g root -o root -D fwc_policy ${DESTDIR}/usr/local/sbin/fwc_policy
	install -m 700 -g root -o root -D fwc_zone ${DESTDIR}/usr/local/sbin/fwc_zone
	mkdir -p $(DESTDIR)/etc/firewall/generated
clean:
	@rm ${DESTDIR}/usr/local/sbin/fwc
	@rm ${DESTDIR}/usr/local/sbin/fwc_policy
	@rm ${DESTDIR}/usr/local/sbin/fwc_zone
	
