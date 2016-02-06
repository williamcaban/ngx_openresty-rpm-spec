.PHONY: clean all

all:
	./BUILD-and-INSTALL.sh go

clean:
	rm SOURCES/*.gz
