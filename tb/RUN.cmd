	testbench.v
	../core/rv32imac/*.v

	+incdir+../core/rv32imac
	-cpp g++-4.8 -cc gcc-4.8
	-LDFLAGS -Wl,-no-as-needed
