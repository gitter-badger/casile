#!/usr/bin/env perl

use utf8;
use open ':std', ':encoding(UTF-8)';

# Fixup "00. Foo" and "00.foo" to have narrow non-breaking spaces
while (<>) {
  s#(?<=\d)\.\s+(?=\p{Ll})#. #g;
  s#(?<=\d)\.(?=\p{L})#. #g;
  print;
}
