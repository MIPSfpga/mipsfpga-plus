#!/bin/sh

cat \
lab_yp2_0.html \
lab_yp2_1.html \
lab_yp2_2.html \
lab_yp2_3.html \
lab_yp2_z.html \
> lab_yp2.html

aspell -l < lab_yp2.html | sort -u > zzz_misspelled
