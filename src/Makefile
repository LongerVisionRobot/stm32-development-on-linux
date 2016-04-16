# src Makefile
include ../Makefile.common

CFLAGS_USE_NEWLIB=-ffunction-sections -fdata-sections -fno-builtin

# Add your files to compile, FORMAT:[ *.o ]
OBJS+=startup.o
OBJS+=main.o
OBJS+=newlib_stubs.o
OBJS+=usart.o

all: src

src: app.a

app.a: $(OBJS)
		$(AR) cr app.a $(OBJS)
$(OBJS):%.o: %.c
		$(CC) -c $<  $(CFLAGS) $(CFLAGS_USE_NEWLIB)

.PHONY: src clean tshow

clean:
		rm -f app.a $(OBJS)
tshow:
		@echo "-------------------------------------------------"
		@echo "optimize settings: $(InfoTextLib), $(InfoTextSrc)"
		@echo "-------------------------------------------------"