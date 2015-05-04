import syscall

proc main {.exportc: "_start".} =
  discard syscall(EXIT, 0)
