#!/bin/sh

NIM="nim --verbosity:0 --hints:off "$@""

output() {
  printf "%-20s %6s\n" $1 $(wc -c < $1)
  #./$1
}

echo "== Using the C Standard Library =="

# hello1.nim
$NIM -o:hello_unoptimized c hello
output hello_unoptimized

$NIM -d:release -o:hello_release c hello
output hello_release

$NIM -d:release --opt:size -o:hello_optsize c hello
output hello_optsize

$NIM -d:release --opt:size -o:hello_optsize_strip c hello
strip -s hello_optsize_strip
output hello_optsize_strip

$NIM --gc:none -d:release --opt:size -o:hello_gcnone c hello
strip -s hello_gcnone
output hello_gcnone

$NIM --os:standalone -d:release -o:hello_standalone c hello
strip -s hello_standalone
output hello_standalone

echo
echo "== Disregarding the C Standard Library =="

# hello2.nim
$NIM --os:standalone -d:release --passL:-nostdlib c hello2
strip -s hello2
output hello2

# hello3.nim
$NIM --os:standalone -d:release --passL:-nostdlib --noMain --passC:-ffunction-sections --passC:-fdata-sections --passL:-Wl,--gc-sections c hello3
strip -s hello3
output hello3

echo
echo "== Custom Linking =="

custom_elf() {
  $NIM --app:staticlib --os:standalone -d:release --noMain --passC:-ffunction-sections --passC:-fdata-sections --passL:-Wl,--gc-sections c $1
  ld --gc-sections -e _start -T script.ld -o payload nimcache/$1.o
  objcopy -j combined -O binary payload payload.bin
  ENTRY=$(nm -f posix payload | grep '^_start ' | awk '{print $3}')
  nasm -f bin -o $1_custom -D entry=0x$ENTRY elf.s
  chmod +x $1_custom
  output $1_custom
}

custom_elf hello3

# hello4.nim
custom_elf hello4
