	testbench.v
	../core/rv32im/*.v

	+incdir+../core/rv32im
	-cpp g++-4.8 -cc gcc-4.8
	-LDFLAGS -Wl,-no-as-needed
