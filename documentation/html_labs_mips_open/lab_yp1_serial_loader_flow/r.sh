#!/bin/sh

cat \
lab_yp1_0.html \
lab_yp1_1.html \
lab_yp1_2.html \
lab_yp1_3.html \
lab_yp1_4_1.html \
lab_yp1_4_2.html \
lab_yp1_4_3.html \
lab_yp1_5_1_5_4.html \
lab_yp1_5_5_1.html \
lab_yp1_5_5_2.html \
lab_yp1_5_5_3.html \
lab_yp1_5_6.html \
lab_yp1_a.html \
lab_yp1_z.html \
> lab_yp1.html

aspell -l < lab_yp1.html | sort -u > zzz_misspelled
