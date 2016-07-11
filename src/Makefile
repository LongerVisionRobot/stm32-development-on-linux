# src Makefile
include ../Makefile.common

# Do not remove startup.o below, or it could not load.
VPATH=startup
OBJS=startup.o
# use newlib
OBJS+=newlib_stubs.o
CFLAGS_USE_NEWLIB=-ffunction-sections -fdata-sections -fno-builtin

# Write down your source folder and obj-files
# in some case you should put stm32f10x_it.o here
VPATH+=main
OBJS+=main.o
OBJS+=usart.o

#VPATH+=led
#OBJS+=led.o
#OBJS+=key_led.o

all: src
src: app.a

app.a: $(OBJS)
		cd startup && $(AR) cr ../app.a $(OBJS)
$(OBJS):%.o: %.c
		$(CC) -c $< -o startup/$*.o $(CFLAGS) $(CFLAGS_USE_NEWLIB)


.PHONY: src clean tshow

clean:
		rm -f app.a 
		cd startup && rm -f $(OBJS)
tshow:
		@echo "-------------------------------------------------"
		@echo "optimize settings: $(InfoTextLib), $(InfoTextSrc)"
		@echo "-------------------------------------------------"
