PREFIX = ${DESTDIR}/etc/firewall/
FILES = $(shell find  . -maxdepth 1 -name '*.sh' -printf "%f\n")

DST = $(addprefix $(PREFIX),$(FILES))

.PHONY: install
install: $(DST)

define GENERIC_template =
 $(PREFIX)$(1): $(1)
endef

$(foreach file,$(FILES),$(eval $(call GENERIC_template,$(file))))


$(DST):
	install -m 700 -g root -o root -D $? $(PREFIX)$?
