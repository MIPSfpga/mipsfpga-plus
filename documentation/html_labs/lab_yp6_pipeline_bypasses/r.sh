#!/bin/sh

cat \
lab_yp6_0.html \
lab_yp6_1.html \
lab_yp6_2.html \
lab_yp6_3.html \
lab_yp6_z.html \
> lab_yp6.html

aspell -l < lab_yp6.html | sort -u > zzz_misspelled
