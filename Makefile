test:
	vusted --shuffle
.PHONY: test

doc:
	nvim --headless -i NONE -n +"lua dofile('./spec/lua/lreload/doc.lua')" +"quitall!"
	cat ./doc/lreload.nvim.txt
	cat ./README.md
.PHONY: doc
