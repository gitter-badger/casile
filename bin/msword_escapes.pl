#!/usr/bin/env perl

# WARNING: This can screw up valid Markdown if there are code snippets. Only
# run on prose that is actually broken and check the results.

use utf8;
use open ':std', ':encoding(UTF-8)';

# Fixup bad MS word typing habits that Pandoc tries to preserve
while (<>) {
  s#\\`#'#g;
  print;
}
