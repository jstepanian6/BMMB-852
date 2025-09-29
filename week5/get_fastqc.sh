#!/bin/bash

set -uexo pipefail

#Parameters
OUTPUT=/home/jstepanian/Documents/AppliedBioinfo/week5/fastqc
INPUT=/home/jstepanian/Documents/AppliedBioinfo/week5/reads


#--------- NO CHANGES BELOW THIS LINE --------

fastqc -o ${OUTPUT} ${INPUT}/*
