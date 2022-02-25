SHELL := /bin/bash
.PHONEY: watch

watch:
	entr dots install < <(fd)
