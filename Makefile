build:
	jbuilder build @install

.PHONY:tests
tests:
	jbuilder runtest

clean:
	jbuilder clean
