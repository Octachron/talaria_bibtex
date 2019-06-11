build:
	dune build @install

.PHONY:tests
tests:
	dune runtest

clean:
	dune clean
