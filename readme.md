# Nim binary size from 160 KB to 150 Bytes

## [Accompanying blog article](http://hookrace.net/blog/binary-size-nim/)

Uses the [nim-syscall](https://github.com/def-/nim-syscall) library.

All on Linux x86-64 with GCC 5.1 and Clang 3.6.0:

    $ nimble install syscall

    $ ./run.sh
    == Using the C Standard Library ==
    hello_unoptimized    163827
    hello_release         62131
    hello_optsize         25248
    hello_optsize_strip   18552
    hello_gcnone          10344
    hello_standalone       6208

    == Disregarding the C Standard Library ==
    hello2                 1776
    hello3                  952

    == Custom Linking ==
    hello3_custom           158
    hello4_custom           150

    $ objdump -rd nimcache/hello4.o
    ...
    0000000000000000 <_start>:
     0: b8 01 00 00 00          mov    $0x1,%eax
     5: ba 07 00 00 00          mov    $0x7,%edx
     a: be 08 00 40 00          mov    $0x400008,%esi
     f: 48 89 c7                mov    %rax,%rdi
    12: 0f 05                   syscall 
    14: 31 ff                   xor    %edi,%edi
    16: b8 3c 00 00 00          mov    $0x3c,%eax
    1b: 0f 05                   syscall 
    1d: c3                      retq 
    ...

    $ ./run.sh --cc:clang
    == Using the C Standard Library ==
    hello_unoptimized    171989
    hello_release         33435
    hello_optsize         29339
    hello_optsize_strip   22704
    hello_gcnone          10400
    hello_standalone       6248

    == Disregarding the C Standard Library ==
    hello2                 1840
    hello3                  952

    == Custom Linking ==
    hello3_custom           160
    hello4_custom           152
