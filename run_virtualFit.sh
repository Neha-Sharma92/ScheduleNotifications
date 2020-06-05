#!/bin/bash
set -e

if [ "$#" -ne 2 ]; then
    echo "ERROR: run_smartfit.sh requires two inputs: relative path to the person image and relative path to the clothing image."
    exit
fi

# Set variables
person_img=$PWD"/"$1
clothing_img=$PWD"/"$2

# Clean directories
rm -f  image_parsing/output/*
rm -f  image_pose/output/*
rm -f  tryVirtualDress/VITON/data/segment/*
rm -f  tryVirtualDress/VITON/data/pose.pkl
rm -f  tryVirtualDress/VITON/data/pose/*
rm -f  tryVirtualDress/VITON/data/women_top/*
rm -rf tryVirtualDress/VITON/results/*
rm -f  output/output.png

# Run image parsing
printf "\nRunning image  parsing...\n\n"
cd image_parsing/
./run_image_parsing.py $person_img

# Run pose estimation
printf "\nRunning image pose...\n\n"
cd ../image_pose/
python run_image_pose.py $person_img --output ../output/

# Move output to target directories in tryVirtualDress/
cd ../
cp image_parsing/output/*.mat tryVirtualDress/VITON/data/segment/
cp image_pose/output/pose.pkl tryVirtualDress/VITON/data/
cp image_pose/output/*.mat tryVirtualDress/VITON/data/pose/

# Run tryVirtualDress
printf "\nRunning image tryVirtualDress...\n\n"
cd tryVirtualDress/
./run_tryVirtualDress.sh $person_img $clothing_img

# Copy output to main output directory
cp VITON/results/stage2/images/*final.png ../output/output.png

