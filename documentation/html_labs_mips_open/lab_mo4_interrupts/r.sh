#!/bin/sh

cat \
lab_yp4_0.html \
lab_yp4_1.html \
lab_yp4_2.html \
lab_yp4_3.html \
lab_yp4_4.html \
lab_yp4_5.html \
lab_yp4_a.html \
lab_yp4_b.html \
lab_yp4_c.html \
lab_yp4_z.html \
> lab_yp4.html

aspell list < lab_yp4.html | sort -u > zzz_misspelled
