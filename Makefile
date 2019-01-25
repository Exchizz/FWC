COMPONENTS=firewall fwc

install:
	for A in ${COMPONENTS}; do make -C $$A install; done
	install -D firewall.service /etc/systemd/system/firewall.service

enable:
	@systemctl enable firewall

disable:
	@test -f /etc/systemd/system/firewall.service && sudo systemctl disable --quiet firewall || true

clean: disable
	@rm -f /etc/systemd/system/firewall.service

	for A in ${COMPONENTS}; do make -C $$A clean; done
