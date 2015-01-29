# slickc
My SlickEdit Slick-C Macros

This repository contains all of my Slick-C macros that I currently use.

# Macros for All Languages

**Paste Comment**

*all/paste_comment.e*

This macro allows you to paste the clipboard contents directly into a source
file and it will be automatically formatted as a block comment.  The
characters used for the block comment are the characters that are
setup for a block comment for the current language mode.

**Navigate to Next/Previous Function**

*all/next_prev_func.e*

These two macros navigate to the next or previous function in the editor.
It will automatically position the function two lines from the top.  If
there is a block comment above the function, the macro will place the
comment at the top before the function, so that the entire comment is
visible at the top of the editor.

This allows you to quickly navigate through the functions in a file while
keeping you eyes at the top line of the editor, instead of scrolling
manually through a file by paging up and down, which causes the functions
to appear on any abitrary line in the editor.
								     
# C++ Macros

**Algorithm Mnemonics**

*cpp/algorithm_mnemonics.e

Do you get tired of typing begin(v) and end(v) when using STL algorithms?
Or do you have a hard time remembering all the different algorithms?

Then Algorithm Mnemonics is for you!

Algorithm mnemonics uses the dynamic surround text feature of SlickEdit
to make it easy to use and remember STL algorithms.  For example, let's
say you want to use the count algorithm, you would first type in your
container:

```
  vector<int> v;
  v <cursor-here>
```

Next, you type the *surround with* keyboard shortcut (I use Alt-S).
Now you type your algorithm mnemonic you want to use.  In this case it
would be `cnt` and press enter.  The following will be automatically
expanded:
 
```
  vector<int> v;
  auto num = count( begin(v), end(v), <cursor-here> );
```

There is a three letter mnemonic for every STL algorithm.  I actually
created flash cards and memorized them all!  No more typing begin, end, or
looking up algorithms in a reference. 

In addition, some of the mnemonics will write the lambda for you,
for example the count_if menemonic `cni` will expand to:

```
  auto num = count_if( begin(v), end(v), [](const auto& elem) {
  } ); 
```

Enjoy!

**New Class**

*cpp/new_class*

Provides a dialog interface to the mktools for custom code templates.
Requires the mktools binaries located in the mktools repository.

*cpp/make_func.e

Implements the method on the current line inside of a class declaration.

**Edit Test File**

*cpp/edit_test_file.e*

Edits the counterpart test file located in the tests directory.


