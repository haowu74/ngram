#!/bin/bash
# Description:
# Tests the command line binary ngramperplexity.

bin=../bin
testdata=$srcdir/testdata
tmpdata=${TMPDIR:-/tmp}
tmpprefix="${tmpdata}/ngramperp-earnest"

trap "rm -f ${tmpprefix}*" 0 2 13 15

set -e
compile_test_fst() {
  if [ ! -e "${tmpdata}/ngramperp-${1}.ref" ]
  then
    fstcompile \
      -isymbols="${testdata}/${1}.sym" -osymbols="${testdata}/${1}.sym" \
      -keep_isymbols -keep_osymbols -keep_state_numbering \
      "${testdata}/${1}.txt" "${tmpdata}/ngramperp-${1}.ref"
  fi
}

# Compile strings.
farcompilestrings \
  --symbols="${testdata}"/earnest.syms --keep_symbols=1 \
  "${testdata}"/earnest.txt >"${tmpprefix}".far

compile_test_fst earnest-witten_bell.mod
"${bin}/ngramperplexity" --OOV_probability=0.01 \
  "${tmpprefix}"-witten_bell.mod.ref "${tmpprefix}".far "${tmpprefix}".perp

cmp "${testdata}"/earnest.perp "${tmpprefix}".perp

echo PASS
