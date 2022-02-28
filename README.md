# PString Implementation In Assembly
An implementation in x86-64-Assembly of library functions that enable some of the functionality offered by string library in C, in Assembly.

First, the main function asks for the strings: the first pstring's length, the first pstring's content, the second pstring's length and the second pstring's content.

Next, the user should enter an operation number from the following options:

- [x] 0 – Print the strings's sizes
- [x] 1 – Receive two characters and swap all appearances of the first character with the second character in both pstrings.
- [x] 2 – Receive two indexes and copy substring (from start index to end index) from the second pstring to the first one.
- [x] 3 – Swap between upper and lower cases in both pstrings.
- [x] 4 – Receive two indexes and make a lexicographical comparison between the char at the first index in the first pstring to the char at the second index in the second pstrings.

## The functionality implemented:
- [x] `char pstrlen(Pstring* pstr)` - return pstring's sizes.
- [x] `Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar)` - replace all of the char in the pstring.
- [x] `Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j)` - copy the chars in src[i:j] to dst[i:j].
- [x] `Pstring* swapCase(Pstring* pstr)` - Swap between upper and lower cases.
- [x] `int pstrijcmp(Pstring* pstr1, Pstring* pstr2, char i, char j)` - compare between src[i:j] to dst[i:j].
