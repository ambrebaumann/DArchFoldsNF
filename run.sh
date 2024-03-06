#!/bin/bash

nextflow main.nf    \
    --coverage 0.9 \
    --identity 0.5 \
    --covMode 2 \
    --yourDB myDB \
    --doAlignForCovId true \
    --doAlignForPos true