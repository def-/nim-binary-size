# Nim binary size from 160 KB to 150 Bytes

## [Accompanying blog article](http://hookrace.net/blog/binary-size-nim/)

Uses the [nim-syscall](https://github.com/def-/nim-syscall) library.

## x86-64

Results from the article, on Linux x86-64 with GCC 5.1 and Clang 3.6.0:

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

## x86

Works on 32bit x86 now, also with GCC 5.1 and Clang 3.6.0:

    $ ./run32.sh
    == Using the C Standard Library ==
    hello_unoptimized    147301
    hello_release         60001
    hello_optsize         23127
    hello_optsize_strip   17836
    hello_gcnone           9636
    hello_standalone       5520

    == Disregarding the C Standard Library ==
    hello2                 1488
    hello3                  696

    == Custom Linking ==
    hello3_custom           127
    hello4_custom           119

    $ ./run32.sh --cc:clang
    == Using the C Standard Library ==
    hello_unoptimized    143221
    hello_release         27261
    hello_optsize         23165
    hello_optsize_strip   17888
    hello_gcnone           9688
    hello_standalone       5564

    == Disregarding the C Standard Library ==
    hello2                  832
    hello3                  484

    == Custom Linking ==
    hello3_custom           126
    hello4_custom           118

    $ ./objdump -rd nimcache/hello4.o
    ...
    00000000 <_start>:
       0:	53                   	push   %ebx
       1:	b8 04 00 00 00       	mov    $0x4,%eax
       6:	bb 01 00 00 00       	mov    $0x1,%ebx
       b:	b9 08 00 40 00       	mov    $0x400008,%ecx
      10:	ba 07 00 00 00       	mov    $0x7,%edx
      15:	cd 80                	int    $0x80
      17:	b8 01 00 00 00       	mov    $0x1,%eax
      1c:	31 db                	xor    %ebx,%ebx
      1e:	cd 80                	int    $0x80
      20:	5b                   	pop    %ebx
      21:	c3                   	ret    
    ...
