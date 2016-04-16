# src Makefile
include ../Makefile.common

# Do not del startup.o, or it could not load.
OBJS=startup.o

# use newa
OBJS+=newlib_stubs.o
CFLAGS_USE_NEWLIB=-ffunction-sections -fdata-sections -fno-builtin

# Add your project files, FORMAT: [ *.o ]
OBJS+=main.o
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
