build:
    ca65 src/main.asm -o src/main.o -g
    ld65 -C src/nes.cfg src/main.o -o src/game.nes

clean:
    #!/bin/sh
    cd src
    rm *.nes *.o || true

run:
	fceux src/game.nes