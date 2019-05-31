#!/bin/sh

cat \
lab_mo6_0.html \
lab_mo6_1.html \
lab_mo6_2.html \
lab_mo6_3.html \
lab_mo6_z.html \
> lab_mo6.html

aspell -l < lab_mo6.html | sort -u > zzz_misspelled
