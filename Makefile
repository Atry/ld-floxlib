VERSION = 0.2

ld-floxlib.so: ld-floxlib.c
	$(CC) -o $@ -shared $< $(CFLAGS)

install: ld-floxlib.so
	mkdir -p $(PREFIX)/lib
	cp $< $(PREFIX)/lib
