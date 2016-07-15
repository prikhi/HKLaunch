watch: build
	stack build --file-watch

clean:
	stack clean

maintainer-clean:
	stack clean --full



build: install ./src/** ./app/** hklaunch.cabal Setup.hs
	stack build

install: hklaunch.cabal
	stack install --only-dependencies
