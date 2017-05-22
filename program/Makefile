%.hex: %.bin
	od -An --endian=big -tx4 -v -w32 $< > $@

%.bin: %.o
	mips-unknown-linux-objcopy -O binary -j .text $< $@

%.o: %.s
	mips-unknown-linux-as -o $@ $<
