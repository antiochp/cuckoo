# -Wno-deprecated-declarations shuts up Apple OSX clang
FLAGS = -std=c99 -Wall -Wno-deprecated-declarations -D_POSIX_C_SOURCE=200112L -O3 -pthread -l crypto
# leave out -l crypto if using sha256.c instead of openssl

cuckoo:		cuckoo.h cuckoo_miner.h cuckoo_miner.c Makefile
	cc -o cuckoo -DSHOW -DPROOFSIZE=6 -DSIZEMULT=1 -DSIZESHIFT=4 cuckoo_miner.c ${FLAGS}

example:	cuckoo
	./cuckoo -e 100 -h header

cuckoo110:	cuckoo.h cuckoo_miner.h cuckoo_miner.c Makefile
	cc -o cuckoo110 -DSIZEMULT=1 -DSIZESHIFT=10 cuckoo_miner.c ${FLAGS}

cuckoo115:	cuckoo.h cuckoo_miner.h cuckoo_miner.c Makefile
	cc -o cuckoo115 -DSIZEMULT=1 -DSIZESHIFT=15 cuckoo_miner.c ${FLAGS}

cuckoo120:	cuckoo.h cuckoo_miner.h cuckoo_miner.c Makefile
	cc -o cuckoo120 -DSIZEMULT=1 -DSIZESHIFT=20 cuckoo_miner.c ${FLAGS}

verify120:	cuckoo.h cuckoo.c Makefile
	cc -o verify120 -DSIZEMULT=1 -DSIZESHIFT=20 cuckoo.c ${FLAGS}

test:	cuckoo120 verify120 Makefile
	./cuckoo120 -h 6 | tail -1 | ./verify120 -h 6

cuckoo125:	cuckoo.h cuckoo_miner.h cuckoo_miner.c Makefile
	cc -o cuckoo125 -DSIZEMULT=1 -DSIZESHIFT=25 cuckoo_miner.c ${FLAGS}

cuckoo128:	cuckoo.h cuckoo_miner.h cuckoo_miner.c Makefile
	cc -o cuckoo128 -DSIZEMULT=1 -DSIZESHIFT=28 cuckoo_miner.c ${FLAGS}

speedup:	cuckoo128 Makefile
	for i in {1..4}; do echo $$i; (time for j in {0..6}; do ./cuckoo128 -t $$i -h $$j; done) 2>&1; done > speedup

cuckoo130:	cuckoo.h cuckoo_miner.h cuckoo_miner.c Makefile
	cc -o cuckoo130 -DSIZEMULT=1 -DSIZESHIFT=30 cuckoo_miner.c ${FLAGS}

cuckoo729:	cuckoo.h cuckoo_miner.h cuckoo_miner.c Makefile
	cc -o cuckoo729 -DSIZEMULT=7 -DSIZESHIFT=29 cuckoo_miner.c ${FLAGS}

Cuckoo.class:	Cuckoo.java Makefile
	javac -O Cuckoo.java

CuckooMiner.class:	Cuckoo.java CuckooMiner.java Makefile
	javac -O Cuckoo.java CuckooMiner.java

java:	Cuckoo.class CuckooMiner.class Makefile
	java CuckooMiner -h 6 | tail -1 | java Cuckoo -h 6
