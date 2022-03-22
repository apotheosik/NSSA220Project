#! /bin/bash
iostatdata=$(iostat)

drive="nvme0n1"

kbwps=$(iostat | grep "$drive" | awk '{FS="\t"; print $4}')

kbw=$(df | grep "\/$" | awk '{print $3 * 0.001024}' | bc)
echo $kbwps $kbw

