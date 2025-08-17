# Lex/Flex Programming Guide - বাংলায়

## Lex/Flex কি?

**Lex** (Lexical Analyzer Generator) হলো একটি টুল যা **tokenization** এর জন্য ব্যবহৃত হয়। এটি text/code কে ছোট ছোট অংশে (tokens) ভাগ করে। **Flex** হলো Lex এর আধুনিক ভার্সন।

## কেন ব্যবহার করি?

- **Compiler Design** এ প্রথম ধাপ
- **Pattern Matching** এর জন্য
- Text processing এর জন্য
- Programming language এর syntax analysis এর জন্য

---

## Lex File এর গঠন (Structure)

```lex
%{
    /* C header code এখানে লিখি */
    #include <stdio.h>
    int count = 0;  // global variables
%}

%%
    /* Rules Section - Pattern এবং Action */
pattern1    { action1 }
pattern2    { action2 }

%%
    /* C code section - main function */
int main() {
    yylex();  // lexer চালানোর জন্য
    return 0;
}

int yywrap() { return 1; }  // input শেষ হলে 1 return করে
```

---

## গুরুত্বপূর্ণ Functions এবং Variables

### Built-in Variables:

- `yytext` - বর্তমানে match হওয়া text
- `yyleng` - yytext এর length
- `yylineno` - বর্তমান line number

### Built-in Functions:

- `yylex()` - main lexer function
- `input()` - একটি character read করে
- `unput(c)` - একটি character কে input stream এ ফেরত পাঠায়
- `yywrap()` - input শেষ হলে call হয়

---

## Regular Expression Patterns

| Pattern      | অর্থ               | উদাহরণ             |
| ------------ | ------------------ | ------------------ |
| `[a-z]`      | lowercase letters  | a, b, c            |
| `[A-Z]`      | uppercase letters  | A, B, C            |
| `[0-9]`      | digits             | 0, 1, 2            |
| `+`          | এক বা একাধিকবার    | `[0-9]+` = 123, 45 |
| `*`          | শূন্য বা একাধিকবার | `[a-z]*` = "", abc |
| `.`          | যেকোনো character   | a, 1, @            |
| `\n`         | newline            |                    |
| `\t`         | tab                |                    |
| `\"string\"` | exact string match | "if", "while"      |

---

## প্রতিটি Code এর বিস্তারিত ব্যাখ্যা

### 1. Keyword, Number, Word Detector (`01_keyword_num_word.l`)

**উদ্দেশ্য:** C keywords, numbers এবং words আলাদা করা

```lex
if|else|while|for|return|int|float|double {printf("Keyword: %s\n", yytext);}
[0-9]+                   {printf("Number : %s\n", yytext);}
[a-zA-Z]+                {printf("Word : %s\n",yytext);}
```

**ব্যাখ্যা:**

- `if|else|while...` - C এর keywords গুলো detect করে
- `[0-9]+` - যেকোনো সংখ্যা (১ বা তার বেশি digit)
- `[a-zA-Z]+` - যেকোনো word (letters only)

---

### 2. Capital Words Detector (`02_capital_words.l`)

**উদ্দেশ্য:** শুধু বড় হাতের অক্ষরের words খুঁজে বের করা

```lex
[A-Z]+[ \t\n]           {printf("Capital Word: %s\n",yytext);}
```

**ব্যাখ্যা:**

- `[A-Z]+` - এক বা একাধিক capital letter
- `[ \t\n]` - space, tab বা newline দিয়ে শেষ

---

### 3. Vowels & Consonants Counter (`03_no_of_vowels_consonants.l`)

**উদ্দেশ্য:** স্বরবর্ণ ও ব্যঞ্জনবর্ণ গণনা

```lex
[aeiouAEIOU]        {vowelCnt++;}
[a-zA-Z]            {if (!(vowel_check)) consonantCnt++;}
```

**ব্যাখ্যা:**

- প্রথমে vowels count করে
- তারপর letters check করে যেগুলো vowel নয়

---

### 4. Simple vs Compound Sentence (`04_simple_compound_sentence.l`)

**উদ্দেশ্য:** বাক্য simple না compound তা বের করা

```lex
and|or|but|so|because|if|then|yet|nevertheless      {isCompound = 1;}
```

**ব্যাখ্যা:**

- যদি conjunction words পায় তাহলে compound
- না পেলে simple sentence

---

### 5. Lines, Words, Spaces, Characters Counter (`05_count_no_of_lines_words_spaces_chars.l`)

