#!/bin/bash

subjects=("stj" "sys" "ysh")

# MICA
echo "Starting MICA processing"
for subject in "${subjects[@]}"; do
    cp ./data/$subject/$subject.png ./MICA/demo/input/$subject.png
done

cd MICA
conda activate MICA
python demo.py
echo "MICA processing completed"
conda deactivate
cd ..


# metrical-tracker
echo "Starting metrical-tracker processing"
for subject in "${subjects[@]}"; do
    echo "Copy $subject data to metrical-tracker"
    mkdir ./metrical-tracker/input/$subject
    cp ./MICA/demo/output/$subject/identity.npy ./metrical-tracker/input/$subject/identity.npy
    cp ./data/$subject/video.mp4 ./metrical-tracker/input/$subject/video.mp4
done

cd metrical-tracker
conda activate metrical-tracker
for subject in "${subjects[@]}"; do
    echo "Processing $subject"
    python tracker.py --cfg ./configs/actors/$subject.yml
done

conda deactivate
cd ..
echo "metrical-tracker processing completed"


# INSTA
echo "Starting INSTA processing"
conda activate rta
cd INSTA/scripts
for subject in "${subjects[@]}"; do
    echo "Processing $subject"
    ./generate.sh ../../metrical-tracker/output/$subject ../data/$subject 40
done
conda deactivate
cd ../..
echo "INSTA processing completed"
