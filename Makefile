# general Makefile
# make OptLIB=0 OptSRC=0 all tshow  
include Makefile.common
LDFLAGS=$(COMMONFLAGS) -fno-exceptions -ffunction-sections -fdata-sections -L$(LIBDIR) -nostartfiles -Wl,--gc-sections,-Tlinker.ld
LDFLAGS_USE_NEWLIB=--specs=nano.specs -lc -lnosys
LDLIBS+=-lstm32

all: libs src
	$(CC) -o $(PROGRAM_NAME).elf $(LDFLAGS) \
		-Wl,--whole-archive src/app.a \
		-Wl,--no-whole-archive \
		$(LDLIBS) $(LDFLAGS_USE_NEWLIB)
#Extract info contained in ELF to readable text-files:
	arm-none-eabi-readelf -a $(PROGRAM_NAME).elf > $(PROGRAM_NAME).info_elf
	arm-none-eabi-size -d -B -t $(PROGRAM_NAME).elf > $(PROGRAM_NAME).info_size
	arm-none-eabi-objdump -S $(PROGRAM_NAME).elf > $(PROGRAM_NAME).info_code
	arm-none-eabi-nm -t d -S --size-sort -s $(PROGRAM_NAME).elf > $(PROGRAM_NAME).info_symbol
# binary execute hex and bin
	$(OBJCOPY) -O ihex $(PROGRAM_NAME).elf $(PROGRAM_NAME).hex
	$(OBJCOPY) -O binary $(PROGRAM_NAME).elf $(PROGRAM_NAME).bin

.PHONY: libs src clean tshow cleanall

libs:
	$(MAKE) -C libs $@
src:
	$(MAKE) -C src $@
cleanall:clean
	$(MAKE) -C libs clean
clean:
	$(MAKE) -C src $@
	rm -f $(PROGRAM_NAME).elf $(PROGRAM_NAME).hex $(PROGRAM_NAME).bin $(PROGRAM_NAME).info_elf $(PROGRAM_NAME).info_size $(PROGRAM_NAME).info_code $(PROGRAM_NAME).info_symbol

# show optimize settings
tshow:
		@echo "-------------------------------------------------"
		@echo "optimize settings: $(InfoTextLib), $(InfoTextSrc)"
		@echo "-------------------------------------------------"

flash:all
	./do_flash.pl $(TOP)/$(PROGRAM_NAME).bin  
