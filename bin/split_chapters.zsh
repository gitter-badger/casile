#!/usr/bin/env zsh
set -e

src=$1
base=${src/.md}
dir=${base}-chapters

mkdir -p $dir

i=0
of=$dir/000.md
chapters=()

while read line; do
	# Stop processing if we've hit footnotes
	[[ $line =~ "^\[\^1\]: .*" ]] && break

	# Check for chapter header
	if [[ $line =~ "^# .*" ]]; then
		[[ $line =~ ".*unnumbered.*" ]] || let i=$i+1
		of=$dir/$(printf %02d $i).md
		chapters+=($of)
		echo $of
		cp /dev/null $of
	fi
	>> $of <<< $line
done < $src

# Truncate source to just footnotes
sed -i -n -e '/^\[\^1\]: /,$p' $src

# Put footnotes in all files, renumber, and generally cleanup
for chapter in $chapters; do
	>> $chapter < $src
	pandoc $chapter --atx-headers --wrap=none --to=markdown |
		sponge $chapter
	git add $chapter
done

# Make source an index to the chapters
> $src <<< "esyscmd([[loadchapters.zsh $dir/<0->-*.md]])"
git add $src
