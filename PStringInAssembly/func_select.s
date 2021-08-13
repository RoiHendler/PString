
   .section .rodata
str:   .string "func_select %d\n"
str_invalid:   .string "invalid option!\n"
str_f52:       .string "\n%c %c"
str_f52_out:   .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
# str_f53:       .string "\n%d\n%d"
str_f53:       .string "\n%hhu\n%hhu"
# str_f53_out1:   .string "length: %d, string: %s\n"
str_f52_out1:   .string "old char: %c, new char: %c,"
str_f52_out2:   .string " first string: %s, second string: %s\n"


str_f53_out:   .string "length: %d, string: %s\nlength: %d, string: %s\n"
str_f55:       .string "compare result: %d\n"
str_pstrlen1:  .string "first pstring length: %d,"
str_pstrlen2:  .string " second pstring length: %d\n"

# jump table
   .align 8
.jump_table:
   .quad .f50      # index 0 (num 50)
   .quad .wrong    # index 1 (num 51)
   .quad .f52      # index 2 (num 52)
   .quad .f53      # index 3 (num 53)
   .quad .f54      # index 4 (num 54)
   .quad .f55      # index 5 (num 55)
   .quad .wrong    # index 6 (num 56)
   .quad .wrong    # index 7 (num 57)
   .quad .wrong    # index 8 (num 58)
   .quad .wrong    # index 9 (num 59)
   .quad .f50      # index 10 (num 60)


   .text   #the beginnig of the code
   .globl  func_select
   .type   func_select, @function
func_select:
   # Getting two pstrings and a function number
   # Going to the function according to the number using the jump table

   pushq    %rbp        # save the old frame pointer
   movq     %rsp, %rbp  # create the new frame pointer
   pushq    %r8         # save r8
   pushq    %r9         # save r9
   subq     $16, %rsp   # allocate space in stack

   # save the strings that we got from run_main as parameters
   movq     %rsi, %r8   # the first pstring address
   movq     %rdx, %r9   # the second pstring address

   # check the function is between 50 - 60
.checkFunctionNumber:
   cmp      $50, %di
   jl       .wrong
   cmp      $60, %di
   jg      .wrong
   # sub 50 to get indext between 0 and 10 in the jump table
   sub      $50, %rdi
   # get the entry from the jump table by the index in rdi and jump to it
   jmp      *.jump_table(,%rdi,8)

.f50:
   movq     %r8, %rdi   # the address of the first pstring
   pushq    %r9
   call     pstrlen

.printTheFirstStr:   # print the first str_pstrlen1
   movq     %rax,%rsi
   leaq     str_pstrlen1(%rip), %rdi  # format string for printf
   movq     $0,%rax
   call     printf
   popq     %r9

   movq     %r9, %rdi   # the address of the second pstring
   call     pstrlen

.printTheSecondstStr:   # print the second str_pstrlen2
   movq     %rax,%rsi
   leaq     str_pstrlen2(%rip), %rdi  # format string for printf
   movq     $0,%rax
   call     printf

   jmp      finish

.f52:
# scanf for the old and new chars
   leaq     -16(%rbp), %rdx      # the new char place
   leaq     -8(%rbp), %rsi       # the old char place
   leaq     str_f52(%rip), %rdi  # the format string "%c %c"
   pushq    %r8                  # save r8 because scanf uses it
   pushq    %r9                  # save r9 because scanf uses it
   movq     $0, %rax
   call     scanf
   popq     %r9                  # restore r9
   popq     %r8                  # restore r8
   


    # ###################################################################

   # call the function for each of the strings
   movq     -16(%rbp), %rdx      # put the new char in rdx
   movq     -8(%rbp), %rsi       # put the old char in rsi
   and      $255, %rdx
   and      $255, %rsi
   movq     %r8, %rdi            # put the first pstring address in rdi
   call     replaceChar          # call for the first string
   movq     -16(%rbp), %rdx      # put the new char in rdx
   and      $255, %rdx
   movq     -8(%rbp), %rsi       # put the old char in rsi
   and      $255, %rsi
   movq     %r9, %rdi            # put the second pstring address in rdi
   call     replaceChar          # call for the second string

   # print the results
   movl     -8(%rbp), %esi       # the old char
   movl     -16(%rbp), %edx      # the new char
   and      $255, %rsi
   and      $255, %rdx
   leaq     str_f52_out1(%rip), %rdi # the format string for printf
   movq     $0,%rax
   pushq    %r8                  # save r8 because printf uses it
   pushq    %r9                  # save r8 because printf uses it
   call     printf
   popq     %r9                  # restore r9
   popq     %r8                  # restore r8

   addq     $1,%r8
   addq     $1,%r9
   movq     %r8,%rsi              # the first string address
   movq     %r9,%rdx              # the second string address

   leaq     str_f52_out2(%rip), %rdi # the format string for printf
   movq     $0,%rax
   pushq    %r8                  # save r8 because printf uses it
   pushq    %r9                  # save r8 because printf uses it
   call     printf
   popq     %r9                  # restore r9
   popq     %r8                  # restore r8

   jmp      finish

    # ###################################################################

  # call the function for each of the strings
  # movq     -16(%rbp), %rdx      # put the new char in rdx
  # and      $255, %rdx
  # movq     -8(%rbp), %rsi       # put the old char in rsi
  # and      $255, %rsi
  # movq     %r8, %rdi            # put the first pstring address in rdi
  # call     replaceChar          # call for the first string
  # movq     -16(%rbp), %rdx      # put the new char in rdx
  # and      $255, %rdx
  # movq     -8(%rbp), %rsi       # put the old char in rsi
  # and      $255, %rsi
  # movq     %r9, %rdi            # put the second pstring address in rdi
  # call     replaceChar          # call for the second string

   # print the results
  # movl     -8(%rbp), %esi       # the old char
  # movl     -16(%rbp), %edx      # the new char

  # addq     $1,%r8
  # addq     $1,%r9
  # movq    %r8,%rcx              # the first string address
  # movq    %r9,%r8               # the second string address
   
  # leaq     str_f52_out(%rip), %rdi # the format string for printf
  # movq     $0,%rax
  # call     printf

  # jmp      finish
