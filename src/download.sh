#!/usr/bin/env bash


echo "Please Enter Your Username:"
read Username

echo "Please Enter Your Password:"
read -s Password

echo $Username

osascript_line="mount volume \"smb://$Username:$Password@GAGRI.garvan.unsw.edu.au/GRIW/GenomeInformatics/xiuque/GenomicInstability/data\""
osascript -e "$osascript_line"
rsync -vr /Volumes/data/vcf  ./data
rsync -vr /Volumes/data/stats  ./data


umount /Volumes/data