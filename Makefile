# This Makefile is meant to be used on a x86_64 host ONLY.
# It may also work on plain x86 but that's not guaranteed.
# Other platforms require a lot of changes.

ARCH = x86_64
NIM = nim
NIMFLAGS = --verbosity:0 --hints:off
AS = as
OBJCOPY = objcopy
STRIP = strip

ifeq ($(ARCH),x86)
NIMFLAGS += --cpu:i386 --passC:-m32 --passL:-m32
AS += --32
LD += -melf_i386
endif

default: all

# Using the C Standard Library

hello0: hello1.nim
	$(NIM) $(NIMFLAGS) -o:$@ c $<

hello1: NIMFLAGS += -d:release --opt:size --gc:none
hello1: hello1.nim
	$(NIM) $(NIMFLAGS) -o:$@ c $<
	$(STRIP) $@

# Disregarding the C Standard Library

hello2: NIMFLAGS += --os:standalone -d:release --passL:-nostdlib
hello2: NIMFLAGS += --noMain --passC:-ffunction-sections --passC:-fdata-sections
hello2: NIMFLAGS += --passL:-Wl,--gc-sections
hello2: hello2.nim
	$(NIM) $(NIMFLAGS) -o:$@ c $<
	$(STRIP) -s $@

# Custom Linking

custom = hello3 hello4
custom.o = $(patsubst %,nimcache/%.o,$(custom))
$(custom.o): NIMFLAGS += --app:staticlib --os:standalone -d:release --noMain
$(custom.o): NIMFLAGS += --passC:-ffunction-sections --passC:-fdata-sections
$(custom.o): panicoverride.nim

nimcache/%.o: %.nim
	$(NIM) $(NIMFLAGS) c $<

custom.elf = $(patsubst %,%.elf,$(custom))
$(custom.elf): %.elf: nimcache/%.o elf_$(ARCH).o script.ld
	$(LD) --gc-sections -T script.ld -o $@ elf_$(ARCH).o $<

ifeq ($(ARCH),x86_64)
hello4_x32 = hello4_x32
hello4_x32.elf: nimcache/hello4.o elf_x86_32.o script.ld
	$(LD) --gc-sections -T script.ld -o $@ elf_x86_32.o $<
endif

.INTERMEDIATE: hello3.elf hello4.elf hello4_x32.elf

all = hello0 hello1 hello2 hello3 hello4 $(hello4_x32)
all: $(all)

%: %.elf
	$(OBJCOPY) -O binary $< $@

.s.o:
	$(AS) -o $@ $<

clean:
	rm -f *.o *.elf *.a
	rm -fr nimcache
	rm -f $(all)
