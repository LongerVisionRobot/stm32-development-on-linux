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
# Extract info contained in ELF to readable text-files:
	@$(READELF) -a $(PROGRAM_NAME).elf > $(PROGRAM_NAME).info_elf
	@$(OBJDUMP) -S $(PROGRAM_NAME).elf > $(PROGRAM_NAME).info_code
	@$(NM) -t d -S --size-sort -s $(PROGRAM_NAME).elf > $(PROGRAM_NAME).info_symbol
# convert to hex and bin
#	@$(OBJCOPY) -O binary $(PROGRAM_NAME).elf $(PROGRAM_NAME).bin
	@$(OBJCOPY) -O ihex $(PROGRAM_NAME).elf $(PROGRAM_NAME).hex
	@$(SIZE) -d -B $(PROGRAM_NAME).elf $(PROGRAM_NAME).hex > $(PROGRAM_NAME).info_size
# display binaries size
	@echo -------------------------------------------------------
	@cat $(PROGRAM_NAME).info_size

.PHONY: libs src clean tshow cleanall erase

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
#	use JLink for linux
	@echo 'power on' > $(JLINKEXE_SCRIPT)
	@echo 'loadfile $(PROGRAM_NAME).hex' >> $(JLINKEXE_SCRIPT)
	@echo 'r' >> $(JLINKEXE_SCRIPT)
	@echo 'go' >> $(JLINKEXE_SCRIPT)
	@echo 'qc' >> $(JLINKEXE_SCRIPT)
	JLinkExe -Device $(SUPPORTED_DEVICE) -Speed 4000 -If SWD $(JLINKEXE_SCRIPT)
#	use openOCD
#	perl ./do_flash.pl $(TOP)/$(PROGRAM_NAME).bin  

erase:
	@echo 'power on' > $(JLINKEXE_SCRIPT)
	@echo 'erase' >> $(JLINKEXE_SCRIPT)
	@echo 'qc' >> $(JLINKEXE_SCRIPT)
	JLinkExe -Device $(SUPPORTED_DEVICE) -Speed 4000 -If SWD $(JLINKEXE_SCRIPT)