# #################################################################
.f53:
   # get the indices i,j
   leaq     -16(%rbp), %rdx      # the place for j
   leaq     -8(%rbp), %rsi       # the place for i
   leaq     str_f53(%rip), %rdi  # the format string "%d\n%d"
   movq     $0, %rax
   pushq    %r8                  # save r8 because scanf uses it
   pushq    %r9                  # save r9 because scanf uses it
   call     scanf
   popq     %r9                  # restore r9
   popq     %r8                  # restore r8


   # call the function
   movq     %r8, %rdi            # first pstring - the dst parameter
   movq     %r9, %rsi            # second pstring - the src parameter
   movl     -8(%rbp), %edx       # i - rdx
   movl     -16(%rbp), %ecx      # j - rcx
   and      $255, %edx           # remove redundant bytes
   and      $255, %ecx           # remove redundant bytes
   call     pstrijcpy

   # print the results
   movq     (%r8), %rsi          # first pstring length
   and      $255, %rsi           # remove redundant bytes

   addq     $1,%r8
   movq     %r8,%rdx              # first string   

   movq     (%r9), %rcx          # second pstring length
   and      $255, %rcx           # remove redundant bytes

   addq     $1,%r9
   movq     %r9,%r8              # second string  

   leaq     str_f53_out(%rip), %rdi # format string for printf
   movq     $0,%rax
   pushq    %r9                  # save r9 because printf uses it
   call     printf
   popq     %r9                  # restore r9

   jmp      finish

.f54:
   # call the function for each of the pstrings
   movq     %r8, %rdi            # first pstring
   call     swapCase
   movq     %r9, %rdi            # second pstring
   call     swapCase

   # print the results
   movq     (%r8), %rsi          # first string length
   and      $255, %rsi
   addq     $1,%r8
   movq     %r8,%rdx              # first string   

   movq     (%r9), %rcx          # second string length
   and      $255, %rcx
 #  leaq     1(%r9), %r8          # second string

   addq     $1,%r9
   movq     %r9,%r8              # second string  

   leaq     str_f53_out(%rip), %rdi
   movq     $0,%rax
   call     printf
   
   jmp      finish

.f55:
   # get the indices i,j
   leaq     -16(%rbp), %rdx      # j
   leaq     -8(%rbp), %rsi       # i
   leaq     str_f53(%rip), %rdi
   movq     $0, %rax
   pushq    %r8                  # save r8 because scanf uses it
   pushq    %r9                  # save r9 because scanf uses it
   call     scanf
   popq     %r9                  # restore r9
   popq     %r8                  # restore r8
   
   # call the function
   movq     %r8, %rdi            # first pstring
   movq     %r9, %rsi            # second pstring
   movl     -8(%rbp), %edx       # i
   movl     -16(%rbp), %ecx      # j

   and      $255, %edx           # remove redundant bytes
   and      $255, %ecx           # remove redundant bytes

   call     pstrijcmp

   # print the results
   movq     %rax, %rsi           # function result
   leaq     str_f55(%rip), %rdi
   movq     $0, %rax
   pushq    %r8                  # save r8 because printf uses it
   pushq    %r9                  # save r9 because printf uses it
   call     printf
   popq     %r9                  # restore r9
   popq     %r8                  # restore r8

   jmp      finish

.wrong:
   # print "invalid option!"
   leaq    str_invalid(%rip), %rdi
   pushq    %r8                  # save r8 because printf uses it
   pushq    %r9                  # save r9 because printf uses it
   movq    $0,%rax
   call    printf
   popq     %r9                  # restore r9
   popq     %r8                  # restore r8

finish:
   popq    %r9
   popq    %r8
   movq    $0, %rax    # return value is zero (just like in c - we tell the OS that this program finished seccessfully)
   movq    %rbp, %rsp  # restore the old stack pointer - release all used memory.
   popq    %rbp        # restore old frame pointer (the caller function frame)
   ret                  # return to caller function (OS)
