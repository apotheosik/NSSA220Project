#!/bin/bash

ps -aux | grep APM | head -n -1 | awk '{print $4}'