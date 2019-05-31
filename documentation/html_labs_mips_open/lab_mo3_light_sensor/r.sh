#!/bin/sh

cat \
lab_mo3_0.html \
../lab_mo_note.html \
lab_mo3_1.html \
lab_mo3_2.html \
lab_mo3_3.html \
lab_mo3_4.html \
lab_mo3_z.html \
> lab_mo3.html

#aspell -l < lab_mo3.html | sort -u > zzz_misspelled
