#!/bin/bash

scp src/cat/s21_cat src/grep/s21_grep anton@192.168.182.1:/home/anton/
ssh anton@192.168.182.1 'echo 1qaz2wsx | sudo -S mv s21* /usr/local/bin'
