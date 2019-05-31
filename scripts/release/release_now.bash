#!/bin/bash

rm -rf   ~/mipsopen_ssd
mkdir -p ~/mipsopen_ssd
mkdir -p ~/mipsopen_ssd/mipsopen
cp -r ../../.* ../../* ~/mipsopen_ssd/mipsopen
cd ~/mipsopen_ssd/mipsopen

rm -rf \
./documentation/html_to_imgtec_forum_converter \
./documentation/html_labs \
./documentation/connecting_instructions \
./documentation/slides/MIPS Open Introduction - 4JUNE2019 v1.0.pptx \
./documentation/html_labs_mips_open \
./documentation/html_labs_in_russian \
./documentation/edited_figures \
./documentation/figure_generator \
./documentation/html_labs_for_blog \
./scripts/release \

exit

# Variant without git files

rm -rf \
./.git \
./documentation/html_to_imgtec_forum_converter \
./documentation/html_labs \
./documentation/connecting_instructions \
./documentation/slides/MIPS Open Introduction - 4JUNE2019 v1.0.pptx \
./documentation/html_labs_mips_open \
./documentation/html_labs_in_russian \
./documentation/edited_figures \
./documentation/figure_generator \
./documentation/html_labs_for_blog \
./scripts/release \
./.gitignore \
./programs/12_linux/.gitignore \
./documentation/.gitignore \
./core/.gitignore \

