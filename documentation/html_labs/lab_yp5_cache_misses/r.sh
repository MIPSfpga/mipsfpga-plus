#!/bin/sh

cat \
lab_yp5_0.html \
lab_yp5_1.html \
lab_yp5_2.html \
lab_yp5_3.html \
lab_yp5_z.html \
> lab_yp5.html

aspell -l < lab_yp5.html | sort -u > zzz_misspelled