```lex
\n              { lineCnt++; charCnt++; }
[ \t]           { spaceCnt++; charCnt++; }
[^ \t\n]+       { wordCnt++; charCnt += yyleng; }
```

**ব্যাখ্যা:**

- `\n` - newline count করে
- `[ \t]` - space/tab count করে
- `[^ \t\n]+` - space/tab/newline ছাড়া সব (words)
- `yyleng` - current match এর length

---

### 6. Comment Lines Counter (`06_count_comments.l`)

**সবচেয়ে জটিল code! এটা বুঝি:**

```lex
"//".*              { commentLines++; }
"/*"                {
                      int c;
                      commentLines++;
                      while((c = input()) != 0) {
                        if(c == '\n') commentLines++;
                        if(c == '*') {
                          if((c = input()) == '/') break;
                          else unput(c);
                        }
                      }
                    }
```

**ব্যাখ্যা:**

#### Single Line Comment (`//`):

- `"//".*` - `//` থেকে line এর শেষ পর্যন্ত সব
- সহজ, একটা line count বাড়ায়

#### Multi Line Comment (`/* ... */`):

1. `"/*"` পেলে comment শুরু
2. `input()` দিয়ে একটা একটা character read করি
3. `\n` পেলে line count বাড়াই
4. `*` পেলে check করি পরেরটা `/` কিনা
5. যদি `*/` হয় তাহলে comment শেষ (break)
6. যদি শুধু `*` হয় তাহলে `unput(c)` দিয়ে character টা ফেরত দিই

#### `unput(c)` কেন ব্যবহার?

**সমস্যা:** আমরা `*` পেলে next character read করি। যদি সেটা `/` না হয়?

**সমাধান:** `unput(c)` দিয়ে সেই character কে input stream এ ফেরত পাঠাই যাতে পরবর্তী iteration এ আবার read হয়।

**উদাহরণ:**

```c
/* This is a * not end comment */
```

এখানে middle এর `*` এর পরে space আছে, `/` নেই। তাই space কে unput করে ফেরত দিতে হবে।

---

### 7. Expression Parser (`07_expression_identifier_operators.l`)

```lex
[a-zA-Z][a-zA-Z0-9]*   { printf("Identifier: %s\n", yytext); }
[0-9]+                  { printf("Number: %s\n", yytext); }
[+\-*/=]                { printf("Operator: %s\n", yytext); }
```

**ব্যাখ্যা:**

- Identifier: letter দিয়ে শুরু, তারপর letter/digit
- Number: শুধু digits
- Operator: `+`, `-`, `*`, `/`, `=`

---

### 8. Simple Calculator (`08_simple_calculator.l`)

```lex
[0-9]+      { if(num1==0) num1 = atoi(yytext); else num2 = atoi(yytext); }
[+\-*/]     { op = yytext[0]; }
```

**ব্যাখ্যা:**

- প্রথম number `num1` এ store করে
- operator store করে
- দ্বিতীয় number `num2` এ store করে
- main() এ calculation করে

---

## How to Compile & Run

### Step 1: Generate C code

```bash
flex filename.l
```

### Step 2: Compile with GCC

```bash
gcc lex.yy.c -o output_file -ll
```

### Step 3: Run

```bash
./output_file
```

---

## Common Mistakes & Solutions

### 1. **Compilation Error: "unrecognized rule"**

**কারণ:** Pattern syntax ভুল
**সমাধান:** Quotes use করুন string এর জন্য

### 2. **Infinite Loop**

**কারণ:** `unput()` ভুল ব্যবহার
**সমাধান:** নিশ্চিত হন যে character আবার same rule এ match না করে

### 3. **No Output**

**কারণ:** Pattern match হচ্ছে না
**সমাধান:** Pattern গুলো test করুন

### 4. **yywrap() undefined**

**সমাধান:** সবসময় `int yywrap() { return 1; }` add করুন

---

## Tips for Beginners

1. **Simple থেকে শুরু করুন** - প্রথমে single pattern দিয়ে test করুন
2. **Debug করুন** - `printf()` দিয়ে দেখুন কোন pattern match হচ্ছে
3. **Pattern order গুরুত্বপূর্ণ** - specific patterns আগে লিখুন
4. **Test thoroughly** - বিভিন্ন input দিয়ে test করুন
5. **Documentation পড়ুন** - Flex manual helpful

---

**Happy Coding! 🚀**

_যেকোনো সমস্যায় এই README এর pattern গুলো follow করুন এবং step by step approach নিন।_
