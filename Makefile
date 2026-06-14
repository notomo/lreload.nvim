include spec/.shared/neovim-plugin.mk

spec/.shared/neovim-plugin.mk:
	git clone https://github.com/notomo/workflow.git --depth 1 --branch ntf spec/.shared

# lreload's specs edit and write shared on-disk fixtures, so they cannot run in
# parallel isolated workers (concurrent writes race on the same files).
test: FORCE deps
	$(MAKE) requireall
	$(NTF) --jobs=1 --shuffle ${SPEC_DIR}
