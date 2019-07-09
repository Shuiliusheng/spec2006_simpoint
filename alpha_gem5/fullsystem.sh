#!/bin/bash

build/X86/gem5.opt configs/example/fs.py -n 2 --kernel=x86_64-vmlinux-2.6.22.9.smp --disk-image=linux-x86.img
