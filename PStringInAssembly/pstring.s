
.section .rodata

str_invalid:   .string "invalid input!\n"

   .text   #the beginnig of the code


# ########################################## pstrlen class

   .globl  pstrlen
   .type   pstrlen, @function
pstrlen:
   pushq    %rbp              # save the old frame pointer
   movq     %rsp, %rbp        # create the new frame pointer
   pushq    %rdx

   movq     (%rdi), %rsi      # first string length
   and      $255, %rsi        # remove redundant bytes
   movq     %rsi,%rax

   popq     %rdx
   # movq     $0, %rax        # return value is zero
   movq     %rbp, %rsp        # restore the old stack pointer - release all used memory.
   popq     %rbp              # restore old frame pointer (the caller function frame)
   ret                        # return to caller function (func_select)


# ########################################## replaceChar class

   .globl  replaceChar
   .type   replaceChar, @function
replaceChar:
   pushq    %rbp           # save the old frame pointer
   movq     %rsp, %rbp     # create the new frame pointer
   pushq    %r8
   pushq    %r9

   # iterate the string
.loop1:
   add      $1, %rdi       # advance the string pointer by 1
   movq     (%rdi), %r8    # get current char
   and      $255, %r8      # remove redundant bytes
   cmp      $0, %r8        # check if we got the end of the string
   je       .finishReplaceChar
   cmp      %r8, %rsi      # check if the current char needs to be replaced
   jne      .loop1
   movb     %dl, (%rdi)    # replace the char
   jmp      .loop1

.finishReplaceChar:
   popq     %r9
   popq     %r8
   movq     $0, %rax       # return value is zero
   movq     %rbp, %rsp     # restore the old stack pointer - release all used memory.
   popq     %rbp           # restore old frame pointer (the caller function frame)
   ret                     # return to caller function (func_select)


# ########################################## pstrijcpy class

   .globl  pstrijcpy
   .type   pstrijcpy, @function
pstrijcpy:
   pushq    %rbp              # save the old frame pointer
   movq     %rsp, %rbp        # create the new frame pointer
   pushq    %r8
   pushq    %r9
   pushq    %rbx

   # check the parameters
   movq     (%rdi), %r9       # dst pstring length
   and      $255, %r9         # remove redundant bits
   movq     (%rsi), %r8       # src pstring length
   and      $255, %r8         # remove redundant bits

.checkIneg:
   cmp      $0, %rdx
   jb      .ifIneg
   jmp     .checkJneg
.ifIneg:
   add      $256, %rdx 
   jmp     .checkJneg
.checkJneg:
   cmp      $0, %rcx
   jb      .ifJneg
   jmp     .moreParametersCheck
.ifJneg:
   add      $256, %rcx 
   jmp     .moreParametersCheck

.moreParametersCheck:
   cmp      %rdx, %r9         # check i < dst length
   jbe      .invalid
   cmp      %rcx, %r9         # check j < dst length
   jbe      .invalid
   cmp      %rdx, %r8         # check i < src length
   jbe      .invalid
   cmp      %rcx, %r8         # check j < src length
   jbe      .invalid
   cmp      %rdx, %rcx        # check i < j
   jb       .invalid

   # iterate the string
   add      %rdx, %rdi        # put in rdi the address of dst[i-1]
   add      %rdx, %rsi        # put in rsi the address of src[i-1]
   sub      $1, %rdx
.loop2:
   add      $1, %rdi          # advance the dst to the next char
   add      $1, %rsi          # advance the src to the next char
   add      $1, %rdx          # increment i
   cmp      %rdx, %rcx        # check i <= j
   jb       .finish2
   movq     (%rsi), %rbx      # get the current char of src
   and      $255, %rbx        # remove redundant bytes
   movb     %bl, (%rdi)       # replace the char in dst
   jmp      .loop2

.invalid:
   # print "invalid input!"
   leaq     str_invalid(%rip), %rdi
   movq     $0,%rax
   pushq    %r8                  # save r8 because printf uses it
   pushq    %r9                  # save r9 because printf uses it
   call     printf
   popq     %r9                  # restore r9
   popq     %r8                  # restore r8

.finish2:
   # restore the registers
   popq     %rbx
   popq     %r9
   popq     %r8
   movq     $0, %rax       # return value is zero
   movq     %rbp, %rsp     # restore the old stack pointer - release all used memory.
   popq     %rbp           # restore old frame pointer (the caller function frame)
   ret                     # return to caller function (func_select)


# ########################################## swapCase class

   .globl  swapCase
   .type   swapCase, @function
swapCase:
   pushq    %rbp           # save the old frame pointer
   movq     %rsp, %rbp     # create the new frame pointer
   pushq    %r8
   pushq    %rdx

   # iterate the string
