COMPONENTS=firewall fwc

install:
	for A in ${COMPONENTS}; do make -C $$A install; done

