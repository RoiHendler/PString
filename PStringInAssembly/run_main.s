
  .section    .rodata #read only data section
# str1:   .string "%d"
 str1:   .string "%hhu"
str2:   .string "%s"
str3:   .string "%d"


   .text   #the beginnig of the code
   
   # .globl  main
   # .type   main, @function # the label "main" representing the beginning of a function

  .globl  run_main
  .type   run_main, @function # the label "main" representing the beginning of a function
  # run_main
run_main:   # the main function:
   # Getting two pstrings - their length and then the strings
   # Then getting the function number and calling func_select

   pushq   %rbp        # save the old frame pointer
   movq    %rsp, %rbp    # create the new frame pointer
   subq    $560, %rsp   # allocate space in stack
   
   # scanf("%hhu") - first string length
   leaq    -257(%rbp), %rsi 
   leaq    str1(%rip), %rdi
   movq    $0, %rax
   call    scanf
   # scanf("%s") - first string 
   leaq    -256(%rbp), %rsi # the second parameter to scanf - the place in the stack for the number
   leaq    str2(%rip), %rdi # the first parameter to scanf - "%s"
   movq    $0, %rax
   call    scanf

   # scanf("%hhu") - second string length
   leaq    -514(%rbp), %rsi # the second parameter to scanf - the place in the stack for the number
   leaq    str1(%rip), %rdi # the first parameter to scanf - "%d"
   movq    $0, %rax
   call    scanf
   # scanf("%s") - second string
   leaq    -513(%rbp), %rsi # the second parameter to scanf - the place in the stack for the number
   leaq    str2(%rip), %rdi # the first parameter to scanf - "%s"
   movq    $0, %rax
   call    scanf

   # scanf("%d") - the function number
   leaq    -522(%rbp), %rsi # the second parameter to scanf - the place in the stack for the number
   leaq    str3(%rip), %rdi # the first parameter to scanf - "%d"
   movq    $0, %rax
   call    scanf

   leaq     -257(%rbp), %rsi   # string a
   leaq     -514(%rbp), %rdx   # string b
   movl     -522(%rbp), %edi   # function number
   call     func_select 

   movq     $0, %rax    # return value is zero
   movq     %rbp, %rsp  # restore the old stack pointer - release all used memory.
   popq     %rbp        # restore old frame pointer (the caller function frame)
   ret                  # return to caller function (OS)