.loop3:
   add      $1, %rdi
   movq     (%rdi), %r8    # get current char
   and      $255, %r8      # remove redundant bytes
   cmp      $0, %r8        # check if we got the end
   je       .finish3
   cmp      $122, %r8      # check if the char > 'z'  */* z = 122 in ASCII code
   ja       .loop3          # jump if the char > 'z'
   cmp      $97, %r8      # check if the char >= 'a' */* a = 97 in ASCII  code
   jae      .toUpper        # jump if the char between 'a' to 'z'
   cmp      $90, %r8      # check if the char > 'Z' */* Z = 90 in ASCII code
   ja       .loop3          # jump if the char > 'Z' 
   cmp      $65, %r8      # check if the char >= 'A' */* A = 65 in ASCII code
   jae      .toLower        # jump if the char between 'A' to 'Z'
   jmp      .loop3          # jump if the char < 'a' */* a = 97 in ASCII  code
.toUpper:
   movq     %r8, %rdx      # make the char upper by substracting
   sub      $97, %rdx      # a = 97 in ASCII  code
   add      $65, %rdx      # A = 65 in ASCII code
   movb     %dl, (%rdi)    # replace the char by putting it in the place in the string
   jmp      .loop3
.toLower:
   movq     %r8, %rdx      # make the char upper by adding 
   sub      $65, %rdx      # A = 65 in ASCII code
   add      $97, %rdx      # a = 97 in ASCII  code
   movb     %dl, (%rdi)    # replace the char by putting it in the place in the string
   jmp      .loop3

.finish3:
   # restore the registers
   popq     %rdx
   popq     %r8
   movq     $0, %rax       # return value is zero
   movq     %rbp, %rsp     # restore the old stack pointer - release all used memory.
   popq     %rbp           # restore old frame pointer (the caller function frame)
   ret                     # return to caller function (func_select)


# ########################################## pstrijcmp class

   .globl  pstrijcmp
   .type   pstrijcmp, @function
pstrijcmp:
   pushq    %rbp           # save the old frame pointer
   movq     %rsp, %rbp     # create the new frame pointer
   pushq    %rbx
   pushq    %r8
   pushq    %r9

   # check the parameters
   movq     (%rsi), %r8    # first string length
   and      $255, %r8      # remove redundant bits
   movq     (%rdi), %r9    # second string length
   and      $255, %r9      # remove redundant bits

.checkIneg2:
   cmp      $0, %rdx       # check if i < 0
   jb      .ifIneg2
   jmp     .checkJneg2
.ifIneg2:
   add      $256, %rdx     # if i<0 we want to add 256 and than we will get unseen
   jmp     .checkJneg2
.checkJneg2:
   cmp      $0, %rcx       # check if j < 0
   jb      .ifJneg2
   jmp     .moreParametersCheck2
.ifJneg2:
   add     $256, %rcx      # if i<0 we want to add 256 and than we will get unseen
   jmp     .moreParametersCheck2

.moreParametersCheck2:
   cmp      %rdx, %r8      # check if i < first string length
   jbe      .invalid2
   cmp      %rcx, %r8      # check if j < first string length
   jbe      .invalid2
   cmp      %rdx, %r9      # check if i < second string length
   jbe      .invalid2
   cmp      %rcx, %r9      # check if j < second string length
   jbe      .invalid2
   cmp      %rdx, %rcx     # check i<=j
   jb       .invalid2

    # iterate the string
   add      %rdx, %rsi     # add i to the first pstring address
   add      %rdx, %rdi     # add i to the second pstring address
   sub      $1, %rdx
.loop4:
   add      $1, %rsi       # advance the first pstring by 1
   add      $1, %rdi       # advance the second pstring by 1
   add      $1, %rdx       # advance i by 1
   mov      $0, %rax       # default return value is 0 if we finished
   cmp      %rdx, %rcx     # check i <= j
   jb       .finish4
   movq     (%rsi), %rax   # get current char of the first pstring
   and      $255, %rax     # remove redundant bytes
   movq     (%rdi), %rbx   # get current char of the second pstring
   and      $255, %rbx     # remove redundant bytes
   cmp      %rax, %rbx     # check if the letters are the same
   je       .loop4         # its means that thay have the same letter
   cmp      %rax, %rbx     # check if the letter of pstring 2 is bigger than the letter of pstring 1
   ja       .secondPstringBigger # its means that thay have the second pstring is bigger
   mov      $-1, %rax      # return -1 because the first pstring is bigger
   jmp      .finish4
.secondPstringBigger:
   mov      $1, %rax       # return 1 because the second pstring is bigger
   jmp      .finish4

.invalid2:
   # print "invalid value!"
   leaq     str_invalid(%rip), %rdi
   movq     $0,%rax
   pushq     %r9
   pushq     %r8
   call     printf
   popq     %r9
   popq     %r8
   movq     $-2,%rax

.finish4:
   popq     %r9
   popq     %r8
   popq     %rbx
   movq     %rbp, %rsp     # restore the old stack pointer - release all used memory.
   popq     %rbp           # restore old frame pointer (the caller function frame)
   ret                     # return to caller function (func_select)
