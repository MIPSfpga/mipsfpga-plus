#!/bin/sh

cat \
lab_mo2_0.html \
../lab_mo_note.html \
lab_mo2_1.html \
lab_mo2_2.html \
lab_mo2_3.html \
lab_mo2_z.html \
> lab_mo2.html

#aspell -l < lab_mo2.html | sort -u > zzz_misspelled
