# Interble

The name interble come from the word "Interpreted" and "Terrible" combined, thus interble.

Interble is originally written in Lua and planned to be rewritten in C++.
This language work with what I call 'order code', or in other word just code index. Note that index code starts from 1 not 0.

There's no comment in the language(yet), so if you want a command to be ignored remove the semicolon at the end of every code you want the interpreter to ignore

Here is some examples.

Hello, World!

Interble:
```
This code will run a simple "Hello, World!" program
0000:x48;  [H]
0000:x65;  [e]
0000:x6C;  [l]
0000:x6C;  [l]
0000:x6F;  [0]
0000:x2C;  [,]
0000:x20;  [space]
0000:x57;  [W]
0000:x6F;  [o]
0000:x72;  [r]
0000:x6C;  [l]
0000:x64;  [d]
0000:x21;  [!]
0000:x0A;  [\n]

```
C :
```
#include <stdio.h>
int main(void) {

  printf("Hello, World!\n");
  
  return 0;
}
```

Normal control flow is possible in interble. but it is quite complicated

Example of a infinte loop that counts forever

Interble:
```
An infinite loop

0002:&10;           [1, load variable at address 10]
0003:#1;            [2, save the value 0 at the current address]
0000:&10;           [3, write out the value at current pointer]
0000:x0A;           [4, write a new line (\n)]
0005:&10;           [5, increment the current variable]
0004:#3;            [6, jump to order code 3]
```
C :
```
#include <stdio.h>
#include <stdbool.h>

int main(void) {
  int i = 0;
  while (true) {
    printf("%i\n", i)
    i++;
  };
}
```


