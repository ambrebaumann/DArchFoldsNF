#!/bin/bash

nextflow main.nf    \
    --coverage 0.8 \
    --identity 0.4 \
    --covMode 2 \
    --nameFirstDB firstDB \
    --doAlignForCovId false \
    --doAlignForPos false 