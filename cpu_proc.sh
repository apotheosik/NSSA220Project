#!/bin/bash

cpu=$(ps -aux | grep APM | head -n -1 | awk '{print $3}')
mem=$(ps -aux | grep APM | head -n -1 | awk '{print $4}')
echo $cpu $mem