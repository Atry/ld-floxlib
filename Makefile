VERSION = 0.2

ld-floxlib.so: ld-floxlib.c
	$(CC) $(CFLAGS) -shared -nostdlib -fPIC $< -o $@ -Wl,--exclude-libs,ALL -Wl,-Bstatic -lc

install: ld-floxlib.so
	mkdir -p $(PREFIX)/lib
	cp $< $(PREFIX)/lib
