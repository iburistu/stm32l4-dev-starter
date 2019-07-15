# STM32L4 Makefile

TARGET=# Your target here
OBJS=$(TARGET).o
INSTALLDIR=/usr/local/stmdev/
INCLUDE= # Optional include (if linking other files)
ARCH=STM32L476xx

CC=arm-none-eabi-gcc
LD=arm-none-eabi-ld
AS=arm-none-eabi-as
OBJCOPY=arm-none-eabi-objcopy

INCDIRS = -I$(INSTALLDIR)/include -I.
LIBDIRS = -L$(INSTALLDIR)/lib

# To include libece486 support, add -lece486_$(ARCH) and -lm to LIBS 
LIBS= -l$(ARCH) -lcmsis_dsp_$(ARCH)

LINKSCRIPT = $(INSTALLDIR)/lib/$(ARCH)_FLASH.ld

CFLAGS = -mcpu=cortex-m4 -mthumb -O3 -Wall  \
         -fomit-frame-pointer -fno-strict-aliasing -fdata-sections \
         -include stm32l4xx_hal_conf.h -DARM_MATH_CM4 -D$(ARCH) \
         -mfpu=fpv4-sp-d16 -mfloat-abi=softfp $(INCDIRS) \
         -fsingle-precision-constant -ffunction-sections \
		 -specs=nano.specs -specs=nosys.specs

LDFLAGS = -u _printf_float \
	  -Wl,-T$(LINKSCRIPT) \
	  -static \
	  -Wl,--gc-sections $(LIBDIRS) \


.PHONY : all flash clean debug

all: $(TARGET) $(TARGET).bin

debug : CFLAGS += -DDEBUG -g -Og
debug : LDFLAGS += -Wl,-Map,$(TARGET).map

debug : all

$(TARGET): $(OBJS)
	$(CC) $(INCLUDE) -o $(TARGET) $(CFLAGS) $(LDFLAGS) $(OBJS) $(LIBS)

$(TARGET).bin: $(TARGET)
	$(OBJCOPY) -Obinary $(TARGET) $(TARGET).bin

flash: $(TARGET).bin
	cp -f $(TARGET).bin ../device

clean:
	rm -f $(OBJS) $(TARGET) $(TARGET).bin $(TARGET).map
