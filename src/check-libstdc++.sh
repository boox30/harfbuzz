#!/bin/sh

LC_ALL=C
export LC_ALL

test -z "$srcdir" && srcdir=.
test -z "$libs" && libs=.libs
stat=0


if which ldd 2>/dev/null >/dev/null; then
	:
else
	echo "check-libstdc++.sh: 'ldd' not found; skipping test"
	exit 77
fi

tested=false
for suffix in so dylib; do
	so=$libs/libharfbuzz.$suffix
	if ! test -f "$so"; then continue; fi

	echo "Checking that we are not linking to libstdc++ or libc++"
	if ldd $so | grep 'libstdc[+][+]\|libc[+][+]'; then
		echo "Ouch, linked to libstdc++ or libc++"
		stat=1
	fi
	tested=true
done
if ! $tested; then
	echo "check-libstdc++.sh: libharfbuzz shared library not found; skipping test"
	exit 77
fi

exit $stat
